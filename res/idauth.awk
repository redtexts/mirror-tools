function idauth(author) {
		gsub(/\s+/, "-", author);
		gsub(/[^A-Za-z0-9-]/, "", author);
		return tolower(author);
}
