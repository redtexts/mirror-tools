BEGIN {
		print "<!DOCTYPE html>"
		print "<title>redtexts.org mirror</title>"
		print "<meta name=\"viewport\" content=\"width=device-width, initial-scale=0.9\" />"
		print "<meta charset=\"utf-8\" />"
		print "<link rel=\"stylesheet\" href=\"./style.css\">"
		while ((getline < "./res/index.txt") > 0)
				print;
		print "<table><thead><tr><th>Title</th><th>Date</th><th>Epub</th><th>Kindle</th><th>PDF</th></tr></thead><tbody>"
		FS = "\t"
}

@include "./res/idauth.awk"

{
		if ($1 != la) 
				print "<tr><th colspan=5 id=\"" idauth($1) "\"><a href=\"#" idauth($1) "\">" $1 "</a></th></tr>"
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
		print "<footer><a href=\"https://github.com/xatasan/rt-mirror\">mirror tools</a> | <a href=\"..\">web master</a></footer>"
} 
