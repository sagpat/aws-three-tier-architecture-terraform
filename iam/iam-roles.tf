resource "aws_iam_role" "ssm_s3_role" {
  name = "EC2InstanceSSMAndS3Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
        Sid    = "EC2InstanceSSMAndS3Role"
      }
    ]
  })
}


# These defined policies will allow EC2 instances to download the code from S3
# and use Systems Manager Session Manager to securely connect to our instances without SSH keys through the AWS console.

# data "aws_iam_policy" "managed_roles" {
#   for_each = toset(var.aws_managed_roles)
#   arn      = "arn:aws:iam::aws:policy/${each.value}"
# }

# resource "aws_iam_role_policy_attachment" "managed_policy_attachment" {
#   role       = aws_iam_role.ssm_s3_role.name
#   for_each   = data.aws_iam_policy.managed_roles
#   policy_arn = each.value.arn
# }

# resource "aws_iam_instance_profile" "ssm_s3_instance_profile" {
#   name = "EC2InstanceSSMAndS3InstanceProfile"
#   role = aws_iam_role.ssm_s3_role.name
# }

# -------------


resource "aws_iam_role_policy_attachment" "ssm_policy_attachment" {
  role       = aws_iam_role.ssm_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "s3_readonly_policy_attachment" {
  role       = aws_iam_role.ssm_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "cloud_watch_agent_policy" {
  role       = aws_iam_role.ssm_s3_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_instance_profile" "ssm_s3_instance_profile" {
  name = "ec2_instance_profile"
  role = aws_iam_role.ssm_s3_role.name
}