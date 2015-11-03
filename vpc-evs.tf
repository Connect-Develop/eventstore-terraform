
resource "aws_vpc" "vpc" {
    cidr_block = "172.29.56.0/24"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "${var.prefix}eventstore-vpc"
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_internet_gateway" "vpc-gw" {
    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Name = "${var.prefix}eventstore-vpc"
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_subnet" "vpc-subnet-a" {
    vpc_id = "${aws_vpc.vpc.id}"
    availability_zone = "${var.aws_region}a"

    cidr_block = "172.29.56.0/25"
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.prefix}eventstore-vpc-a"
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_subnet" "vpc-subnet-b" {
    vpc_id = "${aws_vpc.vpc.id}"
    availability_zone = "${var.aws_region}b"

    cidr_block = "172.29.56.128/25"
    map_public_ip_on_launch = false

    tags = {
        Name = "${var.prefix}eventstore-vpc-b"
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_route_table" "vpc-route-table" {
    vpc_id = "${aws_vpc.vpc.id}"
    route = {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.vpc-gw.id}"
    }

    tags = {
        Name = "${var.prefix}eventstore-vpc"
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_route_table_association" "vpc-subnet-a" {
    subnet_id = "${aws_subnet.vpc-subnet-a.id}"
    route_table_id = "${aws_route_table.vpc-route-table.id}"
}

resource "aws_route_table_association" "vpc-subnet-b" {
    subnet_id = "${aws_subnet.vpc-subnet-b.id}"
    route_table_id = "${aws_route_table.vpc-route-table.id}"
}

resource "aws_security_group" "eventstore-group" {
    name = "${var.prefix}eventstore-group"
    description = "Eventstore SG"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_security_group" "eventstore-ingress-ssh" {
    name = "${var.prefix}eventstore-ingress-ssh"
    description = "Allow internet access to eventstore nodes"

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_security_group" "eventstore-ingress" {
    name = "${var.prefix}eventstore-ingress-eventstore"
    description = "Allow internet access to eventstore nodes"

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

    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Usage = "${var.tags.Usage}"
    }
}

resource "aws_security_group" "eventstore-internal" {
    name = "${var.prefix}eventstore-internal"
    description = "Allow internal comms between nodes"

    ingress {
        from_port = 2112
        to_port = 2112
        protocol = "tcp"
        security_groups = ["${aws_security_group.eventstore-group.id}"]
    }
    ingress {
        from_port = 1112
        to_port = 1112
        protocol = "tcp"
        security_groups = ["${aws_security_group.eventstore-group.id}"]
    }

    vpc_id = "${aws_vpc.vpc.id}"

    tags = {
        Usage = "${var.tags.Usage}"
    }
}
