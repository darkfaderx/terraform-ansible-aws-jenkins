# Variables for VPC module
module "ec2" {
	source = "../modules/ec2"
	name = "${var.name}"
  instance_type = "t2.micro"
	env = "${var.env}"
  key_name = "jijeesh"
	availability_zone = "${var.availability_zone}"
	ami_id = "${data.aws_ami.ubuntu.id}"
	dokcer_volume_id = "vol-0bce10b10a4ac920b"
	jenkins_volume_id = "vol-0d693142ab5545b2d"
	# vpc_id = "${module.vpc.vpc_id}"

}

# Variables for VPC module
# module "vpc" {
# 	source = "../modules/vpc"
# 	name = "${var.name}-${var.env}"
#   env = "${var.env}"
#
# }
