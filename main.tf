 
 #Creacion de las 2 VPC, una con red clase A y otra B
 #La red clase A tendra la maquina linux y la clase B la windows
 resource "aws_vpc" "vpc_B" {          
   cidr_block       = var.B_vpc_cidr    
   instance_tenancy = "default"
 }
  resource "aws_vpc" "vpc_A" {          
   cidr_block       = var.A_vpc_cidr    
   instance_tenancy = "default"
 }

 #Creacion del Internet Gateway
 resource "aws_internet_gateway" "IGW" {   
    vpc_id =  aws_vpc.vpc_B.id               
 }
 resource "aws_internet_gateway" "IGW2" {   
    vpc_id =  aws_vpc.vpc_A.id               
 }

 #Creacion de las subredes para la VPC B, la subred 2 tendra a la EC2
 resource "aws_subnet" "subnet_B2" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B2_IP}"        
 }         
 resource "aws_subnet" "subnet_B1" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B1_IP}"        
 }   
 resource "aws_subnet" "subnet_B3" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B3_IP}"        
 }   
 resource "aws_subnet" "subnet_B4" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B4_IP}"        
 }
 resource "aws_subnet" "subnet_B5" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B5_IP}"        
 }
 resource "aws_subnet" "subnet_B6" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B6_IP}"        
 }
 resource "aws_subnet" "subnet_B7" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B7_IP}"        
 }
 resource "aws_subnet" "subnet_B8" {    
   vpc_id =  aws_vpc.vpc_B.id
   cidr_block = "${var.subnet_B8_IP}"        
 }

 #Creacion de las subredes para la VPC A, la subred 2 tendra a la EC2
 resource "aws_subnet" "subnet_A2" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A2_IP}"         
 }
 resource "aws_subnet" "subnet_A1" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A1_IP}"         
 }
 resource "aws_subnet" "subnet_A3" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A3_IP}"         
 }
 resource "aws_subnet" "subnet_A4" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A4_IP}"         
 }
 resource "aws_subnet" "subnet_A5" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A5_IP}"         
 }
 resource "aws_subnet" "subnet_A6" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A6_IP}"         
 }
 resource "aws_subnet" "subnet_A7" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A7_IP}"         
 }
 resource "aws_subnet" "subnet_A8" {
   vpc_id =  aws_vpc.vpc_A.id
   cidr_block = "${var.subnet_A8_IP}"         
 }

 #Routes de las subredes de la VPC clase B
 resource "aws_route" "Route_vpc_B_1" {
  route_table_id            = aws_vpc.vpc_B.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_A.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering-BA.id
}
 resource "aws_route" "Route_vpc_B_2" {
  route_table_id            = aws_vpc.vpc_B.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGW.id
}

 #Routes de las subredes de la VPC clase A
 resource "aws_route" "Route_vpc_A_1" {
  route_table_id            = aws_vpc.vpc_A.main_route_table_id
  destination_cidr_block    = aws_vpc.vpc_B.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc-peering-BA.id
}
 resource "aws_route" "Route_vpc_A_2" {
  route_table_id            = aws_vpc.vpc_A.main_route_table_id
  destination_cidr_block    = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.IGW2.id
}

#EC2 Windows
 resource "aws_instance" "ec2_B2_windows" {
  ami = "ami-04ce2d3d06e88b4cf"
  instance_type = "t3.micro"
  subnet_id = aws_subnet.subnet_B2.id
  associate_public_ip_address = "true"
  key_name = "Windows_Canada"
  ebs_block_device {
    device_name = "/dev/sda1"
    volume_size = 200
    volume_type = "standard"
  }
  vpc_security_group_ids = [
    "${aws_security_group.allow_windows.id}"]
}

#Security Group de la EC2 Windows
resource "aws_security_group" "allow_windows" {
  name = "allow_windows"
  vpc_id = "${aws_vpc.vpc_B.id}"
 
  ingress {
    from_port = 3389
    to_port = 3389
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
    ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "128.0.0.0/24"]
  }
      ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "10.0.0.0/24"]
  }
 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

#EC2 Linux
 resource "aws_instance" "ec2_A2_linux" {
  ami = "ami-0801628222e2e96d6"
  instance_type = "t2.micro"
  subnet_id = aws_subnet.subnet_A2.id
  associate_public_ip_address = "true"
  key_name = "Windows_Canada"
  vpc_security_group_ids = [
    "${aws_security_group.allow_linux.id}"]
}

#Security Group de la EC2 Linux
resource "aws_security_group" "allow_linux" {
  name = "allow_linux"
  vpc_id = aws_vpc.vpc_A.id
 
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "128.0.0.0/24"]
  }
  ingress {
    from_port = -1
    to_port = -1
    protocol = "icmp"
    cidr_blocks = [
      "10.0.0.0/24"]
  }
 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"]
  }
}

#VPC Peering
resource "aws_vpc_peering_connection" "vpc-peering-BA" {
  peer_vpc_id   = aws_vpc.vpc_A.id
  vpc_id        = aws_vpc.vpc_B.id
  auto_accept   = true
}

