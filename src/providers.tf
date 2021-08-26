provider "aws" {
  version             = "~>2.2"
  region              = "${var.region}"
  profile             = "default"
  allowed_account_ids = ["${var.accountid}"]
}

provider "external" {}
