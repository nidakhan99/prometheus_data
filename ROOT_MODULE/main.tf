module "vpc" {
  source           = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/vpc?ref=script"
  vpc-cidr         = var.vpc-cidr2
  vpc-name         = var.vpc-name2
  vpc-region       = var.vpc-region2
}


module "subnets" {
  source            = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/subnet?ref=script"
  vpc-id            = module.vpc.vpc-id-out
  pub_az            = var.pub_az2
  pir_az            = var.pir_az2
  pub-sub-cidr      = var.pub-sub-cidr2
  pirv-sub-cidr     = var.pirv-sub-cidr2
}

module "internet_gateway" {
  source             = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/internet_gateway?ref=script"
  vpc-id             = module.vpc.vpc-id-out
  igw-name           = var.igw-name2
}

module "nat_gateway" {
  source             = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/nat_gateway?ref=script"
  pub_sub_id         = module.subnets.pub-sub-out-id[0]
  nat-name           = var.nat-name2

}


module "route_tables" {
  source              = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/route_table?ref=script"
  vpc-id              = module.vpc.vpc-id-out
  igw                 = module.internet_gateway.igw-id-out
  nat_id              = module.nat_gateway.out_nat
  pub_sub             = module.subnets.pub-sub-out-id
  pir_sub             = module.subnets.pirv-sub-out-id
  rt_ip               = var.rt_ip2

}

module "security_grp" {
  source               = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/security_group?ref=script"
  vpc_id               = module.vpc.vpc-id-out
  sg-name              = var.sg-name2
  sg_ports             = var.sg_ports2
  sg_protocol          = var.sg_protocol2
  sg_cidr              = var.sg_cidr2
  sg_protocol-egress   = var.sg_protocol-egress2
  
}

module "instances" {
  source  = "github.com/nidakhan99/prometheus_data.git//finaltool/infratool/EC2?ref=script"
  pub_sub             = module.subnets.pub-sub-out-id
  pir_sub             = module.subnets.pirv-sub-out-id
  sg_id               = module.security_grp.sg_out
  ami-name            = var.ami-name2
  ebi-device-type     = var.ebi-device-type2
  vartualiztion_type  = var.vartualiztion_type2
  ec2_type            = var.ec2_type2
  owner-id            = var.owner-id2
  ssh_user            = var.ssh_user2
  private_key_path    = var.private_key_path_2
  file_name           = var.file_name2
}
