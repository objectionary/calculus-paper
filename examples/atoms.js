#!/usr/bin/env node
// SPDX-FileCopyrightText: Copyright (c) 2016-2026 Objectionary.com
// SPDX-License-Identifier: MIT

// The two λ functions of the Celsius example. Since phino implements none of
// them, it writes a request to this program and reads its answer back: the
// formation under 𝑏, with the λ binding removed, and the 𝜑-expression the
// atom answers with under 𝑛. Both numbers of an arithmetic atom are already
// reduced here, ρ by the dataization that reached the atom and x by the one
// that reached its argument, so each of them spells its own bytes out as a Δ
// binding and this program never has to ask phino for anything.

'use strict';

const readline = require('readline');

function bound(formation, name) {
  const head = `${name} ↦ `;
  let depth = 0;
  let start = -1;
  for (let index = 0; index < formation.length; index += 1) {
    const char = formation[index];
    if ('⟦('.includes(char)) {
      depth += 1;
    } else if ('⟧)'.includes(char)) {
      if (depth === 1 && start >= 0) {
        return formation.slice(start, index);
      }
      depth -= 1;
    } else if (depth === 1 && start >= 0 && char === ',') {
      return formation.slice(start, index);
    } else if (depth === 1 && start < 0 && formation.startsWith(head, index) && ' ,⟦'.includes(formation[index - 1])) {
      start = index + head.length;
    }
  }
  return null;
}

function operand(formation, name) {
  const found = /Δ ⤍ ([0-9A-F-]+)/.exec(bound(formation, name) || '');
  if (found === null) {
    throw new Error(`the operand '${name}' of the atom carries no bytes`);
  }
  return Buffer.from(found[1].replace(/-/g, ''), 'hex').readDoubleBE(0);
}

function arithmetic(lambda) {
  if (lambda === 'L_number_times') {
    return (rho, x) => rho * x;
  }
  if (lambda === 'L_number_plus') {
    return (rho, x) => rho + x;
  }
  throw new Error(`this program stands for no atom named '${lambda}'`);
}

function answer(lambda, formation) {
  const bytes = Buffer.alloc(8);
  bytes.writeDoubleBE(arithmetic(lambda)(operand(formation, 'ρ'), operand(formation, 'x')), 0);
  const hex = [...bytes].map((octet) => octet.toString(16).toUpperCase().padStart(2, '0')).join('-');
  return `Φ.number( φ ↦ Φ.bytes( φ ↦ ⟦ Δ ⤍ ${hex} ⟧ ) )`;
}

readline.createInterface({ input: process.stdin }).on('line', (line) => {
  const request = JSON.parse(line);
  if ('𝑏' in request) {
    process.stdout.write(`${JSON.stringify({ id: request.id, '𝑛': answer(request['λ'], request['𝑏']) })}\n`);
  }
});
