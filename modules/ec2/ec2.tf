
# resource "aws_ebs_volume" "aws-ebs-volume" {
#   availability_zone = "${var.availability_zone}"
#   size              = 1
#   tags {
#     Name = "${var.name}"
#     Environment = "${var.env}"
#     CreatedBy = "terraform"
#   }
# }


resource "aws_instance" "aws-instance" {
    ami           = "${var.ami_id}"
    instance_type = "${var.instance_type}"
    key_name = "${var.key_name}"
    availability_zone = "${var.availability_zone}"
    associate_public_ip_address = true
    user_data = "#!/bin/bash\nmkdir /data; mount /dev/xvdh /data;"

    tags {
      Name = "${var.name}"
      Environment = "${var.env}"
      CreatedBy = "terraform"
    }
  #  subnet_id = "${aws_subnet.jenkins.id}"
    #security_group_ids = ["${aws_security_group.jenkins_master.id}"]




    # This is where we configure the instance with ansible-playbook

    # provisioner "local-exec" {
    #
    #   command = "echo ${aws_instance.jenkins_master.public_ip} >> ${var.env}"
    #   #  command = "sleep 220; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/amazon/jijeesh/jijeesh.pem -i '${aws_instance.jenkins_master.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
    # }
}

resource "aws_volume_attachment" "aws-volume-attachment" {
  device_name = "/dev/sdh"
  volume_id   = "${var.dokcer_volume_id}"
  instance_id = "${aws_instance.aws-instance.id}"
}
resource "aws_volume_attachment" "aws-jenkins-volume-attachment" {
  device_name = "/dev/sdi"
  volume_id   = "${var.jenkins_volume_id}"
  instance_id = "${aws_instance.aws-instance.id}"
}
resource "null_resource" "ansible" {
    provisioner "local-exec" {
      command = <<EOT
        echo [defaults] > ansible.cfg;
        echo hostfile = inventory-${var.env} >> ansible.cfg;
        echo host_key_checking = False >> ansible.cfg;
        echo private_key_file = ~/amazon/jijeesh/${var.key_name}.pem >> ansible.cfg;
        echo deprecation_warnings=False >> ansible.cfg;
        echo #gathering = smart >> ansible.cfg;
        echo #fact_caching = jsonfile >> ansible.cfg;
        echo #fact_caching_connection = /tmp/facts_cache >> ansible.cfg;
        echo #fact_caching_timeout = 7200 >> ansible.cfg;
        echo forks = 100 >> ansible.cfg;
        echo bin_ansible_callbacks=True >> ansible.cfg;
        echo connection_plugins = ../ansible/connection_plugins >> ansible.cfg;
        echo [ssh_connection] >> ansible.cfg;
        echo pipelining = True >> ansible.cfg;
        echo control_path = /tmp/ansible-ssh-%%h-%%p-%%r >> ansible.cfg;
        echo [${var.env}] > inventory-${var.env};
        echo ${aws_instance.aws-instance.public_ip} ansible_python_interpreter=/usr/bin/python3 >> inventory-${var.env};
        ansible-playbook -s main.yml
        EOT
      on_failure = "continue"
    }
    depends_on = ["aws_instance.aws-instance"]
}
output "public_ip" {
  value = "${aws_instance.aws-instance.public_ip}"
}
