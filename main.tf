module "network" {
  source = "./modules/network"
}

# Bastion Instance
module "bastion_instance" {
  source = "./modules/bastion-instance"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.pri_a_2_id
}

# Storage Gateway Instance
data "aws_ssm_parameter" "s3fg_ami" {
  name = "/aws/service/storagegateway/ami/FILE_S3/latest"
}
module "storage_gateway_instance" {
  source = "./modules/storage-gateway-instance"

  name             = "s3fg-instance"
  vpc_id           = module.network.vpc_id
  vpc_cidr         = module.network.vpc_cidr
  subnet_id        = module.network.pri_a_1_id
  ami              = data.aws_ssm_parameter.s3fg_ami.insecure_value
  instance_type    = "m4.xlarge"
  root_volume_size = 80
}