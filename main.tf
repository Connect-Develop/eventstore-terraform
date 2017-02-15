provider "aws" { }

data "aws_region" "current" {
  current = true
}

variable "aws_profile" {
    default = "aws"
}

variable "aws_key_pair" {
    default = "key-pair"
}

variable "prefix" { default = "evs-test-" }
variable "tags" { 
    default = {
        Usage = "local-testing"
    }
}

variable "instance_type" { default = "t2.micro"}

output "aws.region" {
    value = "${data.aws_region.current.name}"
}
output "aws.profile" {
    value = "${var.aws_profile}"
}

output "vpc.id" {
    value = "${aws_vpc.vpc.id}"
}
output "vpc.evs-route-table" {
    value = "${aws_route_table.vpc-route-table.id}"
}
output "vpc.cidr" {
    value = "${aws_vpc.vpc.cidr_block}"
}

output "eventstore-primary-node" {
    value = "${aws_instance.eventstore-primary-node.id}"
}
output "eventstore-primary-node.public_ip" {
    value = "${aws_instance.eventstore-primary-node.public_ip}"
}
output "eventstore-primary-node.http" {
    value = "http://${aws_instance.eventstore-primary-node.public_ip}:2113/"
}
