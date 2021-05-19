#Get Linux AMI ID using SSM Parameter endpoint in us-east-1
data "aws_ssm_parameter" "linuxAmi" {
  provider = aws.region-master
  name     = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Create key-pair for logging into EC2 in us-east-1
resource "aws_key_pair" "master-key" {
  provider   = aws.region-master
  key_name   = "jenkins"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpkzk7o8l4XFx0GF73m8P6B2Eg2oh0opCH5zQTXb+7eJzv+N/jFnJ8W4v+QOphjlR+mwR8hByozkaYbCPeowDBhnBnFFKLVtu2zswFWHPeZprryjDBIsFSIGuXgVmkCHyyAq3DqEtf+P4Z5TflWOwEUsqvTdMKX2g/xpo8IKxOMIyrHUuMw1w9luypVlqTZQfM5pUGlOIBEm3sYbpTZr815HHZQA8xraiFm1bFUUjPJ7O13wFIifclVqCOqyQrUeFiSzIx+6Ebu4/0hcJMWWfW3Vr/YbPRpfy/STtvLunadpUOpf4eWt5gT1xxcEVddnSQEYy3WnFcdZdEODqHlKx34V4u7Ll9HF4Y6AGU7WFy/VPxdKPHVB25156VCDHyNXQ3pPioH6EuCrKlsKiqV1+PW7v7NrORpQEKsJM/gbitPxyg8GL+Rc4sfo3xrlqmvL1pN85ZO0T2RKb9u3pOC7XcTzLqsN2YRasZTD1wRek1htq7pAulR/IpSy6jb4I/H/Uu4dVVLqcgoKUTtXJVjbPSXCN2Bt8ezoEuhXt/HXkzE+fARAFXT+iEJn5B2AI70dCtXNxThevicvu2H2mxfGzE5qxYMU4+W3wcCZMhdnM4kUcwMF61YMO3m8kg4QII0g1qL6mC2nSoumOK555ZhOh/mgwOsnU9RmXfJKql/rcFww== erwidaniel@gmail.com"
}

resource "aws_instance" "jenkins-master" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.jenkins-sg.id]
  subnet_id                   = aws_subnet.subnet_1.id

  tags = {
    Name = "jenkins_master_tf"
  }

}

#Create EC2-2
resource "aws_instance" "jenkins-slave1" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.jenkins-sg-2.id]
  subnet_id                   = aws_subnet.subnet_2.id

  tags = {
    Name = "jenkins_slave_tf"
  }
  
}

#Create EC2-2
resource "aws_instance" "jenkins-slave2" {
  provider                    = aws.region-master
  ami                         = data.aws_ssm_parameter.linuxAmi.value
  instance_type               = var.instance-type
  key_name                    = aws_key_pair.master-key.key_name
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.lb-sg.id]
  subnet_id                   = aws_subnet.subnet_3.id

  tags = {
    Name = "jenkins_slave_tf2"
  }
  
}
