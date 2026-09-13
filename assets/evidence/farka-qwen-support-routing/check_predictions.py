"""Audit recorded predictions. No model inference or external dependencies."""
from pathlib import Path
import csv, json
ROOT = Path(__file__).resolve().parent
rows = list(csv.DictReader((ROOT / "paired-predictions.csv").open()))
summary = json.loads((ROOT / "evaluation.json").read_text())
assert len(rows) == len({r["input_sha256"] for r in rows}) == 30
assert {r["expected"] for r in rows} == {"billing", "account", "technical"}
for condition, expected in [("before", 23), ("after", 30)]:
    actual = sum(r[condition] == r["expected"] for r in rows)
    assert actual == expected == summary["results"][condition + "_correct"]
    print(f"{condition}: {actual}/{len(rows)}")
