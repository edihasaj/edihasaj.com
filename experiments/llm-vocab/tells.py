"""Structural tells per model: share of documents with each feature, plus em dashes per 1k words.

Usage: python3 tells.py [outputs outputs-eng ...] [--human human/commits.txt]
"""
import re, sys
from pathlib import Path
from collections import defaultdict

FEATURES = {
    "em dash":        lambda t: "—" in t,
    "bullet list":    lambda t: re.search(r"^\s*([-*•]|\d+\.)\s", t, re.M) is not None,
    "bold":           lambda t: "**" in t,
    "heading":        lambda t: re.search(r"^#{1,6}\s", t, re.M) is not None,
    "opens 'Here's'": lambda t: re.match(r"\s*(here's|here is|sure|certainly|below)", t, re.I) is not None,
    "closing offer":  lambda t: re.search(r"(let me know|want (me|it|this)|happy to|would you like|if you'd like)[^\n]*\??\s*$", t.strip(), re.I) is not None,
}
def words(t): return len(re.findall(r"[A-Za-z']+", t))

def main():
    argv = sys.argv[1:]
    if "--human" in argv:
        i = argv.index("--human"); argv = argv[:i] + argv[i + 2:]
    args = argv
    sets = args or ["outputs", "outputs-eng"]
    docs = defaultdict(list)
    for s in sets:
        for d in sorted(Path(s).iterdir()):
            if d.is_dir():
                docs[d.name] += [p.read_text() for p in sorted(d.glob("*.txt"))]
    print(f"{'model':22s}{'docs':>5s}" + "".join(f"{f:>16s}" for f in FEATURES) + f"{'—/1k words':>12s}")
    for m, ds in docs.items():
        row = f"{m:22s}{len(ds):5d}"
        for f, fn in FEATURES.items():
            row += f"{sum(fn(d) for d in ds) / len(ds):16.0%}"
        row += f"{sum(d.count('—') for d in ds) / sum(words(d) for d in ds) * 1000:12.1f}"
        print(row)
    if "--human" in sys.argv:
        t = Path(sys.argv[sys.argv.index("--human") + 1]).read_text()
        print(f"{'human commits':22s}{'':5s}" + f"{'':16s}" * len(FEATURES) + f"{t.count('—') / words(t) * 1000:12.1f}")

if __name__ == "__main__":
    main()
