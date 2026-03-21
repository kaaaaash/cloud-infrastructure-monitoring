output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.monitoring.public_ip
}

output "grafana_url" {
  description = "Grafana dashboard URL"
  value       = "http://${aws_instance.monitoring.public_ip}:3000"
}

output "prometheus_url" {
  description = "Prometheus URL"
  value       = "http://${aws_instance.monitoring.public_ip}:9090"
}