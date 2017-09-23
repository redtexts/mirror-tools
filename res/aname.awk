#!/usr/bin/awk -f

@include "./res/idauth.awk"
BEGIN{FS="\t"}
{print idauth($1)}
