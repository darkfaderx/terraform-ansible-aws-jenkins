#-------------------------------------------------
# Environment
#-------------------------------------------------

variable "env" {
  default = "test"
}

variable "region" {
  default = "us-west-2"
}

variable "target_region" {
  default = "us-east-1"
}

variable "profile" {
  default = "jijeesh"
}
variable "log_retention" {
  default = 365
}
variable "retentionDays" {
  default = "365"
}

# variable "vpc_id" {
#   type = "string"
# }

variable "name" {
  default = "jenkins"
  description = "Security group name"
}

variable "http_cidrs" {
  default = ["0.0.0.0/0"]
  description = "CIDRs for accessing the instance via HTTP(S)."
}

variable "ssh_cidrs" {
  default = ["0.0.0.0/0"]
  description = "CIDRs for accessing the instance via SSH."
}


# #-------------------------------------------------
# # Data Sources
# #-------------------------------------------------
#
# # retrieve aws account id
# data "aws_caller_identity" "current" {}
#
# # retrieve current region
# data "aws_region" "current" {}
#
# # Returns most recent Amazon ECS-Optimized Amazon Linux AMI
# data "aws_ami" "amazon_ecs_optimized" {
#   most_recent = true
#   filter {
#     name = "owner-alias"
#     values = ["amazon"]
#   }
#   filter {
#     name = "name"
#     values = ["amzn-ami-*-amazon-ecs-optimized"]
#   }
# }
#
# # Returns most recent HVM Amazon Linux AMI
# data "aws_ami" "amazon_linux" {
#   most_recent = true
#   filter {
#     name = "owner-alias"
#     values = ["amazon"]
#   }
#   filter {
#     name = "name"
#     values = ["amzn-ami-hvm-*-x86_64-gp2"]
#   }
# }

# Load global config
