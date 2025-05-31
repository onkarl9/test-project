#custom-vpc,Priavte-SB, Public SBInternet Gateway,

provider "aws" {
  region = "us-east-1"
}

# 1. Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.10.0.0/16"
 
  tags = {
    Name = "my-vpc"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "my-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.10.2.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.10.3.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "private-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# 6. Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Private Route Table (no internet route)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-rt"
  }
}

# 8. Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
