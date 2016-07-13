provider "aws" {
  region = "ap-northeast-1"
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
