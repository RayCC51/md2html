# md2html.sh

markdown to html converter written in pure bash

it support extended markdown [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)


## quick start

```bash
./md2html.sh your_file.md > result_file.html
```


## diffrences from [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)

- do not need to escape 
    - dot(.) after number inside unordered list. ex) - 1. this is ul
- does not support 
    - emoji shortcode like (:smile:). just use 😀 directly
    - more then 5 backtick codeblock
    - double backtick
    - text above `---` or `===` line does not converted to heading
- diffrent (-*+) in the same ul is supported


## bugs - [demo](https://raycc51.github.io/BashWrite/posts/markdown/md4html-bug.html)

- codr
    - double backtick
    - escape special characters automatically
- list
    - other elements inside the list
- footnote
    - footnote name with space does not working well
    - note with several lines not working
    - footnote position? to bottom?
