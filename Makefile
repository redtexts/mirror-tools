.SUFFIXES: .md .html .epub .mobi .pdf

AWK ?= /usr/bin/awk
FIND ?= /usr/bin/find
SORT ?= /usr/bin/sort
XARGS ?= /usr/bin/xargs
PANDOC ?= /usr/bin/pandoc
CALIBRE ?= /usr/bin/ebook-convert

PD_OPT=-s -f markdown-raw_html --data-dir=./res/ --template=./res/default -V NAME="$(M_NAME)" -V WMAST="$(M_WMASTER)"

index.html: keywords.html
	$(FIND) txt/ -name "*.md" -print0 |\
			$(XARGS) -L 1 -P $$(nproc) -0 $(AWK) -f res/md.awk |\
			$(SORT) -t'	' -k1,1 -k3,3n -k2,2 |\
			$(AWK) -f res/idauth.awk -f res/index.awk -v NAME="$(M_NAME)" -v WMAST="$(M_WMASTER)" > index.html

keywords.html:
	$(FIND) txt/ -name "*.md" -print0 |\
			$(XARGS) -L 1 -P $$(nproc) -0 $(AWK) -f res/md.awk -v keywords=1 |\
			$(SORT) -t'	' -k5,5 -k1,1 -k3,3n -k2,2 |\
			$(AWK) -f res/idauth.awk -f res/keywords.awk -v NAME="$(M_NAME)" -v WMAST="$(M_WMASTER)" > keywords.html

.md.html:
	$(AWK) -f res/idauth.awk -f res/prehtml.awk $< |\
		$(PANDOC) $(PD_OPT) --katex --toc --html-q-tags --css=../style.css -t html5 |\
		$(AWK) -f res/idauth.awk -f res/posthtml.awk > $@

.md.epub:
	$(PANDOC) $< $(PD_OPT) --mathml --epub-chapter-level=2 -t epub3 -o $@

.epub.mobi:
	$(CALIBRE) $< $@ --pretty-print --enable-heuristics

.md.pdf:
	$(PANDOC) $< --toc -V papersize=a4 $(PD_OPT) --pdf-engine=$(PDF_ENG) -o $@
