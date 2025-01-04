
resource "aws_storagegateway_gateway" "main" {
  activation_key = var.activation_key
  gateway_name       = var.name
  gateway_timezone   = "GMT"
  gateway_type       = "FILE_S3"
  smb_guest_password = "password"
  lifecycle {
    ignore_changes = [smb_guest_password]
  }
}

# ディスクIDの取得のために aws_storage gateway_local_disk を使う
# 「disk_node」を以下の様に記載する
data "aws_storagegateway_local_disk" "main" {
  gateway_arn = aws_storagegateway_gateway.main.arn
  disk_node   = "/dev/sdf"
}

resource "aws_storagegateway_cache" "main" {
  gateway_arn = aws_storagegateway_gateway.main.arn
  # aws_storage gateway_local_diskからディスクIDを設定
  disk_id     = data.aws_storagegateway_local_disk.main.id
}

# shared bucket
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["storagegateway.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "main" {
  name = "file-share-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "s3" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_storagegateway_nfs_file_share" "nfs" {
  client_list  = ["0.0.0.0/0"]
  gateway_arn  = aws_storagegateway_gateway.main.arn
  location_arn = aws_s3_bucket.main.arn
  role_arn     = aws_iam_role.main.arn
}
