These are the tools used to create and maintain a *red texts* mirror.

To create an archive, run:

```sh
git clone https://github.com/xatasan/rt-mirror --recursive
make 
```

It is recommended to use more than one job when running `make`, 
to speed the process up. `--recursive` is required to clone the
[text repo](https://github.com/xatasan/rt-texts) as a submodule.

To properly build everything, the following tools will have to be
installed, besides a standard \*NIX userland:
[make](https://www.gnu.org/software/make/),
[pandoc](http://pandoc.org/), [Calibre](http://calibre-ebook.com/),
[LaTeX](https://www.latex-project.org/),
[AWK](https://en.wikipedia.org/wiki/AWK).

---

All code is [in the public domain](./LICENSE).
