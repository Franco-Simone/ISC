resource "aws_instance" "instance-eac" {
  ami           = "ami-0817d428a6fb68645"
  instance_type = "t2.micro"
  key_name      = var.aws_key
  subnet_id     = aws_subnet.private-subnet-eac.id
  vpc_security_group_ids = [
    aws_security_group.sg-eac.id,
  ]
  tags = {
    Name      = "Instance-EAC"
    Terraform = "True"
  }
  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file(var.aws_key_path)
    host = self.public_ip
  }
  provisioner "remote-exec" {
    on_failure = continue
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y ca-certificates wget",
      "wget https://get.glennr.nl/unifi/install/unifi-5.13.32.sh"
    ]
  }

}
