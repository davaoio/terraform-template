data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "EXAMPLE" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_hostnames = "true"
  tags = {
    Name = "EXAMPLE"
  }
}

resource "aws_route_table" "EXAMPLE" {
  vpc_id = aws_vpc.EXAMPLE.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.EXAMPLE.id
  }

  tags = {
    Name = "EXAMPLE"
  }
}

resource "aws_internet_gateway" "EXAMPLE" {
  vpc_id = aws_vpc.EXAMPLE.id

  tags = {
    Name = "EXAMPLE"
  }
}

resource "aws_main_route_table_association" "EXAMPLE" {
  vpc_id         = aws_vpc.EXAMPLE.id
  route_table_id = aws_route_table.EXAMPLE.id
}

resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.EXAMPLE.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.EXAMPLE.id
}

resource "aws_subnet" "public001" {
  vpc_id            = aws_vpc.EXAMPLE.id
  cidr_block        = "10.24.1.0/24"
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "public-001"
  }
}

resource "aws_subnet" "public002" {
  vpc_id            = aws_vpc.EXAMPLE.id
  cidr_block        = "10.24.2.0/24"
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "public-002"
  }
}

resource "aws_subnet" "public003" {
  vpc_id            = aws_vpc.EXAMPLE.id
  cidr_block        = "10.24.3.0/24"
  availability_zone = data.aws_availability_zones.available.names[2]
  tags = {
    Name = "public-003"
  }
}

resource "aws_route_table_association" "public001" {
  subnet_id      = aws_subnet.public001.id
  route_table_id = aws_route_table.EXAMPLE.id
}
resource "aws_route_table_association" "public002" {
  subnet_id      = aws_subnet.public002.id
  route_table_id = aws_route_table.EXAMPLE.id
}
resource "aws_route_table_association" "public003" {
  subnet_id      = aws_subnet.public003.id
  route_table_id = aws_route_table.EXAMPLE.id
}
