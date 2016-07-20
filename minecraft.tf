variable "my_home_ip" {}
variable "minecraft_snapshot_id" {}
variable "minecraft_admin_public_key" {}

provider "aws" {
  region = "ap-northeast-1"
}

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

resource "aws_vpc" "minecraft" {
  cidr_block = "172.30.0.0/16"

  tags {
    Name = "minecraft"
  }
}

resource "aws_subnet" "minecraft" {
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

resource "aws_ebs_volume" "minecraft" {
  size = 8
  availability_zone = "ap-northeast-1b"
  type = "gp2"
  snapshot_id = "${var.minecraft_snapshot_id}"

  tags {
    Name = "minecraft"
  }
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
