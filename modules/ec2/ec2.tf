
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
 #    provisioner "local-exec" {
 #      #command = "sleep 220; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/amazon/jijeesh/jijeesh.pem -i '${aws_instance.jenkins_master.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
 #    command = <<EOT
 #      echo [defaults] > ansible.cfg;
 #      echo hostfile = ${var.env} >> ansible.cfg;
 #      echo host_key_checking = False >> ansible.cfg;
 #      echo private_key_file = ~/amazon/jijeesh/${var.key_name}.pem >> ansible.cfg;
 #      echo deprecation_warnings=False >> ansible.cfg;
 #      echo [${var.env}] > ${var.env};
 #      echo ${aws_instance.jenkins_master.public_ip} ansible_python_interpreter=/usr/bin/python3 >> ${var.env};
 #      ansible-playbook -s test.yml
 #      EOT
 #
 # }
    # provisioner "local-exec" {
    #
    #   command = "echo ${aws_instance.jenkins_master.public_ip} >> ${var.env}"
    #   #  command = "sleep 220; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ~/amazon/jijeesh/jijeesh.pem -i '${aws_instance.jenkins_master.public_ip},' -e 'ansible_python_interpreter=/usr/bin/python3' master.yml"
    # }
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
        echo ${aws_instance.jenkins_master.public_ip} ansible_python_interpreter=/usr/bin/python3 >> inventory-${var.env};
        ansible-playbook -s main.yml
        EOT
      on_failure = "continue"
    }
    depends_on = ["aws_instance.jenkins_master"]
}
output "public_ip" {
  value = "${aws_instance.jenkins_master.public_ip}"
}
