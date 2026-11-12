#!/usr/bin/env bash
# Reproduce language_v2, the submission with user-reported public AUROC 0.98665.
# Run from the repository root with requirements-optimization.txt installed.
set -euo pipefail
data_dir="${1:-cornell-tech-cs-5785-combined-2026-ai-vs-human-text}"
team_dir="submissions/group-number-11"
export OPENBLAS_NUM_THREADS=2
export OMP_NUM_THREADS=2
mkdir -p "$team_dir/artifacts/optimization"
python "$team_dir/train.py" --data "$data_dir" --final
cp "$team_dir/artifacts/final.joblib" "$team_dir/artifacts/optimization/baseline_public_0.96962.joblib"
python "$team_dir/lm_features.py" --data "$data_dir" \
  --output "$team_dir/artifacts/optimization/lm" --model-id openai-community/gpt2 \
  --revision 607a30d783dfa663caf39e06633721c8d4cfcd7e \
  --max-tokens 256 --datasets train test
python "$team_dir/search_language_models.py" --data "$data_dir" --lm-dirs lm --name language_small
python "$team_dir/select_language.py" --data "$data_dir" --search language_small --name language_v2 --final
python "$team_dir/predict_optimized.py" \
  --test "$data_dir/test.csv" --sample "$data_dir/sample_submission.csv" \
  --model "$team_dir/artifacts/optimization/language_v2.joblib" \
  --out "$team_dir/output/submission_language_v2.csv"
