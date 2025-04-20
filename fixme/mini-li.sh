#!/bin/bash

# todo
# fix indented contents
# fix many indented list
# fix ul ol mixed list

MOD=$(cat "$1")

MOD=$(echo "$MOD" | sed -E '
  /^[-+*] / {
    i\<ul>
    :a
    n
    $ a\<\/ul>
    /^[-+*] |^ {4}/ ba
    /^$/ {
      n
      /^[-+*] |^ {4}/ ba
    }
    a\<\/ul>
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^[-+*] / {
    N
    /^[-+*] .*\n *$/ {
      N
      s/^([-+*].*)\n *\n([-+*].*)$/\1\n<\/ul>\n<ul>\n\2/
    }
  }
')


# can not seperate indented-blank-list, list-blank-list

MOD=$(echo "$MOD" | sed -E '
  /^<ul>$/,/^<\/ul>$/ {
    s/^[-+*] (.*)$/<li>\1<\/li>/
  }
')

# find    and do while. replace     to something else. 

echo "$MOD"
