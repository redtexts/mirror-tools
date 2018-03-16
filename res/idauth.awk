function idauth(author) {
		gsub(/ *$/, "", author);
		gsub(/ +/, "_", author);
		gsub(/[^a-zA-Z_]/, "", author);
		return tolower(author);
}
