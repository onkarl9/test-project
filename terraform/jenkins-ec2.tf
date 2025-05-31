resource "aws_instance" "jenkins-server" {
  ami                         = "ami-0554aa6767e249943"
  instance_type               = "t2.micro"
  key_name                    = "AMZ_LINUX_EC2"
  subnet_id                   = "subnet-0229148c2f7e3ff3b" 
   
   
  user_data = <<-EOF
    #!/bin/bash
    yum install -y java-17-amazon-corretto.x86_64
    java --version
    wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
    rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
    yum -y upgrade
    yum install -y jenkins
    systemctl enable jenkins
    yum install -y git
  EOF

  tags = {
    Name = "jenkins-server"
  }
}
