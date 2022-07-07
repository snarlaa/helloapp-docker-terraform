# Variables for general information
######################################
 
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_count" {
  default = "1"
} 

variable "instance_tags" {
  type = list
  default = ["Jenkins-Master"]
}

variable "aws_region_az" {
  description = "AWS region availability zone"
  type        = string
  default     = "a"
}
variable "aws_region_az1" {
  description = "AWS region availability zone"
  type        = string
  default     = "a"
}
variable "aws_region_az2" {
  description = "AWS region availability zone"
  type        = string
  default     = "b"
}

# Variables for Instance
######################################
 
variable "instance_ami" {
  description = "ID of the AMI used"
  type        = string
  default     = "ami-0cff7528ff583bf9a"
}
 
variable "instance_type" {
  description = "Type of the instance"
  type        = string
  default     = "t2.micro"
}
 
variable "key_pair" {
  description = "SSH Key pair used to connect"
  type        = string
  default     = "agnikp"
}
 
variable "root_device_type" {
  description = "Type of the root block device"
  type        = string
  default     = "gp2"
}
 
variable "root_device_size" {
  description = "Size of the root block device"
  type        = string
  default     = "10"
}

variable "owner" {
  description = "Configuration owner"
  type        = string
  default = "saneeta.narla"
}
