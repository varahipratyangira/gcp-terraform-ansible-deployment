output "nginx_ip" {
  value = google_compute_instance.nginx_server.network_interface[0].access_config[0].nat_ip
}
