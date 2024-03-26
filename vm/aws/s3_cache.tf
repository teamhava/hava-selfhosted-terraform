resource "aws_s3_bucket" "hava_cache" {
  count         = var.create_s3_bucket ? 1 : 0
  bucket        = "${var.name_prefix}-cache-${random_string.suffix.result}"
  force_destroy = var.force_destroy_s3_bucket
}

resource "aws_iam_policy" "hava_cache_s3" {
  count       = var.create_s3_bucket ? 1 : 0
  name        = "${var.name_prefix}-s3-${random_string.suffix.result}"
  path        = "/"
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
          aws_s3_bucket.hava_cache[0].arn,
          "${aws_s3_bucket.hava_cache[0].arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "hava_cache_s3" {
  count      = var.create_s3_bucket ? 1 : 0
  name       = "${var.name_prefix}-s3-${random_string.suffix.result}"
  roles      = [aws_iam_role.hava.name]
  policy_arn = aws_iam_policy.hava_cache_s3[0].arn
}
