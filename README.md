# YouTube Trending Analytics Pipeline

An end-to-end ELT data pipeline that analyzes YouTube trending video data across multiple countries to answer: **"What is the best time to post a video to maximize the chance of trending?"**

## 🎯 Business Question

Content creators want to know the optimal timing to publish videos for maximum reach. This project processes YouTube trending data across 4 countries (US, GB, CA, DE) to surface data-driven insights on:
- Best hour of the day to publish
- Best day of the week to publish
- How posting patterns differ across countries
- Whether optimal timing varies by video category

## 🏗️ Architecture

<img width="1026" height="210" alt="image" src="https://github.com/user-attachments/assets/1e187e98-68c4-41b7-9039-235610edb5e5" />


## 🛠️ Tech Stack

| Layer | Tool |
|-------|------|
| Infrastructure as Code | Terraform |
| Data Lake | Google Cloud Storage |
| Data Warehouse | BigQuery |
| Orchestration | Kestra (via Docker Compose) |
| Transformation | dbt Cloud |
| Visualization | Looker Studio |
| Version Control | Git / GitHub |
| Languages | Python, SQL, YAML, HCL |

## 📊 Dataset

**Source:** [YouTube Trending Video Dataset (datasnaek/youtube-new)](https://www.kaggle.com/datasets/datasnaek/youtube-new)

Daily records of trending videos from 10 countries, with fields including `video_id`, `title`, `channel_title`, `publish_time`, `trending_date`, `category_id`, `views`, `likes`, `comment_count`.

For this project, I focused on 4 countries: **US, GB, CA, DE** — a mix of North American and European markets.

## 🔧 Pipeline Implementation

### 1. Infrastructure (Terraform)
Provisioned a GCS bucket (data lake) and BigQuery dataset (warehouse) via Terraform, making the infrastructure reproducible and version-controlled.

### 2. Data Ingestion
Encountered CSV parsing errors in BigQuery due to inconsistent quoting in YouTube metadata (tags with special characters, descriptions with commas). **Solved by preprocessing CSVs into newline-delimited JSON using pandas**, which preserves field integrity through proper escape handling.

### 3. Orchestration (Kestra)
Built Kestra flows with:
- KV store for GCP credentials and project config (separating secrets from flow logic)
- Parameterized pipeline that loads any country's data via a `country_code` input
- Explicit BigQuery schema definition for consistent typing

### 4. Transformation (dbt)
Implemented standard three-layer architecture:
- **Staging** (`stg_youtube_videos`, `stg_categories`): Unions 4 country tables, casts types, adds country codes
- **Intermediate** (`int_videos_with_time`): Joins categories, extracts hour/day features from publish timestamps
- **Mart** (`mart_best_time_to_post`): Aggregated analytical table for dashboard queries

Development follows Git-based workflow: feature branches → pull requests → merge to main.

### 5. Visualization (Looker Studio)
Built an interactive dashboard with:
- KPI scorecards (total trending videos, average views, average likes)
- Heatmap of publish day × hour showing trending concentration
- Hourly bar chart of overall publishing patterns
- Country dropdown filter for cross-market comparison

<img width="1136" height="878" alt="image" src="https://github.com/user-attachments/assets/1da6c0cd-a97c-4f02-83ce-92847f0ddc54" />


## 🔍 Key Findings


- **Peak posting time:** Thursday at 4 PM UTC produces the highest volume of trending videos
- **Weekday dominance:** Weekdays outperform weekends significantly, with afternoon (15:00–17:00) as the universal sweet spot
- **Saturday is worst:** Lowest trending rates across all countries — likely because audiences are less active during leisure time
- **Cross-country patterns:** Similar hourly trends across US/GB/CA/DE suggest the "afternoon peak" pattern is universal in Western markets

## 📂 Project Structure

```
youtube-trending-pipeline/
├── terraform/          # IaC for GCS bucket and BigQuery dataset
├── kestra/             # Docker Compose and flow YAMLs
├── dbt/                # dbt project with models and seeds
│   ├── models/
│   │   ├── staging/
│   │   ├── intermediate/
│   │   └── marts/
│   └── seeds/
└── README.md
```

## 🚀 How to Reproduce

### Prerequisites
- GCP account with billing enabled
- Docker Desktop
- Terraform, gcloud CLI installed
- Python 3.x with pandas
- dbt Cloud account (free tier)

### Setup Steps
1. Clone this repo
2. Create a GCP project and service account with BigQuery Admin + Storage Admin roles
3. Run `terraform init && terraform apply` in the `terraform/` folder
4. Download the dataset from Kaggle and preprocess CSVs to JSON
5. Upload preprocessed files to GCS: `gcloud storage cp *.json gs://your-bucket/raw/`
6. Start Kestra: `cd kestra && docker compose up -d`
7. Configure KV secrets and run the loading flow for each country
8. Connect dbt Cloud to BigQuery and run `dbt build`
9. Connect Looker Studio to the `mart_best_time_to_post` table

## 💡 Lessons Learned

- **End-to-end pipeline experience**: This was my first time building a complete data engineering pipeline from infrastructure to dashboard. Each tool taught me something different — Terraform for declarative infrastructure, Kestra for orchestration thinking, dbt for SQL discipline, and the importance of every layer working together
- **Data quality first**: CSV parsing ambiguity cost me hours of debugging — preprocessing messy CSVs to clean JSON via pandas was the right call. Production pipelines need defensive data handling

## 📝 Future Improvements

- **Full Kestra orchestration**: Currently I run dbt manually via dbt Cloud. A more production-like setup would have Kestra trigger dbt builds as part of the same flow, creating a true end-to-end orchestrated pipeline
- **Scheduled pipeline runs**: Add Kestra triggers to run the pipeline on a daily schedule (this dataset is updated daily on Kaggle)
- **Streaming alongside batch**: Currently this is purely batch ELT. A natural extension would be to ingest YouTube API data in near-real-time via streaming (e.g., Pub/Sub + Dataflow) for live trending updates
- **Add dbt tests** (unique, not_null, accepted_values) for data quality enforcement

