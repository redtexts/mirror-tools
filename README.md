These are the tools used to create and maintain a *red texts* mirror.

To create an archive, run:

```sh
git clone https://github.com/redtexts/mirror-tools --recursive
make 
```

This will only build the `.html` files. To also build `.epub`, `.mobi`
and `.pdf` files, run `make epub`, `make mobi` and `make pdf`
respectivly. To intentionally (re-)build everything, run `make all`.
If you prefer to use groff/`pdfroff` to generate the PDFs, add `MS=1`
to the `make` argument list. To turn on branding (ie. adding a
reference to <redtexts.org>), add `BRAND=1` as an argument when
running `make`.

To properly build everything, the following tools will have to be
installed, besides a standard \*NIX userland:

- [make](make): for coordinating the building of the necessary
  documents (currently GNU's version **is required**, but this will be
  changed in the future, so that any POSIX compliant `make`
  implementation can build the archive.)
- [pandoc][pandoc]: to convert from markdown to `.epub`, `.html` and
  `.pdf`
- [Calibre][calibre], or specifically `ebook-convert`: to convert from
  `.epub` to `.mobi`
- [XeTeX/XeLaTeX][xetex]: for proper, quality pdf generation
  **or** [Groff][groff]: for proper, lightweight pdf generation
- [AWK][awk]: for generating `index.html` and `keywords.html` and
  extracting metadata from the markdown files. **Note:** [mawk][mawk]
  is (sadly) not supported, due to a bug in `res/md.awk`.

At the very least make, pandoc (or any other markdown converter that
can understand the used pandoc extentions) and AWK are required. This
will let you generate `.html` and `.epub` files. 

To customize your specific mirror, edit the `res/header.txt` and
`res/footer.txt` files to respectivly add HTML markup above and below
the generated text table.  If these are not found, no text is inserted
and no error is reported.

---

All code is [in the public domain][legal]. Originally written by
[Xatasan][xat], 2017.

[make]: https://www.gnu.org/software/make/
[pandoc]: https://pandoc.org/
[calibre]: https://calibre-ebook.com/
[xetex]: http://xetex.sourceforge.net/
[groff]: https://gnu.org/software/groff/
[awk]: https://en.wikipedia.org/wiki/AWK
[mawk]: http://invisible-island.net/mawk/
[legal]: ./LICENSE
[xat]: https://sub.god.jp/~xat/
