#!/bin/bash

# todo
# fix alignment

MOD=$(cat "$1")

# table tr
MOD=$(echo "$MOD" | sed -E '
  /^\|(.*\|)+$/ {
    s/^/<table>\n<tr>/
    s/$/<\/tr>\n<\/table>/
  }
')

# clean duplicated table
MOD=$(echo "$MOD" | sed -E '
  /^<\/table>$/ {
    N
    /^<\/table>\n<table>$/d
  }
')

# colgroup
MOD=$(echo "$MOD" | sed -E '
  /^<tr>[|:-]+<\/tr>$/ {
    h
    G
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^<table>$/ {
    n
    h
    n
    G
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^<table>$/ {
    n
    d
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^<table>$/ {
    n
    s/<\/?tr>//g
    s/^\|/<colgroup>\n    <col>/
    s/\|$/\n<\/colgroup>/
  }
')

MOD=$(echo "$MOD" | sed -E '
  /^    <col>/ {
    s/\|/\n    <col>/g
  }
')

MOD=$(echo "$MOD" | sed -E '
  s/^    <col>-+$/    <col>/
  s/^    <col>:-+$/    <col style="text-align: left;">/
  s/^    <col>-+:$/    <col style="text-align: right;">/
  s/^    <col>:-+:$/    <col style="text-align: center;">/
')

# thead tbody seperator
MOD=$(echo "$MOD" | sed -E '
  /^<table>$/,/^<\/table>$/ {
    s/^<tr>[|:-]+<\/tr>$/<\/thead>\n<tbody>/
  }
')

# td
MOD=$(echo "$MOD" | sed -E '
  /^<tr>/ {
    s/^<tr>\|/<tr>\n    <td>/
    s/\|<\/tr>$/<\/td>\n<\/tr>/
    s/\|/<\/td>\n    <td>/g
  }
')

# thead tbody
MOD=$(echo "$MOD" | sed -E '
  /^<\/colgroup>$/ a\<thead>
  /^<\/table>$/ i\<\/tbody>
')

# td -> th
MOD=$(echo "$MOD" | sed -E '
  /<thead>/,/<\/thead>/s/td>/th>/g
')

echo "$MOD"
