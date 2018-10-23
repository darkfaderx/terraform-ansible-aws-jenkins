// Create the VPC
resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
  # cidr_block           = "${var.vpc_cidr}"
  # enable_dns_support   = "${var.enable_dns_support}"
  # enable_dns_hostnames = "${var.enable_dns_hostnames}"

  tags {
    Name = "jenkins-vpc"
    environment =  "test"
  }

}

output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}
