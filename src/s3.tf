resource "aws_s3_bucket" "dsci_gdpr_bucket" {
  bucket = "${local.cig_gdpr_bucket_name}"
  acl    = "private"

  tags = "${var.default_tags}"
}

resource "aws_s3_bucket_object" "gdpr_install_dependencies" {
  bucket = "${local.cig_gdpr_bucket_name}"
  key    = "scripts/EMR/install_dependencies.sh"
  source = "${path.module}/scripts/install_dependencies.sh"
  etag   = "${md5(file("${path.module}/scripts/install_dependencies.sh"))}"

  tags = "${var.default_tags}"
}
