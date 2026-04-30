variable "project" {
  description = "youtube-trending-kx26"
}

variable "region" {
  default = "europe-west1"
}

variable "location" {
  default = "EU"
}

variable "bq_dataset" {
  default = "youtube_trending_data"
}

variable "gcs_bucket" {
  default = "youtube-trending-bucket"
}
