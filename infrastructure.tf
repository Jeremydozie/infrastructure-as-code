resource "aws_s3_bucket" "b" {
 bucket = "my-bucket"
 acl    = "private"

 versioning {
   enabled = true
 }

}

resource "aws_kms_key" "mykey" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
}

resource "aws_s3_bucket" "mybucket" {
 bucket = "mybucket"

 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.mykey.arn
       sse_algorithm     = "aws:kms"
     }
   }
 }
}

resource "null_resource" "read_file" {
 provisioner "local-exec" {
   command = "$jsondata = Get-Content-Raw-Path $data.json | ConvertFrom-Json > completed.txt"
   interpreter = ["PowerShell", "-Command"]
 }
}

resource "aws_S3_bucket_object" "mybucket" {
bucket = aws_S3_bucket.b1.id
source = "completed.txt"
etag = filemd5 ("myfiles/completed.txt")


}
