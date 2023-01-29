resource "aws_instance" "web-server" {
    ami = "ami-01cc34ab2709337aa"
    instance_type = "t2.micro"
    count = 2
    key_name = "mykeypair"
    security_groups = ["${aws_security_group.web-server.name}"]
    user_data              = filebase64("install_apache.sh")

    tags = {
        Name = "instance-${count.index}"
    }
}