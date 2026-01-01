# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

.SHELLFLAGS=-e -x -c
.ONESHELL:
.PHONY: clean zip all test
SHELL=bash

REPO=objectionary/calculus-paper

zip: *.tex sections/*.tex
	./zip-it.sh "$(REPO)"

clean:
	git clean -dfX
