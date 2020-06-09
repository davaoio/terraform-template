/*
resource "aws_instance" "example" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name      = "example"
  tags = {
    Name       = "example"
    Repository = aws_ecr_repository.example.name
  }
  vpc_security_group_ids      = [aws_security_group.sysops.id, aws_security_group.public_web.id]
  subnet_id                   = aws_subnet.public001.id
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.example_ec2_deployment.id
  user_data                   = <<EOF
#!/bin/bash
curl https://shortcut.codes/willfong/aws_ec2_ubuntu | bash
curl https://shortcut.codes/willfong/sshkeys | bash
curl https://shortcut.codes/willfong/docker_ubuntu | bash
curl https://shortcut.codes/willfong/docker_deploy | bash
EOF
}

resource "aws_ebs_volume" "example" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 20
  tags = {
    Name = "example"
  }
}

resource "aws_volume_attachment" "example" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.example.id
}

resource "aws_ecr_repository" "example" {
  name                 = "example"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

# Allow GitHub to push to this repository
resource "aws_iam_user" "example_github" {
  name = "example_github"
}

resource "aws_iam_access_key" "example_github" {
  user = aws_iam_user.example_github.name
}

resource "aws_iam_user_policy" "example_github" {
  name = "example-github"
  user = aws_iam_user.example_github.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
      {
         "Sid":"GetAuthorizationToken",
         "Effect":"Allow",
         "Action":[
            "ecr:GetAuthorizationToken"
         ],
         "Resource":"*"
      },
      {
         "Sid":"AllowPull",
         "Effect":"Allow",
         "Action":[
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability"
         ],
         "Resource": "${aws_ecr_repository.example.arn}"
      },
      {
         "Sid":"AllowPush",
         "Effect":"Allow",
         "Action":[
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:BatchCheckLayerAvailability",
            "ecr:PutImage",
            "ecr:InitiateLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:CompleteLayerUpload"
         ],
         "Resource": "${aws_ecr_repository.example.arn}"
      }
  ]
}
EOF
}


resource "aws_iam_role" "example_ec2_deployment" {
  name               = "example_ec2_deployment"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

# Allow EC2 instance to pull from the repository
resource "aws_iam_instance_profile" "example_ec2_deployment" {
  name = "example_ec2_deployment"
  role = aws_iam_role.example_ec2_deployment.name
}

resource "aws_iam_role_policy_attachment" "example_ec2_deployment" {
  role       = aws_iam_role.example_ec2_deployment.name
  policy_arn = aws_iam_policy.example_ec2_deployment.arn
}

resource "aws_iam_policy" "example_ec2_deployment" {
  name        = "example_ec2_deployment"
  description = "example_ec2_deployment"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

output "IAM_example_ec2_github_access_id" {
  value = aws_iam_access_key.example_ec2_github.id
}

output "IAM_example_ec2_github_access_secret" {
  value = aws_iam_access_key.example_ec2_github.secret
}

resource "aws_route53_record" "example_ec2" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "example-ec2"
  type    = "A"
  records = [aws_instance.example.public_ip]
  ttl     = "3600"
}

output "aws_example_ec2_instance" {
  value = "${aws_instance.example.public_dns}"
}

*/