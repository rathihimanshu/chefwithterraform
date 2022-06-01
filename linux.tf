resource "aws_instance" "myvm" {
  ami = var.ami
  instance_type = "t2.micro"
  tags = {
    Name = "chefnode3"
  }
  key_name = "jan22"
  provisioner "chef" {
    node_name = "chefnode3"
    server_url = "https://api.chef.io/organizations/chefdemo22here"
    user_key = file("chefdemo22.pem")
    user_name = "chefdemo22"
    skip_install = true
    run_list = []
    recreate_client = true
    client_options  = ["chef_license 'accept'"]
    connection {
      type = "ssh"
      user = "ubuntu"
      private_key = file("jan22.pem")
      host = aws_instance.myvm.public_ip
    }
  }
#  provisioner "local-exec" {
#    command = "cd ${var.knife_path} && knife node delete ${aws_instance.bastion_server.tags.Name} -y && knife client delete ${aws_instance.bastion_server.tags.Name} -y || true"
#  }
#  provisioner "local-exec" {
 #   command = "cd ${var.knife_path} && knife bootstrap ${aws_instance.bastion_server.public_ip} -N ${aws_instance.bastion_server.tags.Name} -r 'role[bastion]' -x ubuntu -i ${var.provisioner_key} --sudo"
 # }
#  provisioner "local-exec" {
#    command = "cd ${var.knife_path} && knife node run_list add ${aws_instance.bastion_server.tags.Name} 'role[bastion]'"
#  }
}
