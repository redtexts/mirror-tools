/^<h[1-3] id=\"[a-z0-9-]+\">.+$/ {
    header=$0
    sub(">.*$", "", header)
    id=$0
    sub("^.*id=\"", "", id)
    sub("\">.*$", "", id)
    rest=$0
    sub("<h[^>]*>", "", rest)
    print header "><a class=\"an\" href=\"#" id "\">&sect;</a> " rest;
    pc = 0
    next
}

/^<p>/ {
    pc++
    link = "<a class=\"an\" href=\"#" id "-p" pc "\">\\&para;</a>"
    sub("^<p>", "<p id=\""id "-p" pc "\">" link)
}

1 # if it doesn't match, just print it

