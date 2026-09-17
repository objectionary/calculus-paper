#!/usr/bin/env bash
# SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
# SPDX-License-Identifier: MIT

set -e -o pipefail

dir=$1
d=$(basename "${dir}")

while IFS= read -r f; do
    e=$(basename "${f}")
    e=${e//.phi}
    e=${d}-${e}
    phino --pin=0.0.133 merge "${f}" runtime.phi | \
        phino --pin=0.0.133 rewrite --normalize --hide=Q.org --focus=Q.ex \
            --nonumber --sequence --compress "--meet-prefix=${e}" --output=latex \
            --flat --sweet
done < <(find "${dir}" -name '*.phi' -type f | sort)
