resource "aws_glue_catalog_database" "eol_database" {
  count = "${var.environment == "prod" ? 1 : 0}"

  name        = "${var.eol_database_name}"
  description = "exactonline database will hold all customer's data ingested from EOL Databases via Cumulus"
}

resource "aws_glue_crawler" "eol_data_crawler" {
  count = "${var.environment == "prod" ? 1 : 0}"

  database_name = "${aws_glue_catalog_database.eol_database.name}"
  name          = "${var.eol_crawler_name}"
  role          = "${data.aws_iam_role.cig_glue_role.name}"

  s3_target {
    path = "${var.crawler_raw_s3_target}"
    exclusions = [
      "Devops_GLTransactions_Deleted/**",
      "Devops_GLTransactions_Ids/**"
    ]
  }

  s3_target {
    path = "${var.crawler_domain_s3_target}"
  }

  s3_target {
    path = "${var.crawler_domain_s3_target_2}"
  }
}
