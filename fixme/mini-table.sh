#!/bin/bash

# todo
# fix alignment

MOD=$(cat "$1")



MOD=$(echo "$MOD" | sed '
  /^|.*|$/ {
    i\<table>
    :a
    $ a\</table>
    n
    /^|.*|$/ ba
    i\</table>
  }
')





echo ""
echo "++++++"
echo ""
echo "$MOD"
