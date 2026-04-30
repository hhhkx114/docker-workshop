import pandas as pd
from pathlib import Path

DATA_DIR = Path("data")
COUNTRIES = ["US", "GB", "CA", "DE"]

def convert_csv_to_json(country_code: str) -> None:
    csv_path = DATA_DIR / f"{country_code}videos.csv"
    json_path = DATA_DIR / f"{country_code}videos.json"

    try:
        df = pd.read_csv(csv_path, encoding="utf-8")
    except UnicodeDecodeError:
        df = pd.read_csv(csv_path, encoding="latin-1")

    df.to_json(json_path, orient="records", lines=True, force_ascii=False)
    print(f"Converted {country_code}: {len(df)} rows -> {json_path}")


if __name__ == "__main__":
    for country in COUNTRIES:
        convert_csv_to_json(country)
