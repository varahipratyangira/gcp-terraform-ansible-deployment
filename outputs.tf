output "bucket_name" {
  value = google_storage_bucket.static_site_bucket.name
}

output "nginx_ip" {
  value = google_compute_instance.nginx_server.network_interface[0].access_config[0].nat_ip
}
