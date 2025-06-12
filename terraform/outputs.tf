output instance_id {
    description = "ID of the EC2 instance"
    value = aws_instance.minecraft_server.id
}

output "public_ip" {
    description = "Public IP of the EC2 instance - used to connect to the server"
    value = aws_instance.minecraft_server.public_ip
}