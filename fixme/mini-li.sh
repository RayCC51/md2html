#!/bin/bash

# todo
# other tags in list

# li /li \n li ul -> li ul

MOD=$(cat "$1")

LI() {
MOD=$(echo "$MOD" | sed -E '
  /^[-+*] / {
    i\<ul>
    $ a\<\/ul>
    :a
    n
    $ a\<\/ul>
    /^[-+*] |^ {4}/ ba
    i\<\/ul>
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^[0-9]+\. / {
    i\<ol>
    $ a\<\/ol>
    :a
    n
    $ a\<\/ol>
    /^[0-9]+\. |^ {4}/ ba
    i\<\/ol>
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^<ul>$/,/^<\/ul>$/ {
    s/^[-+*] (.*)$/<li>\1<\/li>/
    s/^ {4}(.*)/<li>\n\1\n<\/li>/
  }
  /^<ol>$/,/^<\/ol>$/ {
    s/^[0-9]+\. (.*)$/<li>\1<\/li>/
    s/^ {4}(.*)/<li>\n\1\n<\/li>/
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^<\/li>$/ {
    N
    /^<\/li>\n<li>$/d
  }
')
}

while echo "$MOD" | grep -qE '^[-+*] |^[0-9]+\. '; do
  LI
done

MOD=$(echo "$MOD" | sed -E '
  /^<[uo]l>$/,/^<\/[uo]l>$/ {
    /<\/li>$/ {
      :a
      N
      /<\/li>$/ ba
      s/<\/li>\n<li>$//
    }
  }
')

echo "$MOD"
