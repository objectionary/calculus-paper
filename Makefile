# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

.SHELLFLAGS=-e -x -c
.ONESHELL:
.PHONY: clean zip all test
SHELL=bash

REPO=objectionary/calculus-paper

TEXS := $(wildcard sections/*.tex sections/proofs/*.tex) paper.tex
PHINO := phino-version.txt runtime.phi examples-to-tex.sh endless-to-tex.sh $(shell find examples -type f)

all: paper.pdf zip

paper.pdf: $(TEXS) $(PHINO)
	latexmk -g -pdf paper

zip: *.tex sections/*.tex
	./zip-it.sh "$(REPO)"

clean:
	git clean -dfX
