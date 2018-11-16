variable "aws_access_key" {
  type = "string"
  default = ""
}

variable "aws_secret_key" {
  type = "string"
  default = ""
}

provider "aws" {
  region     = "eu-central-1"
  access_key = "${var.aws_access_key}"
  secret_key = "${var.aws_secret_key}"
}

resource "aws_instance" "tomcat" {
  ami           = "ami-3c635cd7"
#  ami           = "ami-546758bf"
  instance_type = "t2.micro"
  key_name	= "vvv-eu"
  count = 1
  user_data = <<HEREDOC
#!/bin/bash
apt-get update
apt-get install -y tomcat8 tomcat8-admin
sed -i s/JAVA_OPTS=\"/JAVA_OPTS=\"-Djava.net.preferIPv4Stack=true\ -Djava.net.preferIPv4Addresses=true\ /g /etc/default/tomcat8
sed -i 's|</tomcat-users>|<user\ username="vvv"\ password="vvv" roles="manager-gui,admin-gui,manager-script,admin-script"/></tomcat-users>|g' /etc/tomcat8/tomcat-users.xml
systemctl restart tomcat8
HEREDOC
}

output "tomcat_public_ip" {value = "${aws_instance.tomcat.*.public_ip[0]}"}
