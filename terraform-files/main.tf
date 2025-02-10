resource "aws_instance" "test-server" {
  ami = "085ad6ae776d8f09c"
  instance_type = "t2.micro"
  key_name = "ban"
  vpc_security_group_ids = ["sg-070ae16b0b96d53e5"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./ban.pem")
     host = self.public_ip
     }
  provisioner "remote-exec" {
     inline = ["echo 'wait to start the instance' "]
  }
  tags = {
     Name = "test-server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test-server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "ansible-playbook /var/lib/jenkins/workspace/banking project/terraform-files/ansibleplaybook.yml"
     }
  }
