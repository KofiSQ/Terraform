#Create SG for allowing TCP/8080 and TCP/443 from * and TCP/22 from your IP in us-east-1
resource "aws_security_group" "prod-sg" {
  provider    = aws.region-prod
  name        = "prod-sg"
  description = "Allow 443 and traffic to prod SG"
  vpc_id      = aws_vpc.vpc_prod.id
  ingress {
    description = "Allow 443 from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 80 from anywhere for redirection"
    from_port   = var.webserver-port
    to_port     = var.webserver-port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow 22 from mine IP for ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.external_ip]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
