#!/bin/bash

# input
MOD=$(cat "$1")

# escape < > &
MOD=$(echo "$MOD" | sed -E '
  s/&/\&amp;/g
  s/</\&lt;/g
  s/>/\&gt;/g
')

# 4 backtick codeblock
MOD=$(echo "$MOD" | sed -E '
  /^````/ {
    N
    s/````(.*)\n```/```\1\n\\`\\`\\`/
  }
  /^```$/ {
    N
    s/```\n````/\\`\\`\\`\n```/
  }
')

# codeblock
# escape markdown symbols temparely
MOD=$(echo "$MOD" | sed -E '
  /^```/ {
    :a
    N
    /```$/!ba
    s/```([a-zA-Z0-9_]+)?\n/<pre><code class="language-\1">\n/
    s/```/<\/code><\/pre>/
    s/ class="language-"//

    s/\\/\\\\/g
    s/\./\\\./g
    s/\|/\\\|/g
    s/#/\\#/g
    s/!/\\!/g
    s/\*/\\\*/g
    s/\+/\\\+/g
    s/-/\\-/g
    s/\(/\\\(/g
    s/\)/\\\)/g
    s/\{/\\\{/g
    s/\}/\\\}/g
    s/\[/\\\[/g
    s/\]/\\\]/g
    s/`/\\`/g
    
    s/~/\\~/g
    s/=/\\=/g
    s/\^/\\^/g
    s/^:/\\:/
    
    s/&lt;/\\</g
    s/&gt;/\\>/g
  }
')

# fixing codeblock for p
MOD=$(echo "$MOD" | sed -E '
  /^<pre>/,/<\/pre>$/ {
    s/^/</
    s/$/>/
  }
')

# html details summary
MOD=$(echo "$MOD" | sed -E '
  s/&lt;(\/?details)&gt;/<\1>/
  s/&lt;(\/?summary)&gt;/<\1>/g
')

# html comment
MOD=$(echo "$MOD" | sed -E '
  s/&lt;(!-- .* --)&gt;/<\1>/
')

# html br
MOD=$(echo "$MOD" | sed -E '
  s/&lt;br ?\/?&gt;/<br>/
')

# blockquote
BLOCKQUOTE() {
  MOD=$(echo "$MOD" | sed -E '
  s/^&gt; ?(.*)/<blockquote>\n\1\n<\/blockquote>/
')

  MOD=$(echo "$MOD" | sed -E '
  /^<\/blockquote>$/ {
    N
    /<\/blockquote>\n<blockquote>/d
  }
')
}

# indented blockquote
while echo "$MOD" | grep -q '^&gt;'; do
  BLOCKQUOTE
done

# h1 ~ h6
MOD=$(echo "$MOD" | sed -E '
  s/^# (.*)$/<h1>\1<\/h1>/
  s/^## (.*)$/<h2>\1<\/h2>/
  s/^### (.*)$/<h3>\1<\/h3>/
  s/^#### (.*)$/<h4>\1<\/h4>/
  s/^##### (.*)$/<h5>\1<\/h5>/
  s/^###### (.*)$/<h6>\1<\/h6>/
')

# heading with id
MOD=$(echo "$MOD" | sed -E '
  s/^<h([1-6])>(.*) ?\{# ?(.*)\}<\/h\1>$/<h\1 id="\3"><a href="#\3">\2 🔗<\/a><\/h\1>/
')

# hr
MOD=$(echo "$MOD" | sed -E '
  s/^[-*_]{3,}$/<hr>/
')

# footnote
MOD=$(echo "$MOD" | sed -E '
  s/^\[\^(.*)\]: /[<a class="footnote" id="footnote-\1" href="#fn-\1">\1<\/a>]: /
  
  s/\[\^([^]]+)\]/<sup><a class="footnote" id="fn-\1" href="#footnote-\1">\1<\/a><\/sup>/g
')

# bold italic code
MOD=$(echo "$MOD" | sed -E '   
  s/(^|[^\\*])\*([^*]*[^\\*])\*([^*]|$)/\1<em>\2<\/em>\3/g
   s/(^|[^\\*])\*\*([^*]*[^\\*])\*\*([^*]|$)/\1<strong>\2<\/strong>\3/g
   s/(^|[^\\])\*\*\*([^*]*[^\\*])\*\*\*/\1<strong><em>\2<\/em><\/strong>/g
  s/(^|[^\\*])\*([^*]*[^\\*])\*([^*]|$)/\1<em>\2<\/em>\3/g
   s/(^|[^\\*])\*\*([^*]*[^\\*])\*\*([^*]|$)/\1<strong>\2<\/strong>\3/g
  
  s/``(.*)``/\\`\1\\`/g
  s/(^|[^\\])`([^`]*[^\\])`/\1<code>\2<\/code>/g
')

# del, mark, sup, sub
MOD=$(echo "$MOD" | sed -E '
  s/~~(.*)~~/<del>\1<\/del>/g
  s/==(.*)==/<mark>\1<\/mark>/g
  s/([^\\]?)\^(.*[^\\])\^/\1<sup>\2<\/sup>/g
  s/([^\\]?)~(.*[^\\])~/\1<sub>\2<\/sub>/g
')

# img, a
MOD=$(echo "$MOD" | sed -E '
  s/!\[(.*)\]\((.*) "(.*)"\)/<figure>\n  <img src="\2" alt="\1" title="\3">\n  <figcaption>\1<\/figcaption>\n<\/figure>/g
  s/!\[(.*)\]\((.*)\)/<figure>\n  <img src="\2" alt="\1">\n  <figcaption>\1<\/figcaption>\n<\/figure>/g

  s/&lt;(.*)&gt;/<a href="\1">\1<\/a>/g
  s/\[(.*)\]\((.*) "(.*)"\)/<a href="\2" title="\3">\1<\/a>/g
  s/\[(.*)\]\((.*)\)/<a href="\2">\1<\/a>/g
')

# ul ol li
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

# checkbox
MOD=$(echo "$MOD" | sed -E '
  s/^<li>\[ \]/<li><input type="checkbox" disabled>/
  s/^<li>\[x\]/<li><input type="checkbox" checked disabled>/
')

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
  /^<table>$/ a\<thead>
  /^<\/table>$/ i\<\/tbody>
')

# td -> th
MOD=$(echo "$MOD" | sed -E '
  /<thead>/,/<\/thead>/s/td>/th>/g
')

# dt
MOD=$(echo "$MOD" | sed -E '
  /^[^:]/ {
    N
    s/^([^:].*)\n(: .*)/<dl>\n    <dt>\1<\/dt>\n<\/dl>\n\2/
  }
')

# dl dd
MOD=$(echo "$MOD" | sed -E '
  s/^: (.*)$/<dl>\n    <dd>\1<\/dd>\n<\/dl>/
')

# clean dl
MOD=$(echo "$MOD" | sed -E '
  /^<\/dl>$/ {
    N
    /<\/dl>\n<dl>/d
  }
')

# clean continuous dl
MOD=$(echo "$MOD" | sed -E '
  /^<\/dl>$/ {
    N
    N
    /<\/dl>\n\n<dl>/d
  }
')

# p
MOD=$(echo "$MOD" | sed -E '
  s/^( *)([^< ].*)$/<p>\1\2<\/p>/
  s/^(.*[^>])$/<p>\1<\/p>/
  
  s/^(<(em|strong|code|del|sup|sub|mark).*)$/<p>\1<\/p>/

  /<p> *<\/p>/d
  s/^<p> {4}+(.*)/<p class="indented">\1/
  s/  <\/p>$/<\/p>\n/
')

# combine continuous p
MOD=$(echo "$MOD" | sed -E '
  /^<p>.*<\/p>$/ {
    :a
    N
    /<\/p>\n<p>/ {
      s/<\/p>\n<p>/\n/
      ba
    }
  }
')

# fixing codeblock for p
MOD=$(echo "$MOD" | sed -E '
  /^<<pre>/,/<\/pre>>$/ {
    s/^<//
    s/>$//
  }
')

# return escape keys
MOD=$(echo "$MOD" | sed -E '
  s/\\\\/\\/g
  s/\\\./\./g
  s/\\\|/\|/g
  s/\\#/#/g
  s/\\!/!/g
  s/\\\*/\*/g
  s/\\\+/\+/g
  s/\\-/-/g
  s/\\\(/\(/g
  s/\\\)/\)/g
  s/\\\{/\{/g
  s/\\\}/\}/g
  s/\\\[/\[/g
  s/\\\]/\]/g
  s/\\`/`/g
  s/\\</\&lt;/g
  s/\\>/\&gt;/g

  s/\\`/`/g
  s/\\~/~/g
  s/\\=/=/g
  s/\\\^/^/g
  s/^\\:/:/
')

# output
echo "$MOD"
