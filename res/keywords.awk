BEGIN {
		has_epub = system("test -d ./epub") == 0
		has_mobi = system("test -d ./mobi") == 0
		has_pdf  = system("test -d ./pdf")  == 0

		print "<!DOCTYPE html>"
		print "<title>keywords - redtexts.org mirror</title>"
		print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />"
		print "<meta charset=\"utf-8\" />"
		print "<link rel=\"stylesheet\" href=\"./style.css\">"
		while ((getline < "./res/header_kw.txt") > 0)
				print;
		print "<table><thead><tr><th>Title</th><th>Date</th>"
		if (has_epub)	print "<th>Epub</th>"
		if (has_mobi)	print "<th>Kindle</th>"
		if (has_pdf)	print "<th>PDF</th>"
		print "</tr></thead><tbody>"
		FS = "\t"
}

{
		if (!$5) next; 
		if ($5 != last_keyword) {
				print "<tr><th class=t colspan=5 id=\"" idauth($5) "\">Texts on <a href=\"#" idauth($5) "\">" $5 "</a></th></tr>"
				print "<tr><th colspan=5>" $1 "</th></tr>"
		}
		if ($1 != last_author) 
				print "<tr><th colspan=5>" $1 "</th></tr>"
		print "<tr>"
		print "<td><a href=\"./html/" $4 ".html\"><em>" $2 "</em></a></td>"
		print "<td><time>" $3 "</time></td>"
		if (has_epub)	print "<td><a href=\"./epub/" $4 ".epub\">&#x2198;</a></td>"
		if (has_mobi)	print "<td><a href=\"./mobi/" $4 ".mobi\">&#x2198;</a></td>"
		if (has_pdf)	print "<td><a href=\"./pdf/" $4 ".pdf\">&#x2198;</a></td>"
		print "</tr>"

		last_keyword = $5
		last_author = $1
}

END { 
		print "</tbody></table>"
		while ((getline < "./res/footer_kw.txt") > 0)
				print;
		print "<footer>"
		print "<a href=\".\">home</a> |"
		print "<a href=\"..\">web master</a></footer>"
		print "</footer>"
} 
