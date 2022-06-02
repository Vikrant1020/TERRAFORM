
# data for geting IDS of all subnets in a VPC
data "aws_subnets" "ids" {
  filter {
    name   = "vpc-id"
    values = [aws_vpc.terraform.id]
  }
  # vpc_id = aws_vpc.terraform.id
}

# data "aws_subnet" "example" {
#   for_each = data.aws_subnet_ids.example.ids
#   id       = each.value
# }
