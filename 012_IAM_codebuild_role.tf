resource "aws_iam_role" "codebuild-test-service-role" {
    name = "codebuild-test-service-role"
    assume_role_policy = jsonencode({
        "version": "2012-10-17",
        "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": "codebuild.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
      ]
    })
}

resource "aws_iam_policy" "codebuild-test-service-role" {
    name = "codebuild-test-service-role"

    policy = jsonencode( 
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:logs:ap-south-1:903972153540:log-group:/aws/codebuild/codebuild-test-service-role",
                "arn:aws:logs:ap-south-1:903972153540:log-group:/aws/codebuild/codebuild-test-service-role:*"
            ],
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ]
        },
        {
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-ap-south-1-*"
            ],
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:GetObjectVersion",
                "s3:GetBucketAcl",
                "s3:GetBucketLocation"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "codebuild:CreateReportGroup",
                "codebuild:CreateReport",
                "codebuild:UpdateReport",
                "codebuild:BatchPutTestCases",
                "codebuild:BatchPutCodeCoverages"
            ],
            "Resource": [
                "arn:aws:codebuild:ap-south-1:903972153540:report-group/codebuild-test-service-role-*"
            ]
        }
    ] 
 }) 
}

resource "aws_iam_policy_attachment" "codebuild-test-service-role" {
    name = "codebuild-test-service-role"
    roles = aws_iam_role.codebuild-test-service-role.name
    policy_arn = aws_iam_policy.codebuild-test-service-role.arn  
}