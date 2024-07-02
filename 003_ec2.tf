locals {
  ec2_name_1 = "AWS-SMB-test-vpc-pavan_1"
  ec2_name_2 = "AWS-SMB-test-vpc-pavan_2"
}

module "ec2_instance_1" {

  source = "github.com/dkumar-p/terraform-aws-ec2-instance.git"

  count = var.ec2_instance_count

  ami                    = var.ami_master
  instance_type          = var.instance_type_1
  key_name               = "pavan-test-keypair"
  monitoring             = false
  iam_instance_profile   = "AmazonSSMRoleForInstancesQuickSetup"
  vpc_security_group_ids = [module.security_group_ec2.security_group_id]
  subnet_id              = element(module.vpc.public_subnets, 0)
  #private_ip                  = "10.0.0.15"
  associate_public_ip_address = true

  enable_volume_tags = false
  root_block_device = [
    {
      encrypted             = true
      volume_type           = "gp3"
      volume_size           = 40
      delete_on_termination = true
      tags = merge(var.tags,
        {
          "Name" = "Server ${count.index + 1}"
        },
      )
    },
  ]

  user_data = file("script.sh")


  tags = merge(var.tags,
    {
      "Name" = "Server ${count.index}"
    }
  )
}


resource "aws_volume_attachment" "this" {
  count       = var.ec2_create_volume == "true" ? 1 : 0
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.this[count.index].id
  instance_id = module.ec2_instance_1[count.index].id
}

resource "aws_ebs_volume" "this" {
  count             = var.ec2_create_volume == "true" ? 1 : 0
  availability_zone = "ap-south-1a"
  iops              = "1000"
  type              = "gp2"
  size              = 10
}
