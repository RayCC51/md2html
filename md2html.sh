#!/bin/bash

# input
MOD=$(cat "$1")

# 4 backtick codeblock
MOD=$(echo "$MOD" | sed -E '
  /^````/ {
    N
    s/````(.*)\n```/```\1\n\&backtick;\&backtick;\&backtick;/
  }
  /^```$/ {
    N
    s/```\n````/\&backtick;\&backtick;\&backtick;\n```/
  }
')

# codeblock
MOD=$(echo "$MOD" | sed -E '
  /^```/ {
    :a
    N
    /```$/!ba
    
    s/</\&lt;/g
    s/>/\&gt;/g
    
    s/```([a-zA-Z0-9_]+)?\n/<pre><code class="language-\1">\n/
    s/```/<\/code><\/pre>/
    s/(<pre><code) class="language-">/\1>/

    s/`/\\`/g
  }
')

# inline code
MOD=$(echo "$MOD" | sed -E '
  s/\\`/\&backtick;/g

  /``(.*)``/ {
    s/`/\&backtick;/g
    s/\&backtick;\&backtick;/`/g
  }

  /`[^`]+`/ {
    s/</\&lt;/g
    s/>/\&gt;/g

    s/`([^`]+)`/<code>\1<\/code>/g
  }
')

# escaping in code
MOD=$(echo "$MOD" | sed -E '
  /<code/, /<\/code>/ {
    s/\\/\\\\/g
    s/\./\\\./g
    s/\|/\\\|/g
    s/#/\\#/g
    s/!/\\!/g
    s/\*/\\\*/g
    s/-/\\-/g
    s/_/\\_/g
    
    s/\(/\\\(/g
    s/\)/\\\)/g
    s/\{/\\\{/g
    s/\}/\\\}/g
    s/\[/\\\[/g
    s/\]/\\\]/g

    s/\+/\&plus;/g
    s/~/\&tilde;/g
    s/=/\&equal;/g
    s/\^/\&caret;/g
    s/^:/\&colon;/
  }
')

# fixing codeblock for p
MOD=$(echo "$MOD" | sed -E '
  /^<pre>/,/<\/pre>$/ {
    s/^/</
    s/$/>/
  }
')

# escaping
MOD=$(echo "$MOD" | sed -E '
  s/\\\\/\&backslash;/g
  s/\\\*/\&asterisk;/g
  s/\\\./\&dot;/g
  s/\\\|/\&pipe;/g
  s/\\\+/\&plus;/g

  s/\\`/\&backtick;/g
  s/\\_/\&undnerscore;/g
  s/\\#/\&sharp;/g
  s/\\-/\&hyphen;/g
  s/\\!/\&exclamation;/g

  s/\\\{/\&curlyleft;/g
  s/\\\}/\&curlyright;/g
  s/\\\[/\&squareleft;/g
  s/\\\]/\&squareright;/g
  s/\\\(/\&roundleft;/g
  s/\\\)/\&roundright;/g

  s/\\</\&lt;/g
  s/\\>/\&gt;/g
')

# blockquote
BLOCKQUOTE() {
  MOD=$(echo "$MOD" | sed -E '
  s/^> ?(.*)/<blockquote>\n\1\n<\/blockquote>/
')

  MOD=$(echo "$MOD" | sed -E '
  /^<\/blockquote>$/ {
    N
    /<\/blockquote>\n<blockquote>/d
  }
')
}

# indented blockquote
while echo "$MOD" | grep -q '^>'; do
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
  s/^<h([1-6])>(.*) ?\{# ?(.*)\}<\/h\1>$/<h\1 id="\3">\2<a href="#\3"> 🔗<\/a><\/h\1>/
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
  s/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g
  s/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g
  s/(^|[^*])\*([^*]+)\*([^*]|$)/\1<em>\2<\/em>\3/g
  s/\*\*\*([^*]+)\*\*\*/<strong><em>\1<\/em><\/strong>/g
  s/\*\*([^*]+)\*\*/<strong>\1<\/strong>/g

  s/___([^_]+)___/<strong><em>\1<\/em><\/strong>/g
  s/__([^_]+)__/<strong>\1<\/strong>/g
  s/(^|[^_])_([^_]+)_([^_]|$)/\1<em>\2<\/em>\3/g
  s/___([^_]+)___/<strong><em>\1<\/em><\/strong>/g
  s/__([^_]+)__/<strong>\1<\/strong>/g

  s/``(.*)``/\&backtick;\1\&backtick;/g
  s/`([^`]*)`/<code>\1<\/code>/g
')

# del, mark, sup, sub
MOD=$(echo "$MOD" | sed -E '
  s/~~(.*)~~/<del>\1<\/del>/g
  s/==(.*)==/<mark>\1<\/mark>/g
  s/\^(.*)\^/<sup>\1<\/sup>/g
  s/~(.*)~/<sub>\1<\/sub>/g
')

# a, auto detect url
MOD=$(echo "$MOD" | sed -E '
  s/<((https?:\/\/)?(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))>/<a href=\"\1\">\1<\/a>/

  s/(^|[^\(">])(https?:\/\/(www\.)?[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9()]{1,6}\b([-a-zA-Z0-9()@:%_\+.~#?&//=]*))/\1<a href=\"\2\">\2<\/a>/
')

# img, a
MOD=$(echo "$MOD" | sed -E '
  s/!\[(.*)\]\((.*) "(.*)"\)/<figure>\n  <img src="\2" alt="\1" title="\3" loading="lazy">\n  <figcaption>\1<\/figcaption>\n<\/figure>/g
  s/!\[(.*)\]\((.*)\)/<figure>\n  <img src="\2" alt="\1" loading="lazy">\n  <figcaption>\1<\/figcaption>\n<\/figure>/g

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

# table
MOD=$(echo "$MOD" | sed -E '
  /^\|.*\|$/ {
    i\<table>\n  <thead>
    s/^\|(.*)\|$/<tr>\n<th>\1<\/th>\n<\/tr>/
    s/\|/<\/th>\n<th>/g
    :a
    s/ {2,}//g

    /^[ |:-]+$/ {
      s/-+/--/g
      s/:-+/:-/g
      s/-+:/-:/g
      s/:-+:/::/g
      h
      s/\|[ |:-]+\|/  <\/thead>\n  <tbody>/
    }

    /^\|.*\|$/ {                                                        G
      s/\n//
      s/^/<tr>\n/
      s/$/\n<\/tr>/

      :t
      s/\n\|([^|]+)(.*)\|\|([^|]+)(.*)/\n\1\3\n\2\|\4/
      tt

      s/\n\|\|\n/\n/
      s/([[:print:]]*)--/<td>\1<\/td>/g
      s/([[:print:]]*):-/<td class=\"align-left\">\1<\/td>/g
      s/([[:print:]]*)-:/<td class=\"align-right\">\1<\/td>/g
      s/([[:print:]]*)::/<td class=\"align-center\">\1<\/td>/g
    }

    n
    $ a\  </tbody>\n</table>
    /\|$/ ba
    i\  </tbody>\n</table>
  }
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

# return escaping
MOD=$(echo "$MOD" | sed -E '
  s/\&backslash;/\\/g
  s/\&asterisk;/\*/g
  s/\&dot;/\./g
  s/\&pipe;/\|/g

  s/\&backtick;/`/g
  s/\&undnerscore;/_/g
  s/\&sharp;/#/g
  s/\&hyphen;/-/g
  s/\&exclamation;/!/g

  s/\&curlyleft;/{/g
  s/\&curlyright;/}/g
  s/\&squareleft;/[/g
  s/\&squareright;/]/g
  s/\&roundleft;/(/g
  s/\&roundright;/)/g

  s/\&plus;/+/g
  s/\&tilde;/~/g
  s/\&equal;/=/g
  s/\&caret;/\^/g
  s/^\&colon;/:/g
')

# output
echo "$MOD"
