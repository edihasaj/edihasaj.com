# /// script
# dependencies = ["wordfreq"]
# ///
"""Compare model vocabulary against everyday English and, optionally, a human corpus.

Usage: uv run analyze.py [--set outputs-eng] [--human human/commits.txt] [--json]
Baseline for every table is wordfreq's 'en' list (web, books, news, subtitles, social).
With --human, a second baseline comes from the given text file (per-million rates).
"""
import json, re, sys
from collections import Counter
from pathlib import Path
from wordfreq import word_frequency, zipf_frequency

HERE = Path(__file__).parent
WORD = re.compile(r"[a-z][a-z'-]*[a-z]|[a-z]")
STOP_ZIPF = 5.5      # skip function words when ranking
MIN_COUNT = 3
SKIP = {"edi", "hi", "rn", "m", "s", "t", "re", "ve", "ll", "d"}   # names, contractions, noise
WATCH = ["delve","tapestry","nuanced","robust","leverage","crucial","seamless","landscape",
         "streamline","foster","holistic","journey","ensure","navigate","meticulous","pivotal",
         "underscore","elevate","additionally","comprehensive","vibrant","testament","realm",
         "harness","empower","provenance","actionable","granular","align","insight",
         "deterministic","idempotent","observability","guardrails","surface","footgun","canonical",
         "drift","invariant","semantics","ergonomics","orthogonal","non-trivial","brittle"]

def arg(flag, default=None):
    return sys.argv[sys.argv.index(flag) + 1] if flag in sys.argv else default

def tokens(text):
    return [t for t in WORD.findall(text.lower()) if t not in SKIP]

def zipf_profile(toks):
    content = [zipf_frequency(t, "en") for t in toks if zipf_frequency(t, "en") < STOP_ZIPF]
    return (sum(content) / max(len(content), 1),
            sum(1 for z in content if z < 3.5) / max(len(content), 1))

def rank(counts, n, base_pm, min_count=MIN_COUNT):
    """Words over-used vs a baseline: (word, count, model/M, base/M, ratio)."""
    rows = []
    for w, c in counts.items():
        if c < min_count or zipf_frequency(w, "en") >= STOP_ZIPF:
            continue
        obs, base = c / n * 1e6, base_pm(w)
        rows.append((w, c, obs, base, obs / (base or 0.5)))
    return sorted(rows, key=lambda r: -r[4])

def stats(texts, human=None):
    toks = [t for txt in texts for t in tokens(txt)]
    n, counts = len(toks), Counter(t for txt in texts for t in tokens(txt))
    mean_z, rare = zipf_profile(toks)
    out = dict(n_docs=len(texts), tokens=n, types=len(counts), mean_content_zipf=mean_z,
               rare_share=rare, top_vs_web=rank(counts, n, lambda w: word_frequency(w, "en") * 1e6)[:20],
               watch={w: counts[w] for w in WATCH if counts[w]})
    if human:
        hn, hc = human
        out["top_vs_human"] = rank(counts, n, lambda w: hc[w] / hn * 1e6)[:20]
        # words humans use a lot (>=100/M in the human corpus) that the model barely touches
        under = []
        for w, c in hc.items():
            if c / hn * 1e6 < 100 or zipf_frequency(w, "en") >= STOP_ZIPF:
                continue
            obs = counts[w] / n * 1e6
            under.append((w, counts[w], obs, c / hn * 1e6, obs / (c / hn * 1e6)))
        out["under_vs_human"] = sorted(under, key=lambda r: r[4])[:20]
    return out

def table(title, rows, left="model"):
    print(f"  -- {title}")
    print(f"  {'word':16s}{'count':>6s}{left + '/M':>10s}{'base/M':>10s}{'ratio':>8s}")
    for w, c, obs, base, r in rows:
        print(f"  {w:16s}{c:6d}{obs:10.0f}{base:10.1f}{r:8.1f}x")

def main():
    out_dir = HERE / arg("--set", "outputs")
    human = None
    if arg("--human"):
        htoks = tokens(Path(arg("--human")).read_text())
        human = (len(htoks), Counter(htoks))
        hz, hr = zipf_profile(htoks)
        print(f"=== human baseline {arg('--human')}: {len(htoks)} tokens, mean content zipf {hz:.2f}, rare share {hr:.1%}")
    res = {d.name: stats([p.read_text() for p in sorted(d.glob("*.txt"))], human)
           for d in sorted(out_dir.iterdir()) if d.is_dir()}
    if "--json" in sys.argv:
        print(json.dumps(res, indent=1)); return
    for k, s in res.items():
        print(f"\n=== {k}: {s['n_docs']} docs, {s['tokens']} tokens, {s['types']} types, "
              f"mean content zipf {s['mean_content_zipf']:.2f}, rare share {s['rare_share']:.1%}")
        table("over-used vs everyday English (wordfreq)", s["top_vs_web"])
        if human:
            table("over-used vs human commit prose", s["top_vs_human"])
            table("under-used vs human commit prose", s["under_vs_human"])
        print("  watchlist:", ", ".join(f"{w}={c}" for w, c in sorted(s["watch"].items(), key=lambda x: -x[1])) or "(none)")
    key = "top_vs_human" if human else "top_vs_web"
    common = None
    for s in res.values():
        ws = {w for w, c, obs, base, r in s[key] if r >= 5}
        common = ws if common is None else common & ws
    print("\nover-used (>=5x) by every model:", ", ".join(sorted(common or [])) or "(none)")

if __name__ == "__main__":
    main()
