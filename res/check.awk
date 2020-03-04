#!/usr/bin/awk -f

BEGINFILE {
    printf("\nCHECKING %s\n", toupper(FILENAME))
}

function err(msg) {
	 printf("err:  %s:%d: %s\n", FILENAME, NR, msg) > "/dev/stderr"
	 errors++
}

function warn(msg) {
	 printf("warn: %s:%d: %s\n", FILENAME, NR, msg) > "/dev/stderr"
	 warnings++
}

# GENERAL CHECKS
/[^[:space:]][[:space:]]{2,}/  { warn("avoid consecutive whitespaces") }
/[[:space:]]+$/ { warn("avoid trailing whitespaces") }

blank && /^[[:space:]]*$/ { warn("avoid double blank lines") }

/[@|*^{}_~]/ && !/\[\^/ && !/\*?[[:alpha:][:space:]-]+\*?/ {
	 warn("avoid unusual charachters")
}

!in_header && length > 74 { warn("lines shoudln't be longer than 72 characters") }

{ blank = /^[[:space:]]*$/ }

# HEADER VALIDATION
!header && /^---$/ { # start header
	 if (NR > 1)
		  warn("header should be placed on the first line")
	 header = 1;
	 in_header = 1;
	 FS = ": "
	 next
}

in_header && $0 == "..." {
	 FS = ""
	 in_header = 0;
}

in_header && /^-/ && (last_key !~ /^(author|keywords):?$/) {
	 warn("avoid using header lists except for \"author\" and \"keywords\"")
	 next
}

in_header && $1 == "date" && $2 !~ /(1[789]|20)[[:digit:]]{2}/ {
	 warn("header either missing or might have a weird date")
}

in_header && ($1 ~ /^(title|description|author)$/) &&
((/"/ || /'/ || NF != 2) && !($2 ~ /^"/ && $2 ~ /"$/)) {
	 err("field \"" $1 "\" not quoted properly")
}

in_header && /[[:space:]]+-/ { warn("don't use whitespaces in header lists") }
in_header && /^[[:space:]]*$/ { err("header shoudln't cointain empty lines") }

in_header && !/^-/ && $1 !~ /^(title|author|date|description|keywords|toc(-depth)?):?$/ {
	 warn("using unknown keyword \"" $1 "\"")
}

in_header && /^([[:space:]]*- \w+|\w: ([^'":]*|".*"))?$/ {
	 warn("unusual header block syntax")
}

!/^-/ && in_header { last_key = $1 }
in_header { next }

# PUNCTUATION CHECKS
/\( / { warn("space after opened parentheses") }
/ \)/ { warn("space before closed parentheses") }

/[[:space:]]:/ { warn("space before colon") }
/[[:space:]];/ { warn("space before semicolon") }
/[[:space:]]\./ { warn("space before full stop") }
/[[:space:]],/ { warn("space before comma") }

!/;$/ && /;[^[:space:][:punct:]]/ { warn("missing space after semicolon") }
!/:$/ && /:[^[:space:][:punct:]]/ { warn("missing space after colon") }
!/,$/ && /[^[:digit:]]?,[^[:space:][:punct:][:digit:]]/ { warn("missing space after comma") }

/[^.]\.{2}[^.]/ { warn("avoid using \"..\"") }
/[^.]\.{4,}[^.]/ { warn("don't use more than three dots for an ellipsis")}

/[„“‘’’‘…―—–·«»]/ { err("don't use unicode punctuation") }
/[​﻿‍‌]/ { err("don't use zero width whitespaces") }

# MARKDOWN
second_line && /^(-+|=+)$/ { err("all headings should use the ATX style"); }

/\^\[/ { warn("avoid using inline footnotes") }

/<[[:alpha:]]*>/ { err("literal HTML code is forbidden") }

# MISC.
{ second_line = first_line; first_line = blank }

ENDFILE {
	 if (FILENAME) {
		  print "\nUNINAME OUTPUT (" FILENAME "):"
		  if (!system("which uniname > /dev/null"))
			   system("uniname -alp " FILENAME " | grep -iv latin")
		  print ""
	 }
}

# FINAL SUMMARY AND CHECKS
END {
	 if (!header)
		  err("no header found! texts MUST contain headers!")
	 if (in_header) {
		  err("header never closed")
	 }

	 if (warnings || errors) print ""
	 if (warnings) print "warnings: " warnings
	 if (errors ) print "errors: " errors
	 exit errors
}
