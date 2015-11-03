
resource "aws_instance" "eventstore-primary-node" {
    subnet_id = "${aws_subnet.vpc-subnet-a.id}"
    availability_zone = "${var.aws_region}a"
    ami = "${lookup(var.images, var.aws_region)}"
    instance_type = "${var.instance_type}"
    key_name = "${var.aws_key_pair}"
    security_groups = [
        "${aws_security_group.eventstore-group.id}",
        "${aws_security_group.eventstore-ingress-ssh.id}",
        "${aws_security_group.eventstore-ingress.id}",
        "${aws_security_group.eventstore-internal.id}",
    ]
    associate_public_ip_address = true
    source_dest_check = true

    depends_on = ["aws_internet_gateway.vpc-gw"]

    tags = {
        Name = "${var.prefix}eventstore-primary-node"
        Usage = "${var.tags.Usage}"
    }

    user_data = "${file("eventstore-cloudinit.sh")}"
}
