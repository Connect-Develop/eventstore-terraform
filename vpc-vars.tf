
variable "instance_type" { default = "t2.micro"}

variable "images" {
    # https://cloud-images.ubuntu.com/locator/ec2/
    # Ubuntu Wily 15.10 amd64 hvm:ebs-ssd 20151029
    default = {
        ap-northeast-1 = "ami-6214310c"
        ap-southeast-1 = "ami-f6bf7895"
        ap-southeast-2 = "ami-acd58acf"
        eu-central-1 = "ami-3c4b5850"
        eu-west-1 = "ami-92e03fe1"
        sa-east-1 = "ami-1308b07f"
        us-east-1 = "ami-78abdb12"
        us-west-1 = "ami-0ce08c6c"
        us-west-2 = "ami-6e37230f"
    }
}
