locals {
  code_deploy_apps_aws-smb = ["AutenticationService", "MOD_Autenticacion"]
  app_group_aws-smb        = "aws-smb"
}

resource "aws_codedeploy_app" "aws-smb" {
  for_each         = toset(local.code_deploy_apps_aws-smb)
  compute_platform = "Server"
  name             = each.value
}

resource "aws_codedeploy_deployment_config" "aws-smb" {
  deployment_config_name = "CodeDeploy.${local.app_group_aws-smb}"

  minimum_healthy_hosts {
    type  = "HOST_COUNT"
    value = 0
  }
}

resource "aws_codedeploy_deployment_group" "aws-smb" {
  for_each               = toset(local.code_deploy_apps_aws-smb)
  app_name               = aws_codedeploy_app.aws-smb[each.value].name
  deployment_group_name  = "${each.value}-${local.app_group_aws-smb}"
  service_role_arn       = "arn:aws:iam::903972153540:role/AWScodedeploy"
  deployment_config_name = aws_codedeploy_deployment_config.aws-smb.id
  autoscaling_groups     = [module.asg.autoscaling_group_id]
  /*
  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = local.name_ec2
    }
  }
  */
  deployment_style {
    deployment_option = "WITHOUT_TRAFFIC_CONTROL"
    deployment_type   = "IN_PLACE"
  }

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}