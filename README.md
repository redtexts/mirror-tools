# _redtext_ mirror tools

>These are the tools used to create and maintain a *red texts* mirror.

## Introduction

To create an archive, run:

```sh
git clone https://github.com/redtexts/mirror-tools
cd mirror-tools
./mirror.sh
```

This will guide you through the configuration process, and warn you if
you don't have the right software installed. Your configuration will by
default be stored in a file called `.mconf`. `mirror.sh` doesn't expect
you to edit this by hand, hence only do so if you are absolutely certain
of what you are doing.

The script will only generate output, if something goes wrong or pandoc
generates warning (eg. `<standard input>:6882: a special character is
not allowed in a name`) - one doesn't have to worry about the latter.

If you have a multiprocessor system, you can add options like `-j4` to
let the underlying `make` system know that it can use up to four
threads. Generally speaking, every option given to `mirror.sh` will be
passed on to `make`.

`mirror.sh` also supports automatic synchronisation, if `rsync` or `scp`
is installed.

## Common issues

Make sure that you have a directory named `./txt/` in the root directory
of this repository. This directory **must** contain all the markdown
files, which are to be processed. If no files are found, naturally,
nothing can be done. 

This directory also serves as the "build directory". All `.html`,
`.epub`, `.mobi` and `.pdf` files will first be generated in here, and
afterwards copied or linked (depending on what you decided to choose
while configuring your mirror) into the their respective directories.

## Background

To properly build everything, the following tools will have to be
installed, besides a standard \*NIX userland:

- [make][make]: for coordinating the building of the necessary
  documents
- [pandoc][pandoc] (version 2.0 or greater): to convert from markdown
  to `.epub`, `.html` and `.pdf`
- [Calibre][calibre], or specifically `ebook-convert`: to convert from
  `.epub` to `.mobi`
- [XeTeX/XeLaTeX][xetex]: for proper, quality pdf generation
  **or** [Groff][groff]: for quick and lightweight pdf generation
- [AWK][awk]: for generating `index.html` and `keywords.html` and
  extracting metadata from the markdown files.

At the very least `make`, pandoc and AWK are required. This will let you
generate `.html` and `.epub` files.

## Customisation

To customize your specific mirror, edit the `res/header.txt` and
`res/footer.txt` files to respectivly add HTML markup above and below
the generated text table. If these are not found, no text is inserted
and no error is reported.

If you wish to have a different layout on your mirror, all you have to
do is customise the `style.css` file in the root directory of this
repository (**not** `/res/style.css`).

In case want to change your `mirror.sh` config, either delete the
`.auto` file in your working directory, in case you told `mirror.sh` to
automatically use your configuration.

## Legal

All code is [in the public domain][legal]. Originally written by
[Xatasan][xat], 2017.

[make]: https://en.wikipedia.org/wiki/make_(software)
[pandoc]: https://pandoc.org/
[calibre]: https://calibre-ebook.com/
[xetex]: http://xetex.sourceforge.net/
[groff]: https://gnu.org/software/groff/
[awk]: https://en.wikipedia.org/wiki/AWK
[legal]: ./LICENSE
[xat]: https://sub.god.jp/~xat/
