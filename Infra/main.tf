resource "aws_lambda_function" "myfunc" {
    filename = data.archive_file.zip.output_path
    source_code_hash = data.archive_file.zip.output_base64sha256
    function_name = "myfunc"
    role = aws_iam_role.iam_for_lambda.arn
    handler = "func.handler"
    runtime = "python3.8"

}