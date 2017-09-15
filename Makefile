AWK_SCRIPT=./files/redtexts.awk
PANDOC_EPUB_OPT=-S -f markdown --template=./files/redtexts_epub.template --epub-chapter-level=2 -t epub
PANDOC_HTML_OPT=-S -s -f markdown --css=../files/redtexts_html.css --template=./files/redtexts_html.template --html-q-tags -f markdown -t html5 

TEXTS=$(wildcard texts/*.txt)
EPUB=$(TEXTS:texts/%.txt=epub/%.epub)
MOBI=$(TEXTS:texts/%.txt=mobi/%.mobi)
HTML=$(TEXTS:texts/%.txt=html/%.html)
PDF=$(TEXTS:texts/%.txt=pdf/%.pdf)

.PHONY: all clean setup epub clean-epub mobi clean-mobi html clean-html pdf clean-pdf index 
.DEFAULT: index.html

all: index.html

setup:
	mkdir -p epub mobi html pdf 

texts: 
	mkdir texts
	wget -q -O - https://www.redtexts.org/files/texts.tgz | tar xzvf - -C texts

epub/%.epub: texts/%.txt
	awk -f $(AWK_SCRIPT) -v css=redtexts_epub.css $< |\
			pandoc $(PANDOC_EPUB_OPT) -o $@

mobi/%.mobi: epub/%.epub
	ebook-convert $< $@ --pretty-print --enable-heuristics

html/%.html: texts/%.txt 
	awk -f $(AWK_SCRIPT) $< |\
			pandoc $(PANDOC_HTML_OPT) -o $@

pdf/%.pdf: epub/%.epub
	ebook-convert $< $@ --pretty-print --enable-heuristics --smarten-punctuation --paper-size=a4  --margin-bottom 62 --margin-left 68 --margin-right 68  --margin-top 62 --pdf-page-numbers
	mutool clean -gg -s -l $@
	mv out.pdf $@

epub: setup $(EPUB)
mobi: setup epub $(MOBI)
html: setup $(HTML)
pdf: setup epub $(PDF)

index.html: texts epub mobi html pdf
	find texts/ -type f -print0 |\
			xargs -L 1 -0 awk -f files/printmd.awk |\
			sort |\
			awk -f files/index.awk > index.html

clean: clean-epub clean-mobi clean-html clean-pdf clean-texts
clean-epub:
	rm -rf epub
clean-mobi:
	rm -rf mobi
clean-html:
	rm -rf html
clean-pdf:
	rm -rf pdf
clean-texts:
	rm -rf texts
