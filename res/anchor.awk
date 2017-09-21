BEGIN { hre = "^(<h[1-3] id=\"([a-z0-9-]+)\">)(.+)$" } # header RE
match($0, hre, d) { print d[1] "<a class=\"an\" href=\"#" d[2] "\">&sect;</a>" d[3]; }
$0 !~ hre { print }
