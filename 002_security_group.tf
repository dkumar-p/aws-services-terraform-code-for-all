######################### security group ###########################################
locals {
  name_sg = "AWS-SMB-test-vpc-pavan-SG"
}


module "security_group_ec2" {

  source = "github.com/dkumar-p/terraform-aws-security-group"

  name        = local.name_sg
  description = "Security group for usage with EC2 instance SEG003 APP"
  vpc_id      = module.vpc.vpc_id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["ssh-tcp"]

  egress_rules = ["all-all"]

  tags = merge(var.tags,
    {
      "Name" = local.name_sg
    }
  )
}


resource "aws_security_group_rule" "port_3899" {
  type              = "ingress"
  from_port         = 3899
  to_port           = 3899
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security_group_ec2.security_group_id
}


resource "aws_security_group_rule" "port_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security_group_ec2.security_group_id
}

resource "aws_security_group_rule" "port_8080" {
  type              = "ingress"
  from_port         = 8080
  to_port           = 8080
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.security_group_ec2.security_group_id
}