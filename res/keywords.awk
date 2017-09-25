#!/usr/bin/awk -f

BEGIN {
		print "<!DOCTYPE html>"
		print "<title>keywords - redtexts.org mirror</title>"
		print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />"
		print "<meta charset=\"utf-8\" />"
		print "<link rel=\"stylesheet\" href=\"./style.css\">"
		print "<body id=\"keywords\">"
		while ((getline < "./res/header_kw.txt") > 0)
				print;
		FS = "\t"
		print "<table><thead>"
}

@include "./res/idauth.awk"

{
		if (!$5) next; 
		if ($5 != last_keyword) {
				print "<tr><th class=t colspan=5><h2 id=\"" idauth($5) "\"><a href=\"#" idauth($5) "\">" $5 "</a></h2></th></tr>"
				print "<tr><th>Title</th><th>Date</th><th>Epub</th><th>Kindle</th><th>PDF</th></tr></thead><tbody>"
		}
		if ($1 != last_author) 
				print "<tr><th colspan=5><a href=\"./#" idauth($1) "\">" $1 "</a></th></tr>"
		print "<tr>"
		print "<td><a href=\"./html/" $4 ".html\"><em>" $2 "</em></a></td>"
		print "<td><time>" $3 "</time></td>"
		print "<td><a href=\"./epub/" $4 ".epub\">&#x2198;</a></td>"
		print "<td><a href=\"./mobi/" $4 ".mobi\">&#x2198;</a></td>"
		print "<td><a href=\"./pdf/" $4 ".pdf\">&#x2198;</a></td>"
		print "</tr>"

		last_keyword = $5
		last_author = $1
}

END { 
		print "</tbody></table>"
		while ((getline < "./res/footer_kw.txt") > 0)
				print;
		print "<footer><a href=\".\">home</a> | <a href=\"..\">web master</a></footer>"
} 
