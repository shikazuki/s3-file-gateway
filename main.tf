module "network" {
  source = "./modules/network"
}

# Bastion Instance
module "bastion_instance" {
  source = "./modules/bastion-instance"

  vpc_id    = module.network.vpc_id
  subnet_id = module.network.pri_a_2_id
}
