resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "${var.prefix}-vpc"
  }
}

# for storage gateway instance
resource "aws_subnet" "pri_a_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.prefix}-pri_a_1"
  }
}

# for bastion instance
resource "aws_subnet" "pri_a_2" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.prefix}-pri_a_2"
  }
}

# for nat gateway + internet gateway to enable ssm manager
resource "aws_subnet" "pub_a_1" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.3.0/24"
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "${var.prefix}-pub_a_1"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-igw"
  }
}


resource "aws_eip" "nat_a_1" {
  domain = "vpc"
  tags = {
    Name = "${var.prefix}-eip-nat_a_1"
  }
}

resource "aws_nat_gateway" "nat_a_1" {
  allocation_id = aws_eip.nat_a_1.id
  subnet_id     = aws_subnet.pub_a_1.id
  depends_on    = [aws_internet_gateway.main]
  tags = {
    Name = "${var.prefix}-nat_a_1"
  }
}

### Route Table ###

resource "aws_route_table" "pub_a_1" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-pub_a_1"
  }
}

resource "aws_route_table" "pri_a_2" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.prefix}-pri_a_2"
  }
}

resource "aws_route" "pub_igw_a_1" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id         = aws_route_table.pub_a_1.id
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route" "nat_a_2" {
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_a_1.id
  route_table_id         = aws_route_table.pri_a_2.id
}

resource "aws_route_table_association" "pub_a_1" {
  subnet_id      = aws_subnet.pub_a_1.id
  route_table_id = aws_route_table.pub_a_1.id
}

resource "aws_route_table_association" "pri_a_2" {
  subnet_id      = aws_subnet.pri_a_2.id
  route_table_id = aws_route_table.pri_a_2.id
}

resource "aws_route_table_association" "pri_a_1" {
  subnet_id      = aws_subnet.pri_a_1.id
  route_table_id = aws_route_table.pri_a_2.id
}

