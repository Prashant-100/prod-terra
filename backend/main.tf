provider "aws" {
  region = "ap-south-1"
}
resource "aws_dynamodb_table" "dyamo-table-for-remote-state" {
  name           = "dyamodb-remote-state"
  billing_mode   = "PROVISIONED"
  read_capacity  = 5
  write_capacity = 5
  hash_key       = "LockId"

  attribute {
    name = "LockId"
    type = "5"
  }

  resource "aws_s3_bucket" "s3-bucket-for-remote-state" {
    bucket = "s3-bucket-for-remote-state100"
    ac1    = "private"

    versioning {
      enabled = true
    }
    force_destroy = true
  }
}