BEGIN {
		has_epub = system("test -d ./epub") == 0
		has_mobi = system("test -d ./mobi") == 0
		has_pdf  = system("test -d ./pdf")  == 0

		print "<!DOCTYPE html>"
		print "<title>keywords - redtexts.org mirror " NAME "</title>"
		print "<meta name=\"viewport\" content=\"width=device-width\" />"
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
		else if ($1 != last_author)
				print "<tr><th colspan=5>" $1 "</th></tr>"
		print "<tr>"
		print "<td><a href=\"./html/" $4 ".html\"><em>" $2 "</em></a></td>"
		print "<td><time>" $3 "</time></td>"
}

has_epub {
	print system("test -f ./epub/" $4 ".epub") == 0 ?
		"<td><a href=\"./epub/" $4 ".epub\">&#x2198;</a></td>" :
		"<td>&#x2297;</td>"
}

has_mobi {
	print system("test -f ./mobi/" $4 ".mobi") == 0 ?
		"<td><a href=\"./mobi/" $4 ".mobi\">&#x2198;</a></td>" :
		"<td>&#x2297;</td>"
}

has_pdf {
	print system("test -f ./pdf/" $4 ".pdf") == 0 ?
		"<td><a href=\"./pdf/" $4 ".pdf\">&#x2198;</a></td>" :
		"<td>&#x2297;</td>"
}

{
		print "</tr>"
		last_keyword = $5
		last_author = $1
}

END { 
		print "</tbody></table>"
		while ((getline < "./res/footer_kw.txt") > 0)
				print;
		print "<footer>"
		print "<a href=\".\">home</a>"
		if (WMAST)
			print "| <a href=\"" WMAST "\">web master</a>"
		print "</footer>"
} 
