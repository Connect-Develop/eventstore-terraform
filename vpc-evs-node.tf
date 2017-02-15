data "aws_ami" "instance" {
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server*"]
    }
    owners = ["099720109477"]
}

resource "aws_instance" "eventstore-primary-node" {
    subnet_id = "${aws_subnet.vpc-subnet-a.id}"
    availability_zone = "${var.aws_region}a"
    ami = "${data.aws_ami.instance.id}"
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
