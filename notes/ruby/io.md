<http://stackoverflow.com/questions/5018633/what-is-the-difference-between-print-and-puts>

`print` outputs each argument, followed by `$,`, to `$stdout`, followed by `$\`. It is equivalent to `args.join($,) + $\`

`puts` sets both `$,` and `$\` to "\n" and then does the same thing as `print`. The key difference being that *each argument* is a new line with `puts`.

You can `require 'english'` to access those global variables with [user-friendly names](http://ruby-doc.org/stdlib-2.0/libdoc/English/rdoc/English.html).
