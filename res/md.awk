#!/usr/bin/awk -f
# YAML parser for pandoc markdown

BEGIN {  
		OFS="\t";
		nr = 1; # new record?
		cr = ""; # current record 
		ri = 0; # record index
}

# add field to current multi-value field
!nr && /^\s*-\s+.*/ {
		md[cr][ri++] = gensub(/^\s+*-\s+|\s*$/, "", "g")
}

# finish parsing multi-value field
!nr && $0 !~ /^\s*-\s+.*/ {
		nr = 1;
}

# add single-value field to metadata
nr && /^\w+:\s+.*$/ { 
		md[gensub(/:$/, "", "g", $1)][0] = gensub(/^\w+:\s+/, "", "g"); 
}

# start parsing multi-value field
nr && /^\w+:\s*$/ {
		nr = 0;
		cr = gensub(/:$/, "", "g", $1);
		ri = 0;
}

# finish parsing after YAML data ends
$0 == "..." { exit }

# output medatada: author, title, date and filename w/o extention
END {
		sub(/^"/, "", md["title"][0]) # remove preceding quotation marks
		sub(/"$/, "", md["title"][0]) # remove trailing quotation marks
		gsub(/\\"/, "\"", md["title"][0]) # unescape quotation marks
		sub(/^.*\//, "", FILENAME) # remove file path
		sub(/\..*$/, "", FILENAME) # remove file extention

		# output once for every author
		for (i in md["author"])
				print md["author"][i], md["title"][0], md["date"][0], FILENAME
}
