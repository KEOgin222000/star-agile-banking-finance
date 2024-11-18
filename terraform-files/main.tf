resource "aws_instance" "test-server" {
  ami = "ami-012967cc5a8c9f891"
  instance_type = "t2.micro"
  key_name = "keoginawskey"
  vpc_security_group_ids = ["sg-058a363c98e2db70b"]
  connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./keoginawskey.pem")
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
