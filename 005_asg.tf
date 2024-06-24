module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"
  #depends_on = [aws_iam_role.asg_role]
  version = "7.6.1"
  # Autoscaling group
  name                      = var.asg_name
  target_group_arns         = module.alb.target_group_arns
  min_size                  = 2
  max_size                  = 3
  desired_capacity          = 2
  wait_for_capacity_timeout = 0
  health_check_type         = "EC2"
  vpc_zone_identifier       = [module.vpc.public_subnets[0], module.vpc.private_subnets[0]]
  /*
  initial_lifecycle_hooks = [
    {
      name                  = "ExampleStartupLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 60
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_LAUNCHING"
      notification_metadata = jsonencode({ "hello" = "world" })
    },
    {
      name                  = "ExampleTerminationLifeCycleHook"
      default_result        = "CONTINUE"
      heartbeat_timeout     = 180
      lifecycle_transition  = "autoscaling:EC2_INSTANCE_TERMINATING"
      notification_metadata = jsonencode({ "goodbye" = "world" })
    }
  ]
*/
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage = 50
    }
    triggers = ["launch_template"]
  }

  # Launch template
  launch_template_name        = "AWS_SMB_Training_launch_configuration"
  launch_template_description = "Launch template example"
  update_default_version      = true

  image_id                 = "ami-0a7c3c5efeedc3034"
  instance_type            = "t3.micro"
  ebs_optimized            = true
  enable_monitoring        = false
  user_data                = filebase64("script.sh")
  iam_instance_profile_arn = "arn:aws:iam::903972153540:role/AmazonSSMRoleForInstancesQuickSetup"
  # IAM role & instance profile
  #create_iam_instance_profile = false
  #iam_role_name               = aws_iam_role.asg_role.name
  /* iam_role_path               = "/ec2/"
  iam_role_description        = "IAM role example"
  iam_role_tags = {
    CustomIamRole = "Yes"
  }
  iam_role_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }*/

  block_device_mappings = [
    {
      # Root volume
      device_name = "/dev/xvda"
      no_device   = 0
      ebs = {
        delete_on_termination = true
        encrypted             = true
        volume_size           = 40
        volume_type           = "gp2"
      }
    }
  ]

  capacity_reservation_specification = {
    capacity_reservation_preference = "open"
  }



  # This will ensure imdsv2 is enabled, required, and a single hop which is aws security
  # best practices
  # See https://docs.aws.amazon.com/securityhub/latest/userguide/autoscaling-controls.html#autoscaling-4
  metadata_options = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }
  network_interfaces = [
    {
      security_groups = [module.security_group_ec2.security_group_id]
    }
  ]

  tag_specifications = [
    {
      resource_type = "instance"
      tags          = { WhatAmI = "Instance" }
    },
    {
      resource_type = "volume"
      tags          = { WhatAmI = "Volume" }
    }
  ]
  tags = {
    Environment = "dev"
    Project     = "megasecret"
  }
}