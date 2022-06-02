
# data for geting IDS of all subnets in a VPC
data "aws_subnets" "ids" {
  filter {
    name   = "vpc-id"
    values = ["vpc-0e09a13a0a8fc173c"]
  }
  # vpc_id = aws_vpc.terraform.id
}

# data "aws_subnet" "example" {
#   for_each = data.aws_subnet_ids.example.ids
#   id       = each.value
# }
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_availability_zones" "all" {}