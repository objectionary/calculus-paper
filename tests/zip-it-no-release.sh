#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

# zip-it.sh must print "no release tag" when the releases API answers 404.

set -e -o pipefail

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "${tmp}"' EXIT

mkdir -p "${tmp}/bin" "${tmp}/tl/tex/latex" "${tmp}/work"
for p in ffcode to-be-determined href-ul iexec eolang naive-ebnf; do
    mkdir -p "${tmp}/tl/tex/latex/${p}"
    touch "${tmp}/tl/tex/latex/${p}/${p}.sty"
done
printf '#!/bin/sh\necho "%s"\n' "${tmp}/tl" > "${tmp}/bin/kpsewhich"
printf '#!/bin/sh\necho "curl: (22) The requested URL returned error: 404" >&2\nexit 22\n' > "${tmp}/bin/curl"
printf '#!/bin/sh\ncat\n' > "${tmp}/bin/jq"
chmod +x "${tmp}/bin/"*

cp -R "${root}/." "${tmp}/work/"
cd "${tmp}/work"
mkdir -p bibliography
touch bibliography/main.bib
set +e
err=$(PATH="${tmp}/bin:${PATH}" ./zip-it.sh foo/bar 2>&1 >/dev/null)
code=$?
set -e

if [ "${code}" -eq 0 ] || ! grep -q "no release tag for foo/bar" <<< "${err}"; then
    echo "expected 'no release tag for foo/bar' and non-zero exit, got ${code}: ${err}" >&2
    exit 1
fi
echo "OK"
