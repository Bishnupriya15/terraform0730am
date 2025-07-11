
resource "aws_vpc" "Name" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "CustomVPC"
  }
}

# 2. Public Subnet creation
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.Name.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "public_subnet"
  }
}

# 3. Private Subnet creation
resource "aws_subnet" "private" {
  vpc_id     = aws_vpc.Name.id
  cidr_block = "10.0.2.0/24"

  tags = {
    Name = "private_subnet"
  }
}

# 4. Internet Gateway for Public Subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.Name.id

  tags = {
    Name = "CustomIG"
  }
}

# 5. Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.Name.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-route-table"
  }
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 6. Elastic IP for NAT Gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

# 7. NAT Gateway (in Public Subnet)
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "CustomNAT"
  }
}

# 8. Route Table for Private Subnet (uses NAT Gateway)
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.Name.id

  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "private-route-table"
  }
}

#9 route associate 
resource "aws_route_table_association" "private_assoc" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private_rt.id
}
#10.security group creation
resource "aws_security_group" "allow_tls" {
  name        = "custom_sg"
  vpc_id      = aws_vpc.Name.id
  tags = {
    Name = "custom_sg"
  }
 ingress {
    description      = "TLS from VPC"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
ingress {
    description      = "TLS from VPC"
    from_port        = 22
    to_port          = 22
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }
egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    
  }


  }
  #ec2 instance creation
  resource "aws_instance" "name" {
  ami = "ami-0d03cb826412c6b0f"
  instance_type = "t2.micro"
  key_name = ""
  tags = {

Name = "Terraform6"
  }
  
}

