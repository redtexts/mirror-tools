#!/bin/sh
# redtexts text linter metascript
# by xat [https://tilde.town/~xat]
# in the public domain, 2020-

find ./txt/ -name "*.md" -type f -print0 | \
    xargs -0 -L1 awk -f ./res/check.awk
