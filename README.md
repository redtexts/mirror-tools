These are the tools used to create and maintain a *red texts* mirror.

To create an archive, run:
```sh
git clone https://github.com/xatasan/rt-mirror --recursive
make 
```

It is possible and recommended to use more than one job (eg. `make -j 4`) when running `make`, to speed the process up.
`--recursive` is required to clone the [text repo](https://github.com/xatasan/rt-texts) as a submodule. Updating the submodule can be done by `git submodule update --remove --merge` in the root directory of this repository. Running `make` again, will only update the changed files.
The resulting files should totally take up ~30MiB (status: 20/9/17).

To properly build everything, the following tools will have to be installed, besides a standard \*NIX userland:
- [make](https://www.gnu.org/software/make/): for coordinating the building of the necessary documents
- [pandoc](http://pandoc.org/): to convert from markdown to .epub, .html and .pdf
- [Calibre](http://calibre-ebook.com/), or specifically `ebook-convert`: to convert from .epub
- [XeTeX](http://xetex.sourceforge.net/)/XeLaTeX: for proper, quality pdf generation
- [AWK](https://en.wikipedia.org/wiki/AWK): to generate the `index.html` and extract metadata from .md files

---

All code is [in the public domain](./LICENSE). Originally written by [Xatasan](https://sub.god.jp/~xat/), 2017.
