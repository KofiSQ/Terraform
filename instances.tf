#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-prod
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "pat-key" {
  provider   = aws.region-prod
  key_name   = "pat"
  public_key = file("~/.ssh/id_rsa.pub")
}

#create and bootstrap EC2 in us-east-1
resource "aws_instance" "prod" {
  provider                    = aws.region-prod
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.pat-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.prod-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "prod_tf"
  }
   depends_on = [aws_main_route_table_association.set-prod-default-rt-assoc]


 #The code below is ONLY the provisioner block which needs to be
#inserted inside the resource block for Prod EC2 Terraform
#Prod Provisioner:

  provisioner "local-exec" {
    command = <<EOF
aws --profile ${var.profile} ec2 wait instance-status-ok --region ${var.region-prod} --instance-ids ${self.id}
ansible-playbook --extra-vars 'passed_in_hosts=tag_Name_${self.tags.Name}' ansible_templates/prod.yml
EOF
  }
   

}
