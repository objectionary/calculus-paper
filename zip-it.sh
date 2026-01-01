#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

set -e -o pipefail

REPO=$1

rm -rf package
mkdir package
cd package
cp ../paper.tex .
cp ../examples-to-tex.sh .
cp ../endless-to-tex.sh .
cp ../runtime.phi .
cp -R ../examples .
mkdir bibliography
cp ../bibliography/main.bib bibliography/main.bib

TLROOT=$(kpsewhich -var-value TEXMFDIST)
for p in ffcode to-be-determined href-ul iexec eolang naive-ebnf; do
    cp "${TLROOT}/tex/latex/${p}/${p}.sty" .
done
for d in _tex sections examples; do
    cp -r "../${d}" .
done

version=$(curl --silent -H "Accept: application/vnd.github.v3+json" "https://api.github.com/repos/${REPO}/releases/latest" | jq -r '.tag_name')
echo "Version is: ${version}"

if ! sed --version; then
    echo "⚠️ You must have GNU sed"
    exit 1
fi

sed -i "s|0\.0\.0|${version}|g" paper.tex
sed -i "s|0\.0\.0|${version}|g" sections/abstract.tex
sed -i "s|REPOSITORY|${REPO}|g" sections/abstract.tex
pdflatex -shell-escape -halt-on-error paper.tex

bibtex paper
pdflatex -halt-on-error paper.tex
pdflatex -halt-on-error paper.tex
rm -rf ./*.aux ./*.bcf ./*.blg ./*.fdb_latexmk ./*.fls ./*.log ./*.run.xml ./*.out ./*.exc ./*.ret ./*.sh
rm -rf bibliography
rm -rf examples
rm -rf runtime.phi
rm -rf _eolang/*.pl
zip="paper-${version}.zip"
zip -x paper.pdf -r "${zip}" ./*
echo "🍒 ZIP is ready for arXiv at ${zip} ($(du -sh "${zip}" | cut -f1))"

mv "${zip}" ..
cd ..
