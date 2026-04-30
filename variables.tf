variable "project" {
  description = "youtube-trending-kx26"
}

variable "region" {
  default = "europe-west1"  # Change to your preferred region
}

variable "location" {
  default = "EU"  # Or US
}

variable "bq_dataset" {
  default = "youtube_trending_data"
}

variable "gcs_bucket" {
  default = "youtube-trending-bucket"  # Must be globally unique
}
