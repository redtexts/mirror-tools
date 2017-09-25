PANDOC_OPT=-S --data-dir=./res/ --template=./res/default
PANDOC_EPUB_OPT=$(PANDOC_OPT) -m --epub-chapter-level=2 -t epub3
PANDOC_HTML_OPT=$(PANDOC_OPT) --katex --css=../style.css -t html5
CALIBRE_MOBI_OPT=--pretty-print --enable-heuristics
PANDOC_PDF_OPT=$(PANDOC_OPT) -V papersize=a4 -V fontsize=12pt -V geometry="margin=1.2in" -V documentclass=article -V mainfont="Utopia" --latex-engine=xelatex -t latex

DIRS=epub mobi html pdf
TEXTS:=$(wildcard txt/*.md)
EPUB=$(TEXTS:txt/%.md=epub/%.epub)
MOBI=$(TEXTS:txt/%.md=mobi/%.mobi)
HTML=$(TEXTS:txt/%.md=html/%.html)
PDF=$(TEXTS:txt/%.md=pdf/%.pdf)

index.html: $(DIRS) $(EPUB) $(MOBI) $(HTML) $(PDF)
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -0 ./res/md.awk |\
			sort -t'	' -k1,1 -k3,3n -k2,2 |\
			./res/index.awk > index.html

$(DIRS):
	mkdir -p $@

epub/%.epub: txt/%.md 
	pandoc $< $(PANDOC_EPUB_OPT) -o $@

mobi/%.mobi: epub/%.epub 
	ebook-convert $< $@ $(CALIBRE_MOBI_OPT)

html/%.html: txt/%.md style.css 
	./res/prehtml.awk $< | pandoc $(PANDOC_HTML_OPT) | ./res/posthtml.awk > $@ 

pdf/%.pdf: txt/%.md
	pandoc $< $(PANDOC_PDF_OPT) -o $@


style.css:
	cp ./res/style.css .

clean:
	rm -rf $(DIRS) index.html style.css

.PHONY: all clean
