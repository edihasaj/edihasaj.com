#!/usr/bin/env bash
# Collect model outputs for the LLM vocabulary experiment.
# Usage: ./run.sh            (all models)   ./run.sh claude:sonnet   (one model)
set -u
cd "$(dirname "$0")"
PROMPTS=${PROMPTS:-prompts.txt}; OUT=${OUT:-outputs}
SCRATCH=$(mktemp -d /tmp/llm-vocab-empty.XXXX); export SCRATCH   # empty cwd so models cannot read this repo
MODELS=(${1:-claude:sonnet claude:opus codex:gpt-5.6-sol codex:gpt-5.6-terra})
one() {
  local model="$1" n="$2" prompt="$3"
  local dir="$OUT/${model//:/_}" out
  mkdir -p "$dir"; out="$dir/$(printf '%02d' "$n").txt"
  [ -s "$out" ] && return 0
  case "$model" in
    claude:*) (cd "$SCRATCH" && claude -p "$prompt" --model "${model#claude:}" --setting-sources "" \
        --system-prompt "You are a helpful assistant." --output-format text) > "$out.tmp" 2>/dev/null ;;
    codex:*)  codex exec -C "$SCRATCH" --skip-git-repo-check --ignore-user-config --ignore-rules --ephemeral \
        -s read-only -m "${model#codex:}" -o "$out.tmp" "$prompt" < /dev/null > /dev/null 2>&1 ;;
  esac
  if [ -s "$out.tmp" ]; then mv "$out.tmp" "$out"; echo "ok  $model #$n"; else rm -f "$out.tmp"; echo "ERR $model #$n"; fi
}
job() { IFS=$'\t' read -r m n p <<< "$1"; one "$m" "$n" "$p"; }
export -f one job
n=0
{ while IFS= read -r prompt; do
    n=$((n+1))
    for m in "${MODELS[@]}"; do printf '%s\t%s\t%s\0' "$m" "$n" "$prompt"; done
  done < "$PROMPTS"; } | xargs -0 -P 6 -n 1 bash -c 'job "$0"'
