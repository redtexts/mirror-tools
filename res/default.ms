.ds { \v'-0.3m'\\s[\\n[.s]*9u/12u]
.ds } \s0\v'0.3m'
.ds < \v'0.3m'\s[\\n[.s]*9u/12u]
.ds > \s0\v'-0.3m'
.de HLINE
.LP
.ce
\l'20'
..
.nr LL 5.5i
.nr PO 1.25i
.nr HM 1.25i
.nr FM 1.25i
.nr LT \n[LL]
.nr PS $if(pointsize)$$pointsize$$else$10p$endif$
.nr VS $if(lineheight)$$lineheight$$else$12p$endif$
.fam $if(fontfamily)$$fontfamily$$else$T$endif$
.nr PI $if(indent)$$indent$$else$2m$endif$
.nr PD 0.33v
.nr FL \n[LL]
.nr FPS (\n[PS] - 2000)
.defcolor strikecolor rgb 0.7 0.7 0.7
.ds PDFHREF.COLOUR   0.99 0.24 0.24
.ds PDFHREF.BORDER   0 0 0
$if(papersize)$
.ds paper $papersize$
$endif$
.nr PSINCR 1p
.nr GROWPS 2
.als SN SN-NO-DOT
.als SN-STYLE SN-NO-DOT
.nr PDFOUTLINE.FOLDLEVEL 3
.pdfview /PageMode /UseOutlines
.pdfinfo /Title "$title-meta$"
.pdfinfo /Author "$author-meta$"
$if(adjusting)$
.ad $adjusting$
$endif$
$if(hyphenate)$
.hy
$else$
.nh
$endif$
$if(has-inline-math)$
.EQ
delim @@
.EN
$endif$
$if(title)$
.TL
$title$
$endif$
$for(author)$
.AU
$author$
$endfor$
Date: $date$
$if(date)$
.ND "$date$"
$endif$
$if(description)$
.AB no
$description$
.AE
$endif$
.1C
$body$
$if(toc)$
.TC
$endif$
.pdfsync