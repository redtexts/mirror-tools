.SUFFIXES: .md .html .epub .mobi .pdf
PD_OPT=-s -f markdown-raw_html --data-dir=./res/ --template=./res/default -V NAME="$(M_NAME)" -V WMAST="$(M_WMASTER)"

index.html: keywords.html
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -P 4 -0 awk -f res/md.awk |\
			sort -t'	' -k1,1 -k3,3n -k2,2 |\
			awk -f res/idauth.awk -f res/index.awk -v NAME="$(M_NAME)" -v WMAST="$(M_WMASTER)" > index.html

keywords.html:
	find txt/ -name "*.md" -print0 |\
			xargs -L 1 -P 4 -0 awk -f res/md.awk -v keywords=1 |\
			sort -t'	' -k5,5 -k1,1 -k3,3n -k2,2 |\
			awk -f res/idauth.awk -f res/keywords.awk -v NAME="$(M_NAME)" -v WMAST="$(M_WMASTER)" > keywords.html

.md.html:
	awk -f res/idauth.awk -f res/prehtml.awk $< |\
		pandoc $(PD_OPT) --katex --html-q-tags --css=../style.css -t html5 |\
		awk -f res/idauth.awk -f res/posthtml.awk > $@

.md.epub:
	pandoc $< $(PD_OPT) --mathml --epub-chapter-level=2 -t epub3 -o $@

.epub.mobi:
	ebook-convert $< $@ --pretty-print --enable-heuristics

.md.pdf:
	pandoc $< -V papersize=a4 $(PD_OPT) --pdf-engine=$(PDF_ENG) -o $@
