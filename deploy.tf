resource "aws_instance" "deploy" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3a.micro"
  key_name      = "GENERATE-YOUR-OWN"
  tags = {
    Name = "deploy"
  }
  vpc_security_group_ids      = [aws_security_group.sysops.id, aws_security_group.public_web.id]
  subnet_id                   = aws_subnet.public001.id
  associate_public_ip_address = "true"
  iam_instance_profile        = aws_iam_instance_profile.deploy.id

  root_block_device {
    volume_type = "gp2"
    volume_size = "32"
  }

  user_data = <<EOF
#!/bin/bash
curl https://shortcut.codes/willfong/aws_ec2_ubuntu | bash
curl https://shortcut.codes/willfong/sshkeys | bash
curl https://shortcut.codes/willfong/docker_ubuntu | bash
EOF
}

resource "aws_ebs_volume" "deploy" {
  availability_zone = data.aws_availability_zones.available.names[0]
  size              = 20
  tags = {
    Name = "deploy"
  }
}

resource "aws_volume_attachment" "deploy" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.deploy.id
  instance_id = aws_instance.deploy.id
}

resource "aws_iam_role" "deploy" {
  name               = "deploy"
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

resource "aws_iam_instance_profile" "deploy" {
  name = "deploy"
  role = aws_iam_role.deploy.name
}

resource "aws_iam_role_policy_attachment" "deploy" {
  role       = aws_iam_role.deploy.name
  policy_arn = aws_iam_policy.deploy.arn
}

resource "aws_iam_policy" "deploy" {
  name        = "deploy"
  description = "deploy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ec2:DescribeTags"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_route53_record" "deploy" {
  zone_id = aws_route53_zone.example.zone_id
  name    = "deploy"
  type    = "A"
  records = [aws_instance.deploy.public_ip]
  ttl     = "3600"
}

output "aws_instance_deploy" {
  value = "${aws_instance.deploy.public_dns}"
}
