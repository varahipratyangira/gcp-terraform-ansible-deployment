provider "google" {
  credentials = file("<path-to-your-service-account-key>.json")
  project     = "<your-gcp-project-id>"
  region      = "us-west1"
}
