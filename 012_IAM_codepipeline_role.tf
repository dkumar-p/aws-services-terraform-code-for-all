resource "aws_iam_role" "codepipeline-test-service-role" {
    name = "codepipeline-test-service-role"
    assume_role_policy = jsonencode(
        {
        "version": "2012-10-17",
        "Statement": [
            {
              "Effect": "Allow",
              "Principal": {
                "Service": "codepipeline.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
      ]
    })
}

resource "aws_iam_policy" "codepipeline-test-service-role" {
    name = "codepipeline-test-service-role"

    policy = jsonencode( 
    {
      "Version": "2012-10-17",
      "Statement": [
        {
            "Action": [
                "s3:ListBucket",
                "s3:GetReplicationConfiguration",
                "s3:GetObjectVersionForReplication",
                "s3:GetObjectVersionAcl",
                "s3:GetObjectVersionTagging",
                "s3:GetObjectRetention",
                "s3:GetObjectLegalHold"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-test-service-role",
                "arn:aws:s3:::codepipeline-test-service-role/*",
                "arn:aws:s3:::aws-smb-pavan-state-file",
                "arn:aws:s3:::aws-smb-pavan-state-file/*"
            ]
        },
        {
            "Action": [
                "s3:ReplicateObject",
                "s3:ReplicateDelete",
                "s3:ReplicateTags",
                "s3:ObjectOwnerOverrideToBucketOwner"
            ],
            "Effect": "Allow",
            "Resource": [
                "arn:aws:s3:::codepipeline-test-service-role/*",
                "arn:aws:s3:::aws-smb-pavan-state-file/*"
            ]
        }
    ]
  }
 ) 
}

resource "aws_iam_policy_attachment" "codepipeline-test-service-role" {
    name = "codepipeline-test-service-role"
    roles = aws_iam_role.codepipeline-test-service-role.name
    policy_arn = aws_iam_policy.codepipeline-test-service-role.arn  
}