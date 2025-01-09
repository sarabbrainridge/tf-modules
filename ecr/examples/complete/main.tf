provider "aws" {
  region = local.region
}

locals {
  region = "ca-central-1"
  name   = "${var.website}-ecr-${var.env}-${var.region_short_name}"

  account_id = data.aws_caller_identity.current.account_id

  tags = {
    Name       = local.name
  }
}

data "aws_caller_identity" "current" {}

################################################################################
# ECR Repository
################################################################################

/* module "ecr_disabled" {
  source = "../.."

  create = false
} */

module "ecr" {
  source = "../.."

  create = true
  repository_name = local.name

  repository_read_write_access_arns = [data.aws_caller_identity.current.arn]
  create_lifecycle_policy           = true
  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 100 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 100
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  repository_force_delete = true

  tags = local.tags
}

module "ecr_registry" {
  source = "../.."

  create_repository = false

  # Registry Policy
  create_registry_policy = false

  # Registry Scanning Configuration
  manage_registry_scanning_configuration = false
  registry_scan_type                     = "ENHANCED"

  # Registry Replication Configuration
  create_registry_replication_configuration = false
  tags = local.tags
}