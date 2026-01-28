
resource "aws_instance" "public_instance" {
  ami                    = var.ec2_specs.ami
  subnet_id              = aws_subnet.public_subnet.id
  instance_type          = var.ec2_specs.instance_type
  key_name               = data.aws_key_pair.clunaKeyaws.key_name
  vpc_security_group_ids = [aws_security_group.sg_public_instance.id]
  monitoring             = false # Detailed monitoring costs extra

  root_block_device {
    volume_type           = "gp2" # gp2 is Free Tier, gp3 costs extra
    volume_size           = 8     # Free Tier limit is 30GB, using 8GB
    encrypted             = false # Encryption may incur costs
    delete_on_termination = true
  }

  tags = {
    Name = "ec2_public"
  }

  user_data = file("userdata.sh")

  # PROVISIONER LOCAL-EXEC: Ejecuta comandos en la máquina local
  provisioner "local-exec" {
    command = "echo 'Instancia creada con IP: ${self.public_ip}' >> instancia_log.txt"
  }

  # PROVISIONER LOCAL-EXEC: Con variables de entorno
  provisioner "local-exec" {
    command = "echo $INSTANCE_ID creada en $REGION"
    environment = {
      INSTANCE_ID = self.id
      REGION      = var.region
    }
  }

  # PROVISIONER REMOTE-EXEC: Ejecuta comandos en la instancia remota
  provisioner "remote-exec" {
    inline = [
      "sleep 30", # Esperar a que user_data termine
      "while ! systemctl is-active --quiet httpd; do echo 'Esperando httpd...'; sleep 5; done",
      "sudo yum install -y git",
      "sudo systemctl status httpd --no-pager",
      "echo 'Configuración adicional completada' | sudo tee -a /var/log/setup.log"
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("clunaKeyaws.pem")
      timeout     = "5m"
    }
  }

  # PROVISIONER FILE: Copia archivos a la instancia
  provisioner "file" {
    content     = <<-EOT
      <!DOCTYPE html>
      <html>
      <head><title>Mi Servidor</title></head>
      <body>
        <h1>Servidor configurado con Terraform</h1>
        <p>IP: ${self.public_ip}</p>
        <p>Instancia: ${self.id}</p>
      </body>
      </html>
    EOT
    destination = "/tmp/index.html"

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("clunaKeyaws.pem")
    }
  }

  # PROVISIONER REMOTE-EXEC: Mover archivo copiado
  provisioner "remote-exec" {
    inline = [
      "sudo mv /tmp/index.html /var/www/html/",
      "sudo chown apache:apache /var/www/html/index.html",
      "sudo systemctl restart httpd" # restart en lugar de reload
    ]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = "ec2-user"
      private_key = file("clunaKeyaws.pem")
    }
  }

  # PROVISIONER LOCAL-EXEC: Al destruir la instancia
  provisioner "local-exec" {
    when    = destroy
    command = "echo 'Instancia ${self.id} destruida el $(date)' >> instancia_log.txt"
  }
}
