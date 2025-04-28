#!/bin/bash

# todo
# fix id with whitespace
# long footnote

MOD=$(cat "$1")

# class
#
# section.footnotes
# a.footnote-ref
# a.footnote



# footnote: several lines - not work
# MOD=$(echo "$MOD" | sed -E '
#   /^\[\^[^]]+\]: /{
#     h
#     :f
#     n
#     /^ *$/ {
#       n
#       /^ {4}/ {
#         G
#         s/ {4}(.*)\n(.*)/\2<br>\1/
#         h
#         bf
#       }
#     }
#   }
# ')

# footnote move bottom
MOD=$(echo "$MOD" | sed -E '
  s/\[\^([^]]+)\]($|[^:])/<sup><a class="footnote-ref" id="footnote-ref-\1" href="#footnote-\1">\1<\/a><\/sup>\2/g
  /^\[\^([^]]+)\]: /{
    H
    d
  }
  $ {
    G
    s/\n/\n<section class="footnotes">\n/
    s/\n\[\^([^]]+)\]: /\n<p><a class="footnote" id="footnote-\1" href="#footnote-ref-\1">[\1]<\/a>: /g
    s/\n<p>/<\/p>\n<p>/g
    s/<\/p>\n//
    s/$/<\/p>\n<\/section>/
  }
')

  

echo "$MOD"
