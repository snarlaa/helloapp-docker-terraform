
provider "aws" {
  profile = "default"
  region  = var.aws_region
}


##Create a keypair
resource "aws_key_pair" "TF_Key" {
  key_name   = "agnikp"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF_Key" {
    content  = tls_private_key.rsa.private_key_pem
    filename = "angikp.pem"
}

##Creation of vpc
resource "aws_vpc" "vpc" {
    cidr_block = "10.0.0.0/16"
    enable_dns_support = "true" #gives you an internal domain name
    enable_dns_hostnames = "true" #gives you an internal host name
    enable_classiclink = "false"
    instance_tenancy = "default"    
    tags = {
      Name = "angi_vpc"
    }
}


##Subnet created public
resource "aws_subnet" "subnet_public" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = "true" //it makes this a public subnet
    availability_zone = "${var.aws_region}${var.aws_region_az}"
    tags = {
      Name = "angi_pub_subnet"
    }
}
##Subnet created private
resource "aws_subnet" "subnet_private_1" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.2.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.aws_region}${var.aws_region_az1}"
    tags = {
      Name = "angi_private_subnet_1"
    }
}
##Subnet created private
resource "aws_subnet" "subnet_private_2" {
    vpc_id = aws_vpc.vpc.id
    cidr_block = "10.0.3.0/24"
    map_public_ip_on_launch = "false" //it makes this a public subnet
    availability_zone = "${var.aws_region}${var.aws_region_az2}"
    tags = {
      Name = "angi_private_subnet_2"
    }
}

##Create IGW for Internet route

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.vpc.id
    tags = {
        Name = "angi_igw"
    }
}

##Route table creation and associating with IGW as this is public RT

resource "aws_route_table" "public-rt" {
    vpc_id = aws_vpc.vpc.id
    
    route {
        //associated subnet can reach everywhere
        cidr_block = "0.0.0.0/0" 
        //CRT uses this IGW to reach internet
        gateway_id = aws_internet_gateway.igw.id
    }
    
    tags = {
        Name = "angi_public_rt"
    }
}

## Route table association
resource "aws_route_table_association" "public-rt-subnet-assoc"{
    subnet_id = aws_subnet.subnet_public.id
    route_table_id = aws_route_table.public-rt.id
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_instance_profile" "jenkins_role_profile" {
  name = "jenkins_role_profile"
  role = "${aws_iam_role.jenkins_role.name}"

}

resource "aws_iam_role_policy" "jenkins_policy" {
  name = "jenkins_policy"
  role = "${aws_iam_role.jenkins_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*",
        "ec2:*",
        "eks:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

##Instance creation
resource "aws_instance" "instance" {
  count         = var.instance_count
  ami                         = var.instance_ami
  availability_zone           = "${var.aws_region}${var.aws_region_az}"
  iam_instance_profile        = "${aws_iam_instance_profile.jenkins_role_profile.name}"
  instance_type               = var.instance_type
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins_allowed_sg.id]
  subnet_id                   = aws_subnet.subnet_public.id
  key_name                    = var.key_pair
 
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = var.root_device_size
    volume_type           = var.root_device_type
  }
  user_data =  "${file("install_jenkins.sh")}"        
  tags = {
     Name  = element(var.instance_tags, count.index)
     Owner = var.owner
  }
}
