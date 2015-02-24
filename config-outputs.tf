output "aws.region" {
    value = "${var.aws_region}"
}
output "aws.profile" {
    value = "${var.aws_profile}"
}

output "vpc.eventstore.id" {
    value = "${aws_vpc.eventstore.id}"
}
output "vpc.eventstore.evs-route-table" {
    value = "${aws_route_table.evs-route-table.id}"
}
output "vpc.eventstore.cidr" {
    value = "${aws_vpc.eventstore.cidr_block}"
}

output "evs-primary-node" {
    value = "${aws_instance.evs-primary-node.id}"
}
output "evs-primary-node.public_ip" {
    value = "${aws_instance.evs-primary-node.public_ip}"
}
output "evs-primary-node.http" {
    value = "http://${aws_instance.evs-primary-node.public_ip}:2113/"
}
