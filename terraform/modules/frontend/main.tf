# The S3 Bucket resource
resource "aws_s3_bucket" "frontend" {
  bucket        = var.bucket_name
  force_destroy = true # Allows Terraform to wipe the bucket cleanly during destruction
}

# Configures the bucket specifically to serve web pages (index.html)
resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html" # Standard fallback routing mechanism for React SPAs
  }
}

# Explicitly disables the safety blocks so the public can view our website UI
resource "aws_s3_bucket_public_access_block" "frontend" {
  bucket = aws_s3_bucket.frontend.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# The access policy allowing internet traffic read-only line of sight
resource "aws_s3_bucket_policy" "public_read" {
  bucket     = aws_s3_bucket.frontend.id
  depends_on = [aws_s3_bucket_public_access_block.frontend]

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetter"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.frontend.arn}/*"
      }
    ]
  })
}