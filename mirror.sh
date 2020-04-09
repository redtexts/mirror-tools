#!/bin/sh
# redtexts "mirror tool" makescript
# by xat [https://tilde.town/~xat]
# in the public domain, 2018-

# colours
bold="$(tput bold)"
red="$(tput setaf 1)"
reset="$(tput sgr0)"
export bold red reset

# constants and defaults
KINDLEGEN_CMD='touch book-$$$$.mobi && kindlegen $< -c1 -locale en -o book-$$$$.mobi; [ $$? -lt 2 ] && mv book-$$$$.mobi $@'
CALIBRE_CMD="ebook-convert $< $@ --pretty-print --enable-heuristics"
MCONF="./.mconf"
AUTO="./.auto"
D_TXT="./txt/"
D_HTML="./html/"
D_EPUB="./epub/"
D_MOBI="./mobi/"
D_PDF="./pdf/"
GIT_TXT="https://github.com/redtexts/texts"

# variables
MAKEOPTS="-s -k"

which nproc 2>&1 >/dev/null && {
	MAKEOPTS="$MAKEOPTS -j $(nproc)"
}

# functions
errcho() {
	echo "${bold}${red}ERROR:${reset} $*" 1>&2
	exit 1
}

_runconf() {
	[ -e $MCONF ] && mv $MCONF $MCONF.$(date -"%D-%H")
	rm -f  $AUTO
	echo "# please do not edit by hand" > $MCONF

	printf "Mirror name: "
	read -r NAME
	echo "M_NAME=\"$NAME\"" >> $MCONF

	printf "Webmaster URL (leave empty for no webmaster): "
	read -r WMASTER
	[ "$WMASTER" ] && echo "M_WMASTER=\"$WMASTER\"" >> $MCONF

	printf "Remote destination (optional): "
	read -r REMOTE
	[ "$REMOTE" ] && {
		echo "M_REMOTE=\"$REMOTE\"" >> $MCONF

		printf "Automatically synchronise [Y/n]? "
		read -r AUTOSYNC
		echo "$AUTOSYNC" | grep -vi "^n" 2>&1 >/dev/null &&\
			echo "O_AUTOSYNC=1" >> $MCONF
	}

	printf "Copy instead of linking generated files [Y/n]? "
	read -r COPY
	if echo "$COPY" | grep -vi "^n"; then
		echo "C_COPY=\"cp\"" >> $MCONF
	else
		echo "C_COPY=\"ln -srf\"" >> $MCONF
	fi

	printf "Generate EPUB files [Y/n]? "
	read -r GEN_E
	echo "$GEN_E" | grep -vi "^n" 2>&1 >/dev/null && {
		echo 'G_EPUB=1' >> $MCONF

		which ebook-convert 2>&1 >/dev/null && {
			# mobi files can only be generated if epub files are generated AND
			# `ebook-convert` is installed
			printf "Generate MOBI (Kindle) files [Y/n]? "
			read -r GEN_M
			echo "$GEN_M" | grep -vi "^n" 2>&1 >/dev/null &&\
				echo 'G_MOBI=1' >> $MCONF
		}

		which kindlegen 2>&1 >/dev/null && {
			# mobi files can only be generated if epub files are generated AND
			# `kindlegen` is installed
			printf "Generate MOBI (Kindle) files [Y/n]? "
			read -r GEN_M
			echo "$GEN_M" | grep -vi "^n" 2>&1 >/dev/null &&\
				echo 'G_MOBI=1' >> $MCONF &&\
				echo 'O_MOBI="kg"' >> $MCONF
		}
	}

	printf "Generate PDF files [Y/n]? "
	read -r GEN_P
	echo "$GEN_P" | grep -vi "^n" 2>&1 >/dev/null &&{
		echo 'G_PDF=1' >> $MCONF

		printf "Use Groff (-ms) to generate the PDFs [Y/n]? "
		read -r USE_G
		echo "$USE_G" | grep -vi "^n" 2>&1 >/dev/null && {
			echo 'O_MS=1' >> $MCONF
		}
	}

	printf "Autorun this configuration from now on [y/N]? "
	read -r AUTOR
	echo "$AUTOR" | grep -vi "^n" 2>&1 >/dev/null && touch $AUTO

	printf "Auto-update texts repository [y/N]? "
	read -r AUTOU
	echo "$AUTOU" | grep -vi "^n" 2>&1 > /dev/null && echo "M_UPDATE=1" >> $MCONF
}

