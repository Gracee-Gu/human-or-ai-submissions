Title: [Submission] Group Number 11 - ab3396, yg695, yg667

Final public AUROC is **0.98921 (team-reported)**; fixed 2,000-row validation AUROC is **0.999822**. The final detector combines frozen local GPT-2 language statistics, writing-style features and LightGBM with a small supervised RoBERTa contribution. Generic pretrained weights run locally; all authorship supervision comes from the supplied labels. Tree components refit all 10,000 rows; RoBERTa retains an 8,000-row checkpoint chosen on the shared validation partition. Private results remain unknown.

The report records the full measured sequence: 0.96962 first rebuild, 0.95899 rejected format-robust model, 0.98665 language-feature model, 0.98861 neural hybrid and 0.98921 final. It includes the required model/hyperparameter comparisons, five training sizes, unlabeled-data experiment, length groups, ten final-model errors, grouped diagnostics and honest AI/pretrained-resource disclosure. Synthetic robustness and repeated holdout/public selection are discussed as limitations.

All changes are under `submissions/group-number-11/`. Install `requirements-optimization.txt` and run `bash submissions/group-number-11/reproduce_final.sh DATA_DIR`. The frozen prediction entrypoint is `predict_final.py`; `verify_final.py` checks the CSV and recorded result. Data, checkpoints and caches are excluded from Git. The locally delivered CSV is byte-identical to the scored final file.

Yilin Gao leads Q1, Ansh Raj Bhargava leads Q3/Q5 and Yingzi Gu leads Q2/Q4; all members also experimented with models. Codex assisted with code, runs, diagnostics and report drafting. This remains a draft PR for the team's review/contributions; no teammate invitations or messages were sent by the assistant.
