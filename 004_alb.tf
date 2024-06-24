locals {
  name_lb_alb = "My-aws-smb-test-alb"
}


/*
module "lb-alb" {

  source = "github.com/dkumar-p/terraform-aws-alb.git"

  name = local.name_lb_alb

  load_balancer_type = "application"
  internal           = true

  vpc_id = module.vpc.vpc_id

  subnets = [element(module.vpc.public_subnets, 0)]
  # For example only
  enable_deletion_protection = false

  security_groups = [module.security_group_ec2.security_group_id]
  idle_timeout                     = 300
  enable_cross_zone_load_balancing = true


  /*
  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 8080
      protocol           = "HTTP"
      target_group_index = 1
    }
  ]
  

 # Listeners
  listeners = {
    # Listener-1: my-http-listener
    my-http-listener = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "mytg1"
      }       
    }
  }# End of listeners block

  
  /*   https_listeners = [
    {
      port               = 8443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 4
    },
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = "arn:aws:iam::XXXXXXXXXXXX:server-certificate/XXXXXXXX"
      target_group_index = 5
    }
  ] 

  target_groups = [
    {
      name             = "${local.name_lb_alb}-HTTP-1"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    },
    {
      name             = "${local.name_lb_alb}-80"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      stickiness = {
        enabled = true
        type    = "lb_cookie"
      }
    }
    /* {
      name             = "${local.name_lb_alb}-8443"
      backend_protocol = "HTTPS"
      backend_port     = 8443
      target_type      = "instance"
      targets = [
        {
          target_id         = module.ec2_instance_1.id
          port              = 8443          
        }
      ]
    },
    {
      name             = "${local.name_lb_alb}-443"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      targets = [
        {
          target_id         = module.ec2_instance_1.id
          port              = 443          
        }
      ]
    } 
  ]

  tags = merge(var.tags,
    {
      "Name" = local.name_lb_alb
    }
  )
}
*/


module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"


  name                       = var.loadbalancer_name
  vpc_id                     = module.vpc.vpc_id
  subnets                    = [module.vpc.public_subnets[0], module.vpc.private_subnets[0]]
  load_balancer_type         = var.load_balancer_type
  internal                   = var.type
  enable_deletion_protection = true
  security_groups            = [module.security_group_ec2.security_group_id]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name             = "webservers-http-tg"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
    }
  ]

  tags = {
    terraform = "true"
    Name      = var.loadbalancer_name
  }
}