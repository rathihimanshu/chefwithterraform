variable "admin_password" {
  default     = "India@12345"
}
resource "aws_instance" "windows" {
  provisioner "chef" {
    server_url      = "https://api.chef.io/organizations/chefdemo22here"
    user_name       = "chefdemo22"
    user_key        = file("chefdemo22.pem")
    node_name       = "win-01"
    run_list        = []
    recreate_client=true
    version         = "12.4.1"
  }
  connection {
    type     = "winrm"
    user     = "Administrator"
    password = "India@12345"
    host = aws_instance.windows.public_ip
  }
  instance_type = "t2.micro"
  ami           = "ami-04b0b3dc6f472bfeb"
  key_name = "jan22"
  security_groups = ["default"]
  user_data = <<EOF
    <script>
      winrm quickconfig -q & winrm set winrm/config/winrs @{MaxMemoryPerShellMB="300"} & winrm set winrm/config @{MaxTimeoutms="1800000"} & winrm set winrm/config/service @{AllowUnencrypted="true"} & winrm set winrm/config/service/auth @{Basic="true"}
    </script>
    <powershell>
      netsh advfirewall firewall add rule name="WinRM in" protocol=TCP dir=in profile=any localport=5985 remoteip=any localip=any action=allow
      $admin = [adsi]("WinNT://./administrator, user")
      $admin.psbase.invoke("SetPassword", "${var.admin_password}")
    </powershell>
  EOF
}

# Show the public IP address at the end
output "address" {
  value = "${aws_instance.windows.public_ip}"
}
