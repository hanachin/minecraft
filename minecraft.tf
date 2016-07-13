provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_vpc" "minecraft" {
  cidr_block = "172.30.0.0/16"

  tags {
    Name = "minecraft"
  }
}
