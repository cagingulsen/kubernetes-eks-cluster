provider "aws" {
  region = "eu-west-1"
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "blueharvest-terraform-state-storage-s3"
    region  = "eu-west-1"
    key     = "blueharvest/terraform/eks/travistest"
  }
}

module "blueharvest-eks" {
  source                 = "s3::https://s3-eu-west-1.amazonaws.com/blueharvest-terraform-registry/terraform-aws-blueharvest-eks-v0.0.4-release.zip"
  availability_zones     = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  eks_ami_id             = "ami-01e08d22b9439c15a"
  instance_type          = "t3.large"
  asg_min_size           = "5"
  asg_max_size           = "20"
  cluster_name           = "travistest"
  cluster_zone           = "blueharvest.io"
  cluster_zone_id        = "Z31OVNF5EA1VAW"
  letsencrypt_email      = "kemal.gulsen@capgemini.com"
  letsencrypt_production = "true"
  map_users              = "${var.map_users}"
  map_users_count        = "${var.map_users_count}"
}
