@include "./files/metad.awk"

BEGIN { OFS="\t"; }

END {
		sub(/^.*\//, "", FILENAME)
		sub(/\..*$/, "", FILENAME)
		print md["Author"], md["Title"], md["Date"], FILENAME
}
