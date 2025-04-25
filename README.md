# md2html.sh

markdown to html converter written in pure bash(sed)

it support extended markdown [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)


## quick start

```bash
./md2html.sh your_file.md > result_file.html
```


## diffrences from [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)

- do not need to escape 
    - angle brackets(<, >)
    - dot(.) after number inside unordered list. ex) - 1. this is ul
- does not support 
    - emoji shortcode like (:smile:). just use 😀 directly
    - auto detect link
    - more then 5 backtick codeblock
    - text above `---` or `===` line does not converted to heading
- HTMl
    - support tags: details, summary, br, comment
    - other html tags are not allowed
- diffrent (-*+) in the same ul is supported


## bugs - [demo](https://raycc51.github.io/BashWrite/posts/markdown/md4html-bug.html)

- list
    - other elements inside the list
- footnote
    - footnote name with space does not working well
    - note with several lines not working
- table
    - can not align
