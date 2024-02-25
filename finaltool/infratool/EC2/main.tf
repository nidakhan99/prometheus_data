data "aws_ami" "my_ami" {
  most_recent      = true
  owners           = [var.owner-id]

  filter {
    name   = "name"
    values = [var.ami-name]
  }
  filter {
    name   = "root-device-type"
    values = [var.ebi-device-type]
  }

  filter {
    name   = "virtualization-type"
    values = [var.vartualiztion_type]
  }

}
###########################[ KEY PAIR ]####################################################


# resource "aws_key_pair" "my_key" {
#   key_name   = "my_key"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
# }


 

#############################[ BESTION HOST ]################################################

resource "aws_instance" "bestion" {
  count                         = 1
  ami                           = data.aws_ami.my_ami.id
  instance_type                 = var.ec2_type
  key_name                      = var.key
  subnet_id                     = var.pub_sub[count.index]
  associate_public_ip_address   = true
  security_groups = [var.sg_id]

  tags = {
   Name = var.bestion

  }
}

#############################[ PRIVATE_INSTANCES ]################################################
resource "aws_instance" "private_instance" {
  count                         = 1
  ami                           = data.aws_ami.my_ami.id
  instance_type                 = var.ec2_type
  key_name                      = var.key
  subnet_id                     = var.pir_sub[count.index]
  security_groups               = [ var.sg_id]
  tags = {
   Name = var.pirv_instance

  }
}
