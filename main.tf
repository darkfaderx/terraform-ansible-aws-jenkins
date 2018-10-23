provider "aws" {
  version = "~> 1.16.0"
  region = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "${var.profile}"
}

resource "aws_instance" "jenkins_master" {
    # Use an Ubuntu image in eu-west-1
    #ami = "ami-f95ef58a"
    ami           = "${data.aws_ami.ubuntu.id}"

    instance_type = "t2.micro"

    tags {
        Name = "jenkins-master"
    }

    # We're assuming the subnet and security group have been defined earlier on

  #  subnet_id = "${aws_subnet.jenkins.id}"
    #security_group_ids = ["${aws_security_group.jenkins_master.id}"]
    associate_public_ip_address = true

    # We're assuming there's a key with this name already
    key_name = "jijeesh"

    # This is where we configure the instance with ansible-playbook
    provisioner "local-exec" {
        command = "sleep 220; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/amazon/jijeesh/jijeesh.pem -i '${aws_instance.jenkins_master.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
    }
}
