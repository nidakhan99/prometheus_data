resource "aws_instance" "bestion" {
  count                         = 1
  ami                           = data.aws_ami.my_ami.id
  instance_type                 = var.ec2_type
  key_name                      = var.key
  subnet_id                     = var.pub_sub[count.index]
  associate_public_ip_address   = true
  security_groups               = [var.sg_id]

  provisioner "remote-exec" {
    inline = ["echo 'Wait until SSH is ready'"]

    connection {
      type        = "ssh"
      user        = var.ssh_user
      private_key = file(var.private_key_path)
      host        = aws_instance.bestion[0].public_ip
    }
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.bestion[0].public_ip}, --private-key ${var.private_key_path} ${var.file_name}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.bestion[0].public_ip}, --private-key ${var.private_key_path} ${var.aler_file}"
  }

  provisioner "local-exec" {
    command = "ansible-playbook -i ${aws_instance.bestion[0].public_ip}, --private-key /home/ubuntu/ohio_key.pem ${var.node_file_name}"
  }

  tags = {
    Name = var.bestion
  }
}
