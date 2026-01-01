#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

set -e -o pipefail

dir=$1

while IFS= read -r f; do
    e=$(basename "${f}")
    e=${e//.phi}
    phino merge "${f}" runtime.phi | \
        phino rewrite --normalize --hide=Q.org --focus=Q.ex "--expression=${e}" \
            --nonumber --sequence --compress "--meet-prefix=${e}" --output=latex \
            --flat --sweet
done < <(find "${dir}" -name '*.phi' -type f | sort)
