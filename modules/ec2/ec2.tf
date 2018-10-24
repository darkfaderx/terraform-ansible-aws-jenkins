
resource "aws_instance" "jenkins_master" {
    # Use an Ubuntu image in eu-west-1
    #ami = "ami-f95ef58a"
    ami           = "${var.ami_id}"

    instance_type = "${var.instance_type}"

    # We're assuming there's a key with this name already
    key_name = "${var.key_name}"

    tags {
      Name = "${var.name}"
      Environment = "${var.env}"
      CreatedBy = "terraform"
    }

    # We're assuming the subnet and security group have been defined earlier on

  #  subnet_id = "${aws_subnet.jenkins.id}"
    #security_group_ids = ["${aws_security_group.jenkins_master.id}"]
    associate_public_ip_address = true



    # This is where we configure the instance with ansible-playbook
    provisioner "local-exec" {
    command = <<EOT
      echo [${var.env}] > ${var.env};
      echo ${aws_instance.jenkins_master.public_ip} ansible_python_interpreter=/usr/bin/python3 >> ${var.env}
      EOT

 }
    # provisioner "local-exec" {
    #
    #   command = "echo ${aws_instance.jenkins_master.public_ip} >> ${var.env}"
    #   #  command = "sleep 220; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/amazon/jijeesh/jijeesh.pem -i '${aws_instance.jenkins_master.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
    # }
}

output "public_ip" {
  value = "${aws_instance.jenkins_master.public_ip}"
}
