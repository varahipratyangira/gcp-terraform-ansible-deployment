resource "google_storage_bucket" "static_site_bucket" {
  name     = "gcp-terraform-ansible-deployment-bucket"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "nginx_server" {
  name         = "nginx-server"
  machine_type = "f1-micro"
  zone         = "us-west1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {}
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y nginx gsutil
    gsutil cp gs://gcp-terraform-ansible-deployment-bucket/index.html /var/www/html/index.html
    systemctl restart nginx
  EOF
}

resource "google_compute_firewall" "default" {
  name    = "default-allow-http"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]
}

resource "google_compute_global_forwarding_rule" "http" {
  name       = "http-forwarding-rule"
  target     = google_compute_target_http_proxy.http.id
  port_range = "80"
}

resource "google_compute_target_http_proxy" "http" {
  name    = "http-proxy"
  url_map = google_compute_url_map.default.id
}

resource "google_compute_url_map" "default" {
  name = "default-url-map"

  default_url_redirect {
    https_redirect = false
    strip_query    = false
    prefix         = "/"
  }
}
terraform {
  backend "gcs" {
    bucket = "gcp-terraform-ansible-deployment-bucket"
    prefix = "terraform/state"
  }
}
