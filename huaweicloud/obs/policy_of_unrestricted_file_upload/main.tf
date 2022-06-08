provider "huaweicloud" {
  region     = "cn-north-1"
  access_key = var.huaweicloud_access_key
  secret_key = var.huaweicloud_secret_key
}

resource "huaweicloud_obs_bucket" "create_bucket" {
  bucket        = "hx-cloud-security-${random_string.random_suffix.result}"
  force_destroy = true
  acl           = "private"
}


resource "huaweicloud_obs_bucket_policy" "policy" {
  bucket        = huaweicloud_obs_bucket.create_bucket.id
  policy_format = "s3"
  policy        = <<POLICY
{
	"Version": "2008-10-17",
	"Id": "HuoXianPolicy",
	"Statement": [{
		"Effect": "Allow",
		"Principal": "*",
		"Action": [
			"s3:GetObject",
			"s3:ListBucket",
      "s3:PutObject"
		],
		"Resource": [
			"arn:aws:s3:::${huaweicloud_obs_bucket.create_bucket.id}",
			"arn:aws:s3:::${huaweicloud_obs_bucket.create_bucket.id}/*"
		]
	}]
}
POLICY
  depends_on = [
    huaweicloud_obs_bucket.create_bucket
  ]
}

resource "random_string" "random_suffix" {
  length  = 5
  special = false
  upper   = false
}