provider "aws" {
  profile = var.profile
  region  = var.region-prod
  alias   = "region-prod"
}
