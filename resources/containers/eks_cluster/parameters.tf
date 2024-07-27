locals {
  cluster_name = lower(replace("${var.project}-${terraform.workspace}-eks", "_", "-"))


}
locals {
  env = {
    default = {
      create = false

      cluster_name              = lower(replace("${var.project}-${terraform.workspace}-eks", "_", "-"))
      cluster_version           = "1.29" #1.25
      cluster_enabled_log_types = ["audit", "api", "authenticator", "controllerManager", "scheduler"]


      create_iam_role          = true
      iam_role_use_name_prefix = true

      vpc_id     = var.vpc_id
      subnet_ids = [element(var.private_subnets, 0), element(var.private_subnets, 1), element(var.private_subnets, 2)]
      #      control_plane_subnet_ids        = [element(var.private_subnets, 0), element(var.private_subnets, 1), element(var.private_subnets,2 )]
      cluster_endpoint_private_access = true
      cluster_endpoint_public_access  = true

      create_kms_key                  = true
      enable_kms_key_rotation         = true
      kms_key_deletion_window_in_days = 7
      cluster_encryption_config = {
        resources = ["secrets"]
      }

      create_cloudwatch_log_group            = true
      cloudwatch_log_group_retention_in_days = 30
      cloudwatch_log_group_kms_key_id        = var.kms_arn

      # EKS Addons
      cluster_addons = {
        eks-pod-identity-agent = {
          most_recent = true
        }
        kube-proxy = {
          most_recent = true
        }
        vpc-cni = {
          # Specify the VPC CNI addon should be deployed before compute to ensure
          # the addon is configured before data plane compute resources are created
          # See README for further details
          before_compute = true
          most_recent    = true # To ensure access to the latest settings provided
          configuration_values = jsonencode({
            env = {
              # Reference docs https://docs.aws.amazon.com/eks/latest/userguide/cni-increase-ip-addresses.html
              ENABLE_PREFIX_DELEGATION = "true"
              WARM_PREFIX_TARGET       = "1"
            }
          })
        }
        coredns = {
          most_recent = true

          timeouts = {
            create = "25m"
            delete = "10m"
          }
          configuration_values = jsonencode({
            computeType = "Fargate"
            # Ensure that we fully utilize the minimum amount of resources that are supplied by
            # Fargate https://docs.aws.amazon.com/eks/latest/userguide/fargate-pod-configuration.html
            # Fargate adds 256 MB to each pod's memory reservation for the required Kubernetes
            # components (kubelet, kube-proxy, and containerd). Fargate rounds up to the following
            # compute configuration that most closely matches the sum of vCPU and memory requests in
            # order to ensure pods always have the resources that they need to run.
            resources = {
              limits = {
                cpu = "0.25"
                # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
                # request/limit to ensure we can fit within that task
                memory = "256M"
              }
              requests = {
                cpu = "0.25"
                # We are targeting the smallest Task size of 512Mb, so we subtract 256Mb from the
                # request/limit to ensure we can fit within that task
                memory = "256M"
              }
            }
          })
        }
      }

      create_cluster_security_group          = true
      cluster_security_group_use_name_prefix = false
      cluster_additional_security_group_ids  = []
      # Extend cluster security group rules
      cluster_security_group_additional_rules = { #control plane
        ingress_nodes_ephemeral_ports_tcp = {
          description                = "Nodes on ephemeral ports"
          protocol                   = "tcp"
          from_port                  = 0
          to_port                    = 65535
          type                       = "ingress"
          source_node_security_group = true
        }
        ingress = {
          description                = "EKS Cluster allows 443 port to get API call"
          type                       = "ingress"
          from_port                  = 443
          to_port                    = 443
          protocol                   = "tcp"
          cidr_blocks                = ["0.0.0.0/0"]
          source_node_security_group = false
        }
      }

      create_node_security_group                   = true
      node_security_group_use_name_prefix          = false
      node_security_group_enable_recommended_rules = true
      # Extend node-to-node security group rules
      node_security_group_additional_rules = { #nodo a nodo
        ingress_self_all = {
          description = "Node to node all ports/protocols"
          protocol    = "-1"
          from_port   = 0
          to_port     = 0
          type        = "ingress"
          self        = true
        }

      }
      eks_managed_node_group_defaults = {
        iam_role_additional_policies = {
          # Not required, but used in the example to access the nodes to inspect mounted volumes
          AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
        }
      }

      # EKS Managed Node Groups
      eks_managed_node_groups = {
        default = {
          name            = "managed-ondemand"
          use_name_prefix = true
          subnet_ids      = [element(var.private_subnets, 0), element(var.private_subnets, 1), element(var.private_subnets, 2), element(var.private_subnets, 3)]
          min_size        = 2
          max_size        = 4
          #disk_size                             = 100
          desired_size               = 2
          ami_type                   = "AL2_x86_64"
          ami_id                     = data.aws_ami.eks_default.image_id
          instance_types             = ["t3.medium", "m5.large"]
          capacity_type              = "ON_DEMAND"
          force_update_version       = true
          enable_bootstrap_user_data = true
          #          use_custom_launch_template = false
          attach_cluster_primary_security_group = true
          create_iam_role                       = true
          taints = {
            dedicated = {
              key    = "dedicated"
              value  = "nodes"
              effect = "PREFER_NO_SCHEDULE"
            }
          }
          update_config = {
            max_unavailable_percentage = 33
          }
          description             = "EKS managed node group example launch template"
          ebs_optimized           = true
          disable_api_termination = false
          enable_monitoring       = true
          block_device_mappings = {
            xvda = {
              device_name = "/dev/xvda"
              ebs = {
                delete_on_termination = true
                encrypted             = true
                volume_size           = 50
                volume_type           = "gp3"

              }
            }
          }
        }

      }
      # To add the current caller identity as an administrator
      enable_cluster_creator_admin_permissions = true
      authentication_mode                      = "API_AND_CONFIG_MAP" #https://github.com/terraform-aws-modules/terraform-aws-eks/issues/3026


      access_entries = {
#         bastion_role = {
#           kubernetes_groups = []
#           principal_arn     = var.role_arn
#           type              = "STANDARD"
#           policy_associations = {
#             admin = {
#               policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
#               access_scope = {
#                 type = "cluster"
#               }
#             }
#           }
#         }
      }

      tags = {
        Environment = terraform.workspace
        Protected   = "Shared"
        layer       = "Containers"
      }
    }

    dev = {
      create = true
    }

    prod = {
      create = true
    }
  }
  environment_vars = contains(keys(local.env), terraform.workspace) ? terraform.workspace : "default"
  workspace        = merge(local.env["default"], local.env[local.environment_vars])
}


