# Paper About φ-Calculus

[![arXiv](https://img.shields.io/badge/arXiv-2111.13384-green.svg)](https://arxiv.org/abs/2111.13384)
[![make](https://github.com/objectionary/calculus-paper/actions/workflows/latexmk.yml/badge.svg)](https://github.com/objectionary/calculus-paper/actions/workflows/latexmk.yml)

This is the first paper about 𝜑-calculus ([read in PDF][pdf]).

The reference interpreter is [phino].

To build it, just run:

```bash
make
```

You need to have [LaTeX], [GNU Aspell], [jq], [texsc], and [texqc] installed.

You may also want to check whether your LaTeX installation has
  all the packages required in the `DEPENDS.txt` file.
If you miss any of them, install, for example, with the help of [tlmgr].

Once compiled and packaged, upload zip archive
to [arXiv](https://arxiv.org/abs/2111.13384).

[phino]: https://github.com/objectionary/phino
[LaTeX]: https://www.latex-project.org/get/
[GNU Aspell]: http://aspell.net/
[jq]: https://stedolan.github.io/jq/
[texsc]: https://rubygems.org/gems/texsc
[texqc]: https://rubygems.org/gems/texqc
[tlmgr]: https://tug.org/texlive/tlmgr.html
[pdf]: https://github.com/objectionary/calculus-paper/blob/gh-pages/paper.pdf
