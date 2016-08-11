variable "my_home_ip" {}
variable "minecraft_snapshot_id" {}
variable "minecraft_admin_public_key" {}

provider "aws" {
  region = "ap-northeast-1"
}

/*
// to save .tfstate file
resource "aws_s3_bucket" "minecraft_admin" {
  bucket = "hanachin-minecraft-admin"
  acl = "private"
  versioning {
    enabled = true
  }

  tags {
    Name = "minecraft"
  }
}
*/

resource "aws_vpc" "minecraft" {
  cidr_block = "172.30.0.0/16"

  tags {
    Name = "minecraft"
  }
}

resource "aws_subnet" "minecraft" {
  availability_zone = "ap-northeast-1c"
  vpc_id = "${aws_vpc.minecraft.id}"
  cidr_block = "172.30.1.0/24"

  tags {
    Name = "minecraft"
  }
}

resource "aws_internet_gateway" "minecraft" {
  vpc_id = "${aws_vpc.minecraft.id}"

  tags {
      Name = "minecraft"
  }
}

resource "aws_route" "minecraft" {
  route_table_id = "${aws_vpc.minecraft.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = "${aws_internet_gateway.minecraft.id}"
}

resource "aws_security_group" "ssh_from_home" {
  name = "ssh from home"
  description = "ssh from my home ip"
  vpc_id = "${aws_vpc.minecraft.id}"

  ingress {
    from_port = 22
    to_port =  22
    protocol = "tcp"
    cidr_blocks = ["${var.my_home_ip}/32"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "minecraft" {
  name = "minecraft server"
  description = "tcp port for minecraft server"
  vpc_id = "${aws_vpc.minecraft.id}"

  ingress {
    from_port = 25565
    to_port = 25565
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "minecraft" {
  key_name = "minecraft-admin"
  public_key = "${var.minecraft_admin_public_key}"
}

resource "aws_eip" "minecraft" {
  instance = "${aws_instance.minecraft.id}"
  vpc = true
}

resource "aws_instance" "minecraft" {
  ami = "ami-29160d47"
  availability_zone = "ap-northeast-1c"
  instance_type = "t2.small"
  subnet_id = "${aws_subnet.minecraft.id}"
  security_groups = [
    "${aws_security_group.ssh_from_home.id}",
    "${aws_security_group.minecraft.id}"
  ]
  key_name = "${aws_key_pair.minecraft.key_name}"

  ebs_block_device {
    device_name = "/dev/xvdf"
    snapshot_id = "${var.minecraft_snapshot_id}"
    volume_type = "gp2"
    volume_size = 8
  }

  tags {
    Name = "minecraft"
  }
}

/*
TODO
resource "aws_iam_role" "mc_line_bot" {
  name ="mc_line_bot"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}*/
