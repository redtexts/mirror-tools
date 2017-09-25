#!/usr/bin/awk -f

@include "./res/idauth.awk"
BEGIN{FS="\t"}

# single record field
/^author:\s+\w+/{
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
ir && $0 !~ /^\s*-\s+/ { 
		ir = 0
		next
}

# add fname tag before metadata ends
$0 == "..." {print "fname: " gensub(/^.*\/|\..*$/, "", "g", FILENAME)}

# print all other lines regularly
//
