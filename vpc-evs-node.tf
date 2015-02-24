
resource "aws_instance" "evs-primary-node" {
    subnet_id = "${aws_subnet.evs-subnet-a.id}"
    availability_zone = "${var.aws_region}a"
    ami = "ami-a388fd99" #ubuntu vivid 15.04 DEVEL amd64 hvm:ebs
    instance_type = "t2.micro"
    key_name = "${var.aws_key_pair}"
    security_groups = [
        "${aws_security_group.evs-group.id}",
        "${aws_security_group.evs-ingress-ssh.id}",
        "${aws_security_group.evs-ingress-eventstore.id}",
        "${aws_security_group.evs-internal-eventstore.id}",
    ]
    associate_public_ip_address = true
    source_dest_check = true

    depends_on = ["aws_internet_gateway.evs-gw"]

    tags {
        Usage = "testing"
    }

    user_data = "${file("eventstore-cloudinit.sh")}"
}
