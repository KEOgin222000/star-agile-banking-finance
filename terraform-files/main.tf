resource "aws_instance" "test_server" {
  ami = "ami-053a45fff0a704a47"
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
     Name = "test_server"
     }
  provisioner "local-exec" {
     command = "echo ${aws_instance.test_server.public_ip} > inventory"
     }
  provisioner "local-exec" {
     command = "command = "ansible-playbook -i inventory ansibleplaybook.yml --extra-vars 'credentialsId=terraform-ansible'"
  }
  }
