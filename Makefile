REDTEXTS_TGZ=https://www.redtexts.org/files/texts.tgz
PANDOC_EPUB_OPT=-S -f markdown --template=./files/redtexts_epub.template --epub-chapter-level=2 -t epub
PANDOC_HTML_OPT=-S -s -f markdown --css=../style.css --template=./files/redtexts_html.template --html-q-tags -f markdown -t html5
CALIBRE_PDF_OPT=--pretty-print --enable-heuristics --smarten-punctuation --paper-size=a4  --margin-bottom 62 --margin-left 68 --margin-right 68  --margin-top 62 --pdf-page-numbers

DIRS=epub mobi html pdf
TEXTS:=$(wildcard texts/*.txt)
EPUB=$(TEXTS:texts/%.txt=epub/%.epub)
MOBI=$(TEXTS:texts/%.txt=mobi/%.mobi)
HTML=$(TEXTS:texts/%.txt=html/%.html)
PDF=$(TEXTS:texts/%.txt=pdf/%.pdf)

.PHONY: all clean

all: index.html

texts:
	mkdir texts
	wget -q -O - $(REDTEXTS_TGZ) | tar xzvf - -C texts
	@echo run "make" again, to generate the site

$(DIRS):
	mkdir -p $@

epub/%.epub: texts/%.txt epub
	awk -f ./files/redtexts.awk -v css=redtexts_epub.css $< |\
			pandoc $(PANDOC_EPUB_OPT) -o $@

mobi/%.mobi: epub/%.epub mobi
	ebook-convert $< $@ --pretty-print --enable-heuristics

html/%.html: texts/%.txt style.css html
	awk -f ./files/redtexts.awk $< |\
			pandoc $(PANDOC_HTML_OPT) -V fname=$(patsubst html/%.html,%,$@) -o $@

pdf/%.pdf: epub/%.epub pdf
	ebook-convert $< $@ $(CALIBRE_PDF_OPT)

style.css:
	cp ./files/redtexts_html.css ./style.css

index.html: texts $(EPUB) $(MOBI) $(HTML) $(PDF)
	find texts/ -type f -print0 |\
			xargs -L 1 -0 awk -f files/printmd.awk |\
			sort -t'	' -k1,1 -k3,3n -k2,2 |\
			awk -f files/index.awk > index.html

clean:
	rm -rf epub mobi html style.css index.html pdf texts
