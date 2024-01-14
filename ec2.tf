data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64*"]
  }
}

data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["arm64"]
  }

  filter {
    name   = "description"
    values = ["Amazon Linux 2023*"]
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = "terraform-key-pair"
  public_key = var.public_key
}

resource "aws_instance" "app_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.nano"
  availability_zone      = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.public.id]
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name = "example_app_server"
  }
}

resource "aws_instance" "nat" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = "t4g.nano"
  availability_zone      = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.nat.id]
  subnet_id              = aws_subnet.public.id
  key_name               = aws_key_pair.key_pair.key_name
  source_dest_check      = false
  user_data              = file("iptable-nat.sh")

  tags = {
    Name = "example_nat"
  }
}

resource "aws_instance" "db" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3a.nano"
  availability_zone      = data.aws_availability_zones.available.names[0]
  vpc_security_group_ids = [aws_security_group.private.id]
  subnet_id              = aws_subnet.private.id
  key_name               = aws_key_pair.key_pair.key_name

  tags = {
    Name = "example_db"
  }
}

resource "aws_eip" "app_server_ip" {
  instance = aws_instance.app_server.id
  domain   = "vpc"
}

resource "aws_eip" "nat_ip" {
  instance = aws_instance.nat.id
  domain   = "vpc"
}
