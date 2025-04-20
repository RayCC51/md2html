#!/bin/bash

# todo
# fix id with whitespace

MOD=$(cat "$1")

# footnote
MOD=$(echo "$MOD" | sed -E '
  s/^\[\^(.*)\]: /[<a class="footnote" id="footnote-\1" href="#fn-\1">\1<\/a>]: /

  s/\[\^([^]]+)\]/<sup><a class="footnote" id="fn-\1" href="#footnote-\1">\1<\/a><\/sup>/g
')

echo "$MOD"
