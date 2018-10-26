# Variables for VPC module
module "ec2" {
	source = "../modules/ec2"
	name = "${var.name}"
  instance_type = "t2.micro"
	env = "${var.env}"
  key_name = "jijeesh"
	availability_zone = "${var.availability_zone}"
	ami_id = "${data.aws_ami.ubuntu.id}"
	dokcer_volume_id = "vol-061d660d9af93ceec"
	jenkins_volume_id = "vol-02ba69c10c896fe6b"
	# vpc_id = "${module.vpc.vpc_id}"

}

# Variables for VPC module
# module "vpc" {
# 	source = "../modules/vpc"
# 	name = "${var.name}-${var.env}"
#   env = "${var.env}"
#
# }
