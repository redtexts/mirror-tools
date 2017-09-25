function idauth(author) {
		gsub(/\s*$/, "", author);
		gsub(/\s+/, "_", author);
		gsub(/\W/, "", author);
		return tolower(author);
}
