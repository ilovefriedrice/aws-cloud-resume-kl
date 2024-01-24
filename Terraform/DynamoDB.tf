resource "aws_dynamodb_table" "resume_counter" {
  name         = "cloudresumechallenge-viewcounter"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "ID"

  attribute {
    name = "ID"
    type = "S"
  }
}