_getfiles() {
	find $D_TXT -name "*.md" -type f |\
		sed "s%\\.md$%$1%;s%$% %g"
}

# test if all necessary binaries are available
which make 2>&1 >/dev/null || errcho "\"make\" not installed!"
which pandoc 2>&1 >/dev/null || errcho "\"pandoc\" not installed!"
pandoc -v | awk 'NR == 1 { exit $2 < 2 }' ||\
	errcho "\"pandoc\" has to be at least be version 2.0 or higher!"
which awk 2>&1 >/dev/null || errcho "\"awk\" not installed!"

# start setup (ensure $MCONF exists and then load it)
# echo "${bold}::: mirror.sh - create, maintain and update a redtexts mirror${reset}"
if [ ! -e $AUTO ]; then
	if [ -e $MCONF ]; then
		printf "Previous configuration file found, do you want to use it again [Y/n]? "
		read -r PCONF
		echo "$PCONF" | grep -vi "^n" 2>/dev/null >&1 && _runconf
	else
		_runconf
	fi
fi
. $MCONF

if [ ! -d "$D_TXT" ]; then
    git clone "$GIT_TXT" "$D_TXT" 2>/dev/null
elif [ $M_UPDATE ]; then
    cd $D_TXT
    git pull 2>/dev/null || errcho "Failed to automatically update texts directory!"
    cd ..
fi

# check if variables were properly loaded
[ "$C_COPY" ] || [ "$M_NAME" ] || errcho "there was an error in \"$MCONF\". Some necessary variables weren't specified"

# construct argument list for make
FILES="$(_getfiles .html)"

[ $G_MOBI ] && FILES="$(_getfiles .mobi) $FILES"
[ $G_EPUB ] && FILES="$(_getfiles .epub) $FILES"
if [ $G_PDF ]; then
	FILES="$(_getfiles .pdf) $FILES"
	if [ $O_MS ]; then
		PDF_ENG="pdfroff"
	else
		PDF_ENG="xelatex"
	fi
fi

# prepare and run make
mkdir -p $D_HTML
[ $G_EPUB ] && mkdir -p $D_EPUB
[ $G_MOBI ] && mkdir -p $D_MOBI
[ $G_PDF ] && mkdir -p $D_PDF

# create files
make $MAKEOPTS M_NAME="$M_NAME" M_WMASTER="$M_WMASTER"\
	 PDF_ENG="$PDF_ENG" $FILES || exit 1

# copy or link files from build dir to intended location
for d in $D_TXT/*.html; do
	$C_COPY "$PWD/$d" "$D_HTML"
done

if [ $G_EPUB ]; then
	for d in $D_TXT/*.epub; do
		$C_COPY "$PWD/$d" "$D_EPUB"
	done
fi

if [ $G_MOBI ]; then
	for d in $D_TXT/*.mobi; do
		$C_COPY "$PWD/$d" "$D_MOBI"
	done

	if [ "$O_MOBI" = "kg" ]; then
		sed -i '/^.epub.mobi$/,+1c .epub.mobi\n\t$KINDLEGEN_CMD' Makefile
	else
		sed -i '/^.epub.mobi$/,+1c .epub.mobi\n\t$CALIBRE_CMD' Makefile
	fi
fi

if [ $G_PDF ]; then
	for d in $D_TXT/*.pdf; do
		$C_COPY "$PWD/$d" "$D_PDF"
	done
fi

# create (and update) {index,keywords}.html
make $MAKEOPTS -B M_NAME="$M_NAME" M_WMASTER="$M_WMASTER"\
	 keywords.html index.html || exit 2

# automatically synchronise if
if [ $O_AUTOSYNC ]; then
	SYNC="index.html keywords.html style.css html"
	[ $G_MOBI ] && SYNC="$SYNC mobi"
	[ $G_EPUB ] && SYNC="$SYNC epub"
	[ $G_PDF ] && SYNC="$SYNC pdf"

	if which rsync 2>/dev/null >/dev/null; then
		rsync -auvc $SYNC $M_REMOTE
	elif which scp 2>/dev/null >/dev/null; then
		scp -Crp $SYNC $M_REMOTE
	else
		sed -i '/O_AUTOSYNC/d'
		errcho "Couldn't automatically sync. Option removed."
	fi
fi
