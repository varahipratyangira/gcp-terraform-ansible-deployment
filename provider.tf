provider "google" {
  credentials = "C:/Users/srini/servicegcp"  # Path to your service account key
  project     = "gcp-terraform-ansible-deployment"  # Your GCP project ID
  region      = "us-west1"  # The region of your resources
}
