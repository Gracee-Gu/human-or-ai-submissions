#!/usr/bin/env bash
# Run from the repository root with the project environment activated.
set -euo pipefail
data_dir="${1:-cornell-tech-cs-5785-combined-2026-ai-vs-human-text}"
team_dir="submissions/group-number-11"
export OPENBLAS_NUM_THREADS=4
export OMP_NUM_THREADS=4
python "$team_dir/train.py" --data "$data_dir" --final
python "$team_dir/robustness.py" --data "$data_dir"
python "$team_dir/improve.py" --data "$data_dir" --final
python "$team_dir/analyze.py" --data "$data_dir"
python "$team_dir/predict.py" --test "$data_dir/test.csv" \
  --sample "$data_dir/sample_submission.csv" --out "$team_dir/output/submission_baseline.csv"
python "$team_dir/verify.py" --data "$data_dir"
python "$team_dir/build_report.py"
if command -v tectonic >/dev/null 2>&1; then
  (cd "$team_dir/report" && tectonic main.tex)
  python "$team_dir/package.py"
fi
