#!/bin/bash


# em, strong
# *, _

MOD=$(cat "$1")


MOD=$(echo "$MOD" | sed -E '

  s/\\\*/\&ast;/g
  s/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g
  s/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g
  s/(^|[^*])\*([^*]+)\*([^*]|$)/\1<em>\2<\/em>\3/g
  s/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g
  s/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g
  s/\&ast;/\\*/g
')

MOD=$(echo "$MOD" | sed -E '

  s/\\_/\&und;/g
  s/___([^_]+)___/<strong><em>\1<\/em><\/strong>/g
  s/__([^_]+)__/<strong>\1<\/strong>/g
  s/(^|[^_])_([^_]+)_([^_]|$)/\1<em>\2<\/em>\3/g
  s/___([^_]+)___/<strong><em>\1<\/em><\/strong>/g
  s/__([^_]+)__/<strong>\1<\/strong>/g
  s/\&und;/\\_/g
')


echo "$MOD"
