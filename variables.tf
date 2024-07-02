variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(any)
}


variable "vpc_cidr_cluster" {
  description = "Pavan's personal VPC"
  type        = string
  #default = "11.0.0.0/24" 
}

variable "vpc_azs" {
  description = "Pavan's personal Az's"
  type        = list(string)
  default     = ["ap-south-1a", "ap-south-1b"]

}

variable "vpc_public_subnets_cluster" {
  description = "Pavan's personal Private subnet details"
  type        = list(string)
  #default = ["eu-west-1a", "eu-west-1b"]
}

variable "vpc_private_subnets_cluster" {
  description = "Pavan's personal Private subnet details"
  type        = list(string)
  #default = ["eu-west-1a", "eu-west-1b"]
}

variable "ec2_instance_count" {
  description = "Pavan's Ec2 instances count"
  type        = string
  default     = "2"
}

variable "ec2_create_volume" {
  description = "Pavan's Ec2 Volumes count"
  type        = string
  default     = "2"
}

variable "ami_master" {
  description = "Pavan's personal AMI details"
  type        = string
  #default = ["eu-west-1a", "eu-west-1b"]
}

variable "instance_type_1" {
  description = "Instance Type of the EC2 Instance"
  type        = string
  #default     = ""
}

variable "loadbalancer_name" {
  description = "Load balancer name"
  type        = string
  #default     = ""
}

variable "load_balancer_type" {
  description = "Load balancer type"
  type        = string
  #default     = ""
}

variable "type" {
  description = "Load balancer Internal/Internet-facing"
  type        = string
  #default     = ""
}

variable "asg_name" {
  description = "AWS SMB Training ASG"
  type        = string
  #default = ""  
}