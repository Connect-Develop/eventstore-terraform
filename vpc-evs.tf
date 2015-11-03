
resource "aws_vpc" "eventstore" {
    cidr_block = "172.29.56.0/24"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
        Usage = "local"
    }
}

resource "aws_internet_gateway" "evs-gw" {
    vpc_id = "${aws_vpc.eventstore.id}"
}

resource "aws_subnet" "evs-subnet-a" {
    vpc_id = "${aws_vpc.eventstore.id}"
    availability_zone = "${var.aws_region}a"

    cidr_block = "172.29.56.0/25"
    map_public_ip_on_launch = false
}

resource "aws_subnet" "evs-subnet-b" {
    vpc_id = "${aws_vpc.eventstore.id}"
    availability_zone = "${var.aws_region}b"

    cidr_block = "172.29.56.128/25"
    map_public_ip_on_launch = false
}

resource "aws_route_table" "evs-route-table" {
    vpc_id = "${aws_vpc.eventstore.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.evs-gw.id}"
    }
}

resource "aws_route_table_association" "evs-subnet-a" {
    subnet_id = "${aws_subnet.evs-subnet-a.id}"
    route_table_id = "${aws_route_table.evs-route-table.id}"
}

resource "aws_route_table_association" "evs-subnet-b" {
    subnet_id = "${aws_subnet.evs-subnet-b.id}"
    route_table_id = "${aws_route_table.evs-route-table.id}"
}

resource "aws_security_group" "evs-group" {
    name = "evs-group"
    description = "Marker group"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.eventstore.id}"
}

resource "aws_security_group" "evs-ingress-ssh" {
    name = "evs-ingress-internet-ssh"
    description = "Allow internet access to evs nodes"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.eventstore.id}"
}

resource "aws_security_group" "evs-ingress-eventstore" {
    name = "evs-ingress-eventstore"
    description = "Allow internet access to evs nodes"

    ingress {
        from_port = 1113
        to_port = 1113
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 2113
        to_port = 2113
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.eventstore.id}"
}

resource "aws_security_group" "evs-internal-eventstore" {
    name = "evs-internal-eventstore"
    description = "Allow internal comms between nodes"

    ingress {
        from_port = 2112
        to_port = 2112
        protocol = "tcp"
        security_groups = ["${aws_security_group.evs-group.id}"]
    }
    ingress {
        from_port = 1112
        to_port = 1112
        protocol = "tcp"
        security_groups = ["${aws_security_group.evs-group.id}"]
    }

    vpc_id = "${aws_vpc.eventstore.id}"
}
