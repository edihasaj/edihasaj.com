# LLM writing tells

Small experiment behind the post "The delve era is over. The em dash is not."

Four models, 24 prompts each (12 everyday, 12 engineering), about 150 words per answer,
compared with wordfreq's English list and with 72k words of pre-ChatGPT commit message bodies.

## Files

- `prompts.txt`, `prompts-eng.txt`: the prompts.
- `run.sh`: collects answers through the `claude` and `codex` CLIs from an empty directory.
  `PROMPTS=prompts-eng.txt OUT=outputs-eng ./run.sh`. Existing answers are skipped.
- `outputs/`, `outputs-eng/`: raw answers, one file per model and prompt.
- `human/commits.txt`: commit bodies from Apache James, tmux and DAVx5 before 2022-06-01,
  with trailers, URLs and code-like lines removed. Rebuild with the command in the post.
- `analyze.py`: word-level comparison. `uv run analyze.py --set outputs-eng --human human/commits.txt`.
- `tells.py`: structural tells (em dash, bullets, bold, headings, "Here's", closing offer).
  `python3 tells.py outputs outputs-eng --human human/commits.txt`.

## Caveats

Small sample. Prompts pick the topics, so topic words dominate the over-used lists.
Both CLIs know the user's name from their own memory. Commit bodies are typed in a terminal,
which keeps the human em dash rate unfairly low.
