terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.0"
    }
  }
}

provider "google" {
  project = var.project
  region  = var.region
}

# GCS Bucket (Data Lake)
resource "google_storage_bucket" "data_lake" {
  name          = "${var.gcs_bucket}-${var.project}"
  location      = var.location
  force_destroy = true
  storage_class = "STANDARD"
}

# BigQuery Dataset (Warehouse)
resource "google_bigquery_dataset" "dataset" {
  dataset_id = var.bq_dataset
  location   = var.location
}
