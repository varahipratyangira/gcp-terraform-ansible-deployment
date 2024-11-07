resource "google_storage_bucket" "static_site_bucket" {
  name     = "<unique-bucket-name>"
  location = "US"
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "nginx_server" {
  name         = "nginx-server"
  machine_type = "f1-micro"
  zone         = "us-central1-a"

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
    gsutil cp gs://<your-bucket-name>/index.html /var/www/html/index.html
    systemctl restart nginx
  EOF
}
