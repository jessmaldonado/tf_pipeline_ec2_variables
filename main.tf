provider "aws" {
  region = "ca-central-1"
}

resource "aws_instance" "tf_ec2_pipeline" {
  ami           = "ami-0d8ad3ab25e7abc51"
  instance_type = "t2.nano"
}