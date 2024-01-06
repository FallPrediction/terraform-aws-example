# Trusted entities
data "aws_iam_policy_document" "deploy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ssm.amazonaws.com"]
    }
  }
}

# Permissions policies
data "aws_iam_policy" "s3_readonly" {
  name = "AmazonS3ReadOnlyAccess"
}

data "aws_iam_policy" "codedeploy" {
  name = "AWSCodeDeployRole"
}

data "aws_iam_policy" "ssm_for_ec2" {
  name = "AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role" "deploy" {
  name               = "deploy"
  assume_role_policy = data.aws_iam_policy_document.deploy.json
}

resource "aws_iam_role_policy_attachment" "s3_readonly" {
  role       = aws_iam_role.deploy.name
  policy_arn = data.aws_iam_policy.s3_readonly.arn
}

resource "aws_iam_role_policy_attachment" "codedeploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = data.aws_iam_policy.codedeploy.arn
}

resource "aws_iam_role_policy_attachment" "ssm_for_ec2" {
  role       = aws_iam_role.deploy.name
  policy_arn = data.aws_iam_policy.ssm_for_ec2.arn
}

resource "aws_iam_instance_profile" "deploy" {
  name = "deploy"
  role = aws_iam_role.deploy.name
}
