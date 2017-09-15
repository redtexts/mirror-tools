BEGIN {
		print "<!DOCTYPE html>"
		print "<title>redtexts.org mirror</title>"
		print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1.0\" />"
		print "<meta charset=\"utf-8\" />"
		print "<link rel=\"stylesheet\" href=\"./files/redtexts_html.css\">"
		print "<h1><code>www.redtexts.org</code> mirror</h1>"
		print "<p>This site mirrors the fantastic <a href=\"https://www.redtexts.org/\"><em>red texts</em> archive</a>,"
		print "and additionally hosts converted versions of the texts in the <code>.epub</code>, <code>.mobi</code> (Kindle) and <code>.pdf</code> formats."
		print "All praise for collecting and formatting these texts goes to the admin of <em>red texts</em>. Check of his site for more information.</p>"
		print "<table><thead><tr><th>Title</th><th>Date</th><th>Epub</th><th>Kindle</th><th>PDF</th></tr></thead><tbody>"
		la = ""	# last author
		FS = "\t"
}


# $1 Author
# $2 Title
# $3 Date
# $4 Filename

{
		if ($1 != la) 
				print "<tr><th colspan=5>" $1 "</th></tr>"
		la = $1;
		print "<tr>"
		print "<td><a href=\"./html/" $4 ".html\"><em>" $2 "</em></a></td>"
		print "<td><time>" $3 "</time></td>"
		print "<td><a href=\"./epub/" $4 ".epub\">&#x2198;</a></td>"
		print "<td><a href=\"./mobi/" $4 ".mobi\">&#x2198;</a></td>"
		print "<td><a href=\"./pdf/" $4 ".pdf\">&#x2198;</a></td>"
		print "</tr>"
}

END { 
		print "</tbody></table>"
		print "<nav><a href=\"https://github.com/xatasan/Redtexts\">Mirror code source</a></nav>"
} 
