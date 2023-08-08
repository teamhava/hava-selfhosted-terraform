resource "aws_s3_bucket" "hava_cache" {
  bucket = "${local.prefix}-cache-${random_string.sufix.result}"

  tags = local.tags
}

resource "aws_iam_policy" "hava_cache_s3" {
  name = "${local.prefix}-s3-${random_string.sufix.result}"
  path = "/"
  description = "Provides read/write access to hava s3 cache bucket"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:PutObject",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect = "Allow"
        Resource = [
          aws_s3_bucket.hava_cache.arn, 
          "${aws_s3_bucket.hava_cache.arn}/*"
        ]
      }
    ]
  })

  tags = local.tags
}

resource "aws_iam_policy_attachment" "hava_cache_s3" {
  name = "${local.prefix}-s3-${random_string.sufix.result}"
  roles = [aws_iam_role.hava.name]
  policy_arn = aws_iam_policy.hava_cache_s3.arn
}

output "s3_bucket_name" {
  value = aws_s3_bucket.hava_cache.bucket
}