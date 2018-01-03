PANDOC_OPT=-s -f markdown-raw_html --data-dir=./res/ --template=./res/default
PANDOC_EPUB_OPT=$(PANDOC_OPT) -m --epub-chapter-level=2 -t epub3
PANDOC_HTML_OPT=$(PANDOC_OPT) --katex --css=../style.css -t html5
CALIBRE_MOBI_OPT=--pretty-print --enable-heuristics
PANDOC_XETEX_OPT=$(PANDOC_OPT) -V papersize=a4 -V fontsize=12pt -V geometry="margin=1.2in" -V documentclass=article -V mainfont="Utopia" --latex-engine=xelatex -t latex
PANDOC_MS_OPT=$(PANDOC_OPT) -V papersize=a4 -V fontfamily=N -V hyphenate=1 -t ms

DIRS=epub mobi html pdf
TEXTS:=$(wildcard txt/*.md)
EPUB=$(TEXTS:txt/%.md=epub/%.epub)
MOBI=$(TEXTS:txt/%.md=mobi/%.mobi)
HTML=$(TEXTS:txt/%.md=html/%.html)
PDF=$(TEXTS:txt/%.md=pdf/%.pdf)

index.html: html keywords.html style.css
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -P 4 -0 awk -f res/md.awk |\
			sort -t'	' -k1,1 -k3,3n -k2,2 |\
			awk -f res/idauth.awk -f res/index.awk > index.html

keywords.html:
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -P 4 -0 awk -f res/md.awk -v keywords=1 |\
			sort -t'	' -k5,5 -k1,1 -k3,3n -k2,2 |\
			awk -f res/idauth.awk -f res/keywords.awk > keywords.html

$(DIRS:%=mkdir-%):
	mkdir -p $(patsubst mkdir-%,%,$@)

epub: mkdir-epub $(EPUB) 
	rm -f index.htmk keywords.html
	$(MAKE) index.html
epub/%.epub: txt/%.md 
	pandoc $< $(PANDOC_EPUB_OPT) -o $@

mobi: mkdir-mobi $(MOBI) 
	rm -f index.htmk keywords.html
	$(MAKE) index.html
mobi/%.mobi: epub/%.epub 
	ebook-convert $< $@ $(CALIBRE_MOBI_OPT)

html: mkdir-html $(HTML)
html/%.html: txt/%.md
	awk -f res/idauth.awk -f res/prehtml.awk $< |\
		pandoc $(PANDOC_HTML_OPT) |\
		awk -f res/idauth.awk -f res/posthtml.awk > $@

pdf: mkdir-pdf $(PDF) 
	rm -f index.htmk keywords.html
	$(MAKE) index.html
pdf/%.pdf: txt/%.md
ifdef MS
	pandoc $< $(PANDOC_MS_OPT) -o $@
else
	pandoc $< $(PANDOC_XETEX_OPT) -o $@
endif

all: epub mobi pdf html index.html

style.css:
	cp ./res/style.css .

clean:
	rm -rf $(DIRS) index.html keywords.html style.css

.PHONY: all clean mkdir-epub mkdir-mobi mkdir-html mkdir-pdf 
