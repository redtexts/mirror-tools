#!/usr/bin/awk -f

@include "./res/idauth.awk"
BEGIN { FS="\t" }

### AUTHOR ###

# single record field
/^author:\s+\w+/ {
		gsub(/^author: /, "")
		print "author:"
		print "- name: " $0
		print "  link: " idauth($1)
		next
}

# multi record field
/^author:\s*$/ {
		print "author:"
		ir = 1
		next
}
ir && $0 ~ /^\s*-\s+/ {
		gsub(/^\s*-\s+/, "")
		print "- name: " $0
		print "  link: " idauth($1)
		next
}
ir && $0 !~ /^\s*-\s+/ { ir = 0 }

### KEYWORDS ###

# single record field
/^keywords:\s+[\w\s]*\w[\w\s]*/ {
		gsub(/^keywords: /, "")
		print "keywords:"
		print "- word: " $0
		print "  link: " idauth($1)
		next
}

# multi record field
/^keywords:\s*$/ {
		print "keywords:"
		ik = 1
		next
}
ik && $0 ~ /^\s*-\s+/ {
		gsub(/^\s*-\s+/, "")
		print "- word: " $0
		print "  link: " idauth($1)
		next
}
ik && $0 !~ /^\s*-\s+/ { ik = 0; }

# add fname tag before metadata ends
$0 == "..." { print "fname: " gensub(/^.*\/|\..*$/, "", "g", FILENAME) }

# print all other lines regularly
//
