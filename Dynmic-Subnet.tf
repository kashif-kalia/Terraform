# provider "aws" {
#   region     = "us-west-2"
#   access_key = "AKIAZYQZWJ5QXWBZ44IW"
#   secret_key = "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"
# }


data "aws_availability_zones" "available" {}

data "aws_vpc" "existing_vpcs" {
  tags ={
    Name= "kashif"
  }
}
////////////// Note :- create var.tf
variable "inc" {
    type = number
    default = 8
  
} //////////////////////////

resource "aws_subnet" "redis-subnet" {
  count = 4
  
  vpc_id             = data.aws_vpc.existing_vpcs.id
  cidr_block         = cidrsubnet(data.aws_vpc.existing_vpcs.cidr_block, 8, var.inc + count.index)
  availability_zone  = data.aws_availability_zones.available.names[count.index]

  tags = {
    Name = "redis-subnet-${count.index + 1}"
  }
}
