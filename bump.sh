#!/bin/bash
# Point the formula at a critic2 release: ./bump.sh <tag>
#
# Downloads the release tarball, computes its sha256, and rewrites the url
# and sha256 lines of Formula/critic2.rb. The bottle block is left alone:
# brew pr-pull replaces it when the new bottles are published. See
# "Releasing a new version" in the README for the full procedure.
# (Written in Homebrew's shell style, which brew style enforces on taps.)
set -euo pipefail

if [[ $# -ne 1 ]] || [[ -z "$1" ]]
then
  echo "usage: $0 <tag>     (e.g. $0 1.5)" >&2
  exit 1
fi
tag="$1"
url="https://github.com/aoterodelaroza/critic2/archive/refs/tags/${tag}.tar.gz"
formula="$(dirname "$0")/Formula/critic2.rb"

sha=$(curl -sSLf "${url}" | sha256sum | cut -d' ' -f1)
sed -i.bak \
  -e "s|^  url \".*\"$|  url \"${url}\"|" \
  -e "s|^  sha256 \".*\"$|  sha256 \"${sha}\"|" \
  "${formula}"
rm -f "${formula}.bak"

echo "Formula/critic2.rb now points to critic2 ${tag}:"
grep -E '^  (url|sha256) ' "${formula}"
