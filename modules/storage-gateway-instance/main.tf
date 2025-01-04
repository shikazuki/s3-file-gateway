resource "aws_security_group" "main" {
  name   = var.name
  vpc_id = var.vpc_id
  tags = {
    Name = var.name
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "internal for s3-filegateway"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 111
    to_port     = 111
    protocol    = "tcp"
    description = "internal for nfs111"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    description = "internal for nfs2049"
    cidr_blocks = [var.vpc_cidr]
  }
  ingress {
    from_port   = 20048
    to_port     = 20048
    protocol    = "tcp"
    description = "internal for nfs20048"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    description = "external all"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# keypair作成
resource "tls_private_key" "main" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "main" {
  key_name   = var.name
  public_key = tls_private_key.main.public_key_openssh
}
resource "aws_ssm_parameter" "keypair_pem" {
  name  = "/${var.name}/keypair.pem"
  value = tls_private_key.main.private_key_pem
  type  = "SecureString"
}
resource "aws_ssm_parameter" "keypair_pub" {
  name  = "/${var.name}/keypair.pub"
  value = tls_private_key.main.public_key_openssh
  type  = "SecureString"
}

# インスタンス設定
resource "aws_instance" "default" {
  ami                  = var.ami
  instance_type        = var.instance_type
  key_name             = aws_key_pair.main.key_name
  subnet_id            = var.subnet_id
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  root_block_device {
    volume_type           = "gp3"
    volume_size           = var.root_volume_size
    delete_on_termination = true
  }
  tags = {
    Name = var.name
  }
}

#　EBS追加ボリューム。Cacheストレージはサイズ変更してはならず、アタッチで追加しなければならない。
resource "aws_ebs_volume" "sdf" {
  availability_zone = aws_instance.default.availability_zone
  #　ボリュームサイズ(GiB)
  size = 150
  tags = {
    Name = "${var.name}-cache-volume"
  }
}

resource "aws_volume_attachment" "sdf" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.sdf.id
  instance_id = aws_instance.default.id
}

resource "aws_ssm_parameter" "activation_key" {
  name = "/${var.name}/filegateway/activation_key"
  value = "password"
  type = "SecureString"
  description = "activation_key for s3 file gateway"

  lifecycle {
    ignore_changes = [value] # 上書きして変更するので無視する
  }
}
