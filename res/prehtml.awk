BEGIN { 
		epub = system("test -d ./epub") == 0
		mobi = system("test -d ./mobi") == 0
		pdf  = system("test -d ./pdf")  == 0
		FS="\t"
}

### AUTHOR ###

# single record field
/^author:[[:space:]]+/ {
		gsub(/^author: /, "")
		print "author:"
		print "- name: " $0
		print "  link: " idauth($1)
		next
}

# multi record field
/^author:[[:space:]]*$/ {
		print "author:"
		ir = 1
		next
}

ir && /^[[:space:]]*-[[:space:]]+/ {
		gsub(/^[[:space:]]*-[[:space:]]+/, "")
		print "- name: " $0
		print "  link: " idauth($1)
		next
}
ir && !/^[[:space:]]*-[[:space:]]+/ { ir = 0 }

### KEYWORDS ###

# single record field
/^keywords:[[:space:]]+([[:alpha:]]|[[:space:]])*[[:alpha:]]([[:alpha:]]|[[:space:]])*/ {
		gsub(/^keywords: /, "")
		print "keywords:"
		print "- word: " $0
		print "  link: " idauth($1)
		next
}

# multi record field
/^keywords:[[:space:]]*$/ {
		print "keywords:"
		ik = 1
		next
}

ik && /^[[:space:]]*-[[:space:]]+/ {
		gsub(/^[[:space:]]*-[[:space:]]+/, "")
		print "- word: " $0
		print "  link: " idauth($1)
		next
}
ik && !/^[[:space:]]*-[[:space:]]+/ { ik = 0 }

# add fname tag before metadata ends
$0 == "..." { 
		if (epub || mobi || pdf) {
		                gsub(/^.*\/|\..*$/, "", FILENAME)
				print "fname: " FILENAME
				if (epub) print "fname-epub: 1"
				if (mobi) print "fname-mobi: 1"
				if (pdf) print "fname-pdf: 1"
		}
}

1 # print all other lines regularly
