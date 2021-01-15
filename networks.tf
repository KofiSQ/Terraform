#create vpc in the us-east-1
resource "aws_vpc" "vpc_prod" {
  provider             = aws.region-prod
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "prod-vpc"
  }
}

#create internet gateways in the us-east-1
resource "aws_internet_gateway" "igw" {
  provider = aws.region-prod
  vpc_id   = aws_vpc.vpc_prod.id

}

#Get all the AZ in the VPC for the prod region
data "aws_availability_zones" "azs" {
  provider = aws.region-prod
  state    = "available"



}

#create a subnet # 1 in the us-east-1
resource "aws_subnet" "subnet_1" {
  provider          = aws.region-prod
  availability_zone = element(data.aws_availability_zones.azs.names, 0)
  vpc_id            = aws_vpc.vpc_prod.id
  cidr_block        = "10.0.1.0/24"

}

resource "aws_route_table" "internet_route" {
  provider = aws.region-prod
  vpc_id   = aws_vpc.vpc_prod.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  lifecycle {
    ignore_changes = all
  }
  tags = {
    Name = "Prod-Region-RT"
  }

}


#Overwrite default route of the VPC(prod) with our route table entries
resource "aws_main_route_table_association" "set-prod-default-rt-assoc" {
  provider       = aws.region-prod
  vpc_id         = aws_vpc.vpc_prod.id
  route_table_id = aws_route_table.internet_route.id

}