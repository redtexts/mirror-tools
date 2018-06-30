# YAML parser for pandoc markdown

BEGIN {
    D = "\036"
    nr = 0
}

# add field to current multi-value field
nr && /^[ \t]*-[ \t]+/ {
    val = $0
    gsub(/^[ \t]*-[ \t]+/, "", val)
    gsub(/[ \t]*$/, "", val)
    if (cd in md) md[cr] = md[cr] D val;
    else md[cr] = val;
}

# finish parsing multi-value field
nr && /^[[:alnum:]]+:/ { nr = 0 }

# add single-value field to metadata
!nr && /^[a-zA-Z0-9]+:[ \t]+/ {
    val = $0
    gsub(/^[a-zA-Z0-9]+:[ \t]+/, "", val)
    gsub(/:$/, "", $1)
    md[$1] = val
}

# start parsing multi-value field
!nr && /^[a-zA-Z0-9]+:[ \t]*$/ {
    nr = 1
    cr = $1
    gsub(/:$/, "", cr)
}

# output medatada: author, title, date and filename w/o extention
$0 == "..." {
    sub(/^"/, "", md["title"]) # remove preceding quotation marks
    sub(/"$/, "", md["title"]) # remove trailing quotation marks
    gsub(/\\"/, "\"", md["title"]) # un-escape quotation marks
    sub(/^.*\//, "", FILENAME) # remove file path
    sub(/\.[[:alnum:]]*$/, "", FILENAME) # remove file extention

    OFS="\t";
    if (keywords == 1 && "keywords" in md) {
	split(md["keywords"], kw, D)
	split(md["author"], au, D)
	for (i in kw) # for each keyword...
	    for (j in au) # ... and each author print a row
		print au[j], md["title"], md["date"], FILENAME, kw[i];
    } else { # if no keywords...
	split(md["author"], au, D)
	for (i in au) # ... print a row for each author
	    print au[i], md["title"], md["date"], FILENAME;
    }
    exit
}
