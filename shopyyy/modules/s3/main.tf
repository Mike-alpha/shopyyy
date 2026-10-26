resource "aws_s3_bucket" "frontend" {
  bucket = var.bucket_name

  tags = merge(var.common_tags, {
    Name = var.bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "frontend" {
  count  = var.cloudfront_distribution_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.frontend.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "AllowCloudFrontServicePrincipalReadOnly"
        Effect = "Allow"
        Principal = {
          Service = "cloudfront.amazonaws.com"
        }
        Action   = "s3:GetObject"
        Resource = "${aws_s3_bucket.frontend.arn}/*"
        Condition = {
          StringEquals = {
            "AWS:SourceArn" = var.cloudfront_distribution_arn
          }
        }
      }
    ]
  })
}

output "bucket_id" {
  value = aws_s3_bucket.frontend.id
}

output "bucket_arn" {
  value = aws_s3_bucket.frontend.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.frontend.bucket_domain_name
}

output "bucket_regional_domain_name" {
  value = aws_s3_bucket.frontend.bucket_regional_domain_name
}
