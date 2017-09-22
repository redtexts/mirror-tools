BEGIN { OFS="\t"; }

# read in all multimarkup metadata
/^\w+:\s+.*$/ { 
        data=$2; # collect all data from collumn 2 and beyond
        for(i=3;i<=NF;i++) data=data" "$i;
        md[gensub(/:$/,"","g",$1)]=data; 
}

# output medatada: author, title, date and filename w/o extention
END {
		sub(/^"/, "", md["title"]) # remove preceding quotation marks
		sub(/"$/, "", md["title"]) # remove trailing quotation marks
		gsub(/\\"/, "\"", md["title"]) # unescape quotation marks
		sub(/^.*\//, "", FILENAME) # remove file path
		sub(/\..*$/, "", FILENAME) # remove file extention
		print md["author"], md["title"], md["date"], FILENAME
}
