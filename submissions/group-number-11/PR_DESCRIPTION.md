Title: [Submission] Group Number 11 - ab3396, yg695, yg667

This submission rebuilds the team's text-authorship detector with one fixed stratified 2,000-row validation partition, reproducible word/character baselines, writing-style boosting and a selected ensemble. The final model is refit on all 10,000 supplied labeled examples and regenerates a 3,000-row `id,label` Kaggle file using the documented prediction command.

The ensemble achieves 0.997975 validation AUROC. Formatting collapse reduces its AUC to 0.877512; the report documents this limitation and a whitespace-augmentation experiment that improves stress-test AUC to 0.978602 but fails its prespecified acceptance criterion. The team supplied a Kaggle screenshot reporting 0.96962 public AUROC for the new submission; private AUROC remains pending. The previous public score 0.92433 belongs to an earlier model.

Validation includes the required model/hyperparameter comparisons, five training-set sizes, an unlabeled-data experiment, length subgroups, ten reviewed errors, near-duplicate checks and secondary split diagnostics. Submission schema, IDs, order, bounds, data hashes and row-order invariance were checked locally. Source, logs, editable report and figures are under `submissions/group-number-11/`; datasets, checkpoints and credentials are excluded.

OpenAI Codex assisted with implementation, experiment execution and report drafting. Yilin Gao leads Q1, Ansh Raj Bhargava leads Q3/Q5, and Yingzi Gu leads Q2/Q4; all members also experiment with models. The team will complete course submission review. No hidden labels or external prediction APIs were used.

Reproduction: activate the documented Python environment, then run `bash submissions/group-number-11/reproduce.sh DATA_DIR` from the repository root. The final CSV and model artifacts remain local and can be regenerated.
