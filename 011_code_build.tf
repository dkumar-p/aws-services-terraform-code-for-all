resource "aws_codebuild_project" "aws-smb-project-1" {
    name = "aws-smb-project-1"
    build_timeout = 5
    service_role = aws_iam_role.codebuild-test-service-role.name


    artifacts {
      type = "NO_ARTIFACTS"
    }

    source {
      type = "GITHUB"
      location = "https://github.com/dkumar-p/project1.git"
      git_clone_depth = 1
      buildspec = "Buildspecf/buildspec.yml"
      git_submodules_config {
        fetch_submodules = true
      }
  }

  environment {
    image = "aws/codebuild/amazonlinux2-x86_64-standard:5.0"
    type = "LINUX_CONTAINER"
    compute_type                = "BUILD_GENERAL1_SMALL"
    image_pull_credentials_type = "CODEBUILD"
  }
    /*
    dynamic "environment_variable" {
    for_each = var.codebuild_env_vars["LOAD_VARS"] != false ? var.codebuild_env_vars : {}
    content {
      name  = environment_variable.key
      value = environment_variable.value
     }
    }
    */

    logs_config {
      cloudwatch_logs {
        group_name  = "log-group"
        stream_name = "log-stream"
      }

      s3_logs {
        status = "DISABLED"
      }
    }
   
}