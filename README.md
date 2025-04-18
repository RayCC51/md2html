# md2html.sh

markdown to html converter written in pure bash(sed)

it support extended markdown [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)


## quick start

```bash
./md2html.sh your_file.md > result_file.html
```


## diffrences from [mattcone/markdown-guide](https://github.com/mattcone/markdown-guide)

- do not need to escape 
    - angle brackets(<, >), underscore(_)
    - dot(.) after number inside unordered list. ex) - 1. this is ul
- does not support 
    - underscore(_) for bold, itallic. ex) "\_em\_" is not itallic
    - other elements inside list
    - emoji shortcode like (:smile:). just use 😀 directly
- HTMl
    - support <details>, <summary>
    - other html tags are not allowed
- text above the "===" or "---" line does not converted to heading
- diffrent (-*+) in the same ul is supported
- does not detect url link automatically
- more then 5 backtick codeblock not working


## bugs

- list
    - can not handle more then 2 level indented list
    - can not use mixed ul ol
- footnote
    - footnote name with space does not working
    - note with several lines not working
- em, strong
    - * a **strong** inside em*
- table
    - the <thead> element can only contain one row
