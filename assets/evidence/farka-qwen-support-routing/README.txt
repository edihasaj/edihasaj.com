Farka Qwen3.5 9B routing demonstration

Completed 21 August 2026. Published with the article in September 2026.

Files:
- paired-predictions.csv: 30 row hashes, recorded expected labels, before/after predictions.
- evaluation.json: selected training settings, recomputed counts and limitations.
- check_predictions.py: audits these saved predictions using Python's standard library.

Download the three files into one folder and run:
python3 check_predictions.py

Expected: before 23/30; after 30/30.
This checks arithmetic and paired row identifiers, not model inference or label correctness.
The CSV does not include original request texts or model weights. Account identifiers,
workspace paths, access URLs and private operational records were omitted.
The legacy report lacks the newer baselineSource marker; the platform records this as
its base/tuned comparison. Do not describe this package as complete reproduction.

The evaluation set was used in checkpoint evaluation. The generated-message pattern
split was not independently re-audited. No independent blind test or simpler-baseline
comparison is claimed. Model source: https://huggingface.co/Qwen/Qwen3.5-9B
