PANDOC_OPT=-S -s --data-dir=./src/
PANDOC_EPUB_OPT=$(PANDOC_OPT) --epub-chapter-level=2 -t epub3
PANDOC_HTML_OPT=$(PANDOC_OPT) -t html5
CALIBRE_MOBI_OPT=--pretty-print --enable-heuristics 
CALIBRE_PDF_OPT=$(CALIBRE_MOBI_OPT) --smarten-punctuation --paper-size=a4 --margin-bottom 62 --margin-left 68 --margin-right 68 --margin-top 62 

DIRS=epub mobi html pdf
TEXTS:=$(wildcard txt/*.md)
EPUB=$(TEXTS:txt/%.md=epub/%.epub)
MOBI=$(TEXTS:txt/%.md=mobi/%.mobi)
HTML=$(TEXTS:txt/%.md=html/%.html)
PDF=$(TEXTS:txt/%.md=pdf/%.pdf)

index.html: $(DIRS) $(EPUB) $(MOBI) $(HTML) $(PDF)
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -0 ./src/md.awk |\
			sort -t'	' -k1,1 -k3,3n -k2,2 |\
			./src/index.awk > index.html

$(DIRS):
	mkdir -p $@

epub/%.epub: txt/%.md 
	pandoc $< $(PANDOC_EPUB_OPT) -o $@

mobi/%.mobi: epub/%.epub 
	ebook-convert $< $@ $(CALIBRE_MOBI_OPT)

html/%.html: txt/%.md style.css 
	pandoc $< $(PANDOC_HTML_OPT) -V fname=$(patsubst html/%.html,%,$@) -o $@ 

pdf/%.pdf: epub/%.epub 
	ebook-convert $< $@ $(CALIBRE_PDF_OPT)

style.css:
	cp ./src/style.css .

clean:
	rm -rf epub mobi html index.html style.css pdf 

.PHONY: all clean

