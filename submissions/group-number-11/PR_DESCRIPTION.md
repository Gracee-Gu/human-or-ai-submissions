Title: [Submission] Group Number 11 - ab3396, yg695, yg667

The optimized detector achieves **0.98665 Kaggle public AUROC (team-reported)** and **0.999785 AUROC on the fixed 2,000-row validation split**. It combines 279 text/style features with 26 frozen local GPT-2 language statistics in LightGBM, then blends 75% of that model with 25% of the original word/character/style ensemble. The trainable classifiers use only supplied labels and are refit on all 10,000 labeled passages after selection. Private results remain pending.

The original rebuild scored 0.96962 public. A format-robust candidate improved synthetic stress results but scored 0.95899 public and was rejected. The report records this negative result, the later language-feature change, training-size and unlabeled-data experiments, grouped topic/style diagnostics, length subgroups and ten final-model errors. The public subset is small and repeated holdout search remains a limitation.

Reproduce the optimized CSV with `bash submissions/group-number-11/reproduce_optimized.sh DATA_DIR` after installing `requirements-optimization.txt`. Source, dependency versions, experiment summaries, editable report and figures are confined to `submissions/group-number-11/`. Competition data, language caches, model weights and credentials are excluded from Git.

Generic GPT-2 pretrained language weights run locally; no hosted prediction API, external authorship labels or hidden-label retrieval is used. OpenAI Codex assisted with implementation, experiment execution and report drafting. Yilin Gao leads Q1, Ansh Raj Bhargava leads Q3/Q5, and Yingzi Gu leads Q2/Q4; all members also experiment with models and will review the submission.
