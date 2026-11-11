# Group 11: Human or AI?

Ansh Raj Bhargava (ab3396), Yilin Gao (yg695), Yingzi Gu (yg667).
Kaggle team name: **Group Number 11**. Branch: `Group11retry`.

Fork: [Gracee-Gu/human-or-ai-submissions](https://github.com/Gracee-Gu/human-or-ai-submissions/tree/Group11retry). Course draft PR: [#18](https://github.com/sekhari/human-or-ai-submissions/pull/18).

## Result and artifacts

The selected blend achieves **0.997975 AUROC** on the fixed, stratified 2,000-row validation set. This is a validation result, not a Kaggle score. Previous user-reported public score: **0.92433** (earlier model). Public/private scores for this new model are pending. No Kaggle submission has been made by this code. The user reported that submission becomes available on **November 11, 2026, at 7:00 p.m. America/New_York**; the actual platform reset must be checked on Kaggle.

- `output/submission.csv`: final probabilities for all 3,000 test IDs, in sample order (local; excluded from Git).
- `artifacts/final.joblib`: locally trained model, refit on all 10,000 labeled examples (excluded from Git).
- `report/main.tex`, `report/main.pdf`: editable Overleaf source and compiled report.
- `output/group11_overleaf.zip`: upload-ready LaTeX project (local).
- `results/`: actual experiments, fixed split, validation predictions, robustness diagnostics and data checksums. CSV evaluation logs contain IDs/results, not passages, and are generated locally (ignored by Git).

## Setup

Run commands from the repository root. After setup, `bash submissions/group-number-11/reproduce.sh DATA_DIR` runs the full pipeline. Tested on macOS arm64, Python 3.14.2, 24 GiB RAM; CPU training, no GPU/pretrained weights/external model services. Python 3.14.2 reproduces the tested environment; other Python versions require compatible package wheels. `environment.txt` records the exact versions used. On macOS, install the LightGBM OpenMP dependency with `brew install libomp`.

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r submissions/group-number-11/requirements.txt
```

Keep the original Kaggle CSVs in `cornell-tech-cs-5785-combined-2026-ai-vs-human-text/` or substitute your own data-directory path. Do not commit the data, checkpoints or credentials.

## Reproduce training and evaluation

```bash
OPENBLAS_NUM_THREADS=4 OMP_NUM_THREADS=4 python submissions/group-number-11/train.py \
  --data cornell-tech-cs-5785-combined-2026-ai-vs-human-text --final
OPENBLAS_NUM_THREADS=4 OMP_NUM_THREADS=4 python submissions/group-number-11/robustness.py \
  --data cornell-tech-cs-5785-combined-2026-ai-vs-human-text
OPENBLAS_NUM_THREADS=4 OMP_NUM_THREADS=4 python submissions/group-number-11/improve.py \
  --data cornell-tech-cs-5785-combined-2026-ai-vs-human-text --final
python submissions/group-number-11/analyze.py \
  --data cornell-tech-cs-5785-combined-2026-ai-vs-human-text
```

`train.py` reserves a fixed stratified 2,000-row validation set using seed **20261023** and fits all supervised representations and classifiers only on the remaining 8,000 rows. The starter file is not added as extra data. Models use text only; IDs are solely identifiers. We compare word/character logistic regression, linear SVM, NB-weighted logistic regression, and gradient boosting on writing-style features. The fixed grid searches LR/SVM C in {0.1, 1, 4, 16}, NB-LR C in {0.1, 1, 4}, and style boosting leaves in {7, 15, 31} with {300, 700} trees. For each representation, validation AUC chooses a component; a 15-entry blend grid (including repeated pure-style endpoints) chooses the final weights.

The final blend is 0.125 word SVM (C=1), 0.125 character LR (C=16), and 0.75 style LightGBM (31 leaves, 700 trees). The SVM margin is mapped through a sigmoid; this is **not** calibrated probability estimation. The ensemble probabilities are optimized for ranking/AUROC, not individual authorship certainty.

The learning curve uses word LR C=4 with a freshly fitted vocabulary at each of 500/1,000/2,000/5,000/8,000 labeled examples. The unlabeled experiment learns word vocabulary and IDF on 8,000 training + 3,000 unlabeled texts and trains LR C=4 only on true training labels. It excludes validation text/labels and test text from fitting and does not improve validation AUC, so it is not used in the final model.

`improve.py` tests label-preserving whitespace augmentation. Its acceptance rule was fixed before execution: native AUC within 0.0005 of the selected blend and whitespace-collapsed AUC >= 0.98. No augmented candidate passes, so the original blend is retained. The strongest native-text augmented candidate scores 0.997503 native / 0.978602 collapsed; the original blend scores 0.997975 / 0.877512. Formatting dependence is a material limitation despite high random-split AUC.

`robustness.py` freezes settings before three secondary split checks (seeds 20261024/25/26), an ablation, and validation-text transformations. These secondary splits overlap model-selection data and are **stability checks**, not independent holdouts. Bootstrap intervals are conditional on the selected fitted model and exclude selection uncertainty. Nearest-neighbor filtering does not establish source/domain independence.

## Generate the Kaggle CSV

```bash
python submissions/group-number-11/predict.py \
  --test cornell-tech-cs-5785-combined-2026-ai-vs-human-text/test.csv \
  --sample cornell-tech-cs-5785-combined-2026-ai-vs-human-text/sample_submission.csv \
  --out submissions/group-number-11/output/submission.csv
python submissions/group-number-11/verify.py \
  --data cornell-tech-cs-5785-combined-2026-ai-vs-human-text
```

Upload `output/submission.csv` manually once Kaggle allows another submission. The columns are exactly `id,label`; label is P(AI). Do not threshold predictions. No external hidden labels were used or retrieved.

## Report / Overleaf

```bash
python submissions/group-number-11/build_report.py
(cd submissions/group-number-11/report && tectonic main.tex)
python submissions/group-number-11/package.py
```

The report follows every Q0--Q6 response in the supplied assignment. Upload `output/group11_overleaf.zip` to Overleaf after packaging with `python submissions/group-number-11/package.py`. Overleaf uses pdfLaTeX; the project includes the generated figures. Re-run report generation/compilation/packaging after adding the verified PR URL, leaderboard scores or team contribution details to `report_metadata.json`.

## Development history and AI disclosure

The repository contains incremental commits for the experimental pipeline, validation/robustness analysis, and final report/delivery. Review the local history with `git log --oneline -- submissions/group-number-11`.

OpenAI Codex assisted with code implementation, experiment execution, diagnostics and report drafting. It trained the supplied data locally and checked outputs programmatically. No external LLM API labeled or predicted competition passages. The team reports that Yilin Gao led Q1 (model development), Ansh Raj Bhargava led Q3/Q5 (unlabeled data and improvements), and Yingzi Gu led Q2/Q4 (learning curves and error analysis). All three also trained models and explored stronger configurations. The implementation and runs in this rebuilt branch were assisted by Codex. Team members should verify the code and report before course submission. New-model leaderboard scores remain pending rather than invented.
