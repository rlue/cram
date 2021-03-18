🧑‍🎓 Cram
======

Studying with [Anki](https://apps.ankiweb.net/)?
Build “notes” (flash cards) faster with cram.

Cram is a toolkit for automating the creation of CSVs
that can then be imported as notes in Anki.

(Currently, cram only includes tools for studying Traditional Chinese.
See the [Design](#design) section to learn how you can extend cram
for your own purposes.)

Dependencies
------------

* Ruby 2.5+

Installation
------------

TBD

Usage
-----

### Explicitly / verbosely

#### Command

```sh
$ cram extract:zh input.txt \  # Print only Chinese characters from input file, one per line, without duplicates
  | cram append:zhuyin \       # add a field to each line for that character’s 注音 pronunciation
  | cram append:cangjie \      # add a field to each line for that character’s cangjie code
  | cram append:zh-compounds \ # add a field to each line for compound words containing that character
  >> output.csv
```

#### Input

```
你可不可以教我怎麼用 Anki？
```

#### Output

```csv
你,ㄋㄧˇ,人弓火,～好
可,ㄎㄜˇ,一弓口,～能
不,ㄅㄨˋ,一火,對～起
以,ㄧˇ,女戈人,所～
教,ㄐㄧㄠ,十木人大,～室
我,ㄨㄛˇ,竹手戈,自～
怎,ㄗㄣˇ,人尸心,～樣
麼,ㄇㄜ˙,戈木女戈,什～
用,ㄩㄥˋ,月手,使～
```

### Or, configure a shortcut

With the configuration below,
the above command can be substituted with:

```sh
$ cram use zh-literacy input.txt
```

```yml
# ~/.config/cram.yml

profiles:
  zh-literacy:
    extract:zh:
    append:zhuyin:
    append:cangjie:
    append:zh-compounds:
    output:
      path: ~/notes/chinese-characters.csv
      append: true
```

Design
------

Cram is built according to [the UNIX philosophy](https://en.wikipedia.org/wiki/Unix_philosophy#Origin):

> * Write programs that do one thing and do it well.
> * Write programs to work together.
> * Write programs to handle text streams, because that is a universal interface.

Like git, cram is actually a collection of scripts
which each perform one specific task.
These tasks all operate on text streams,
incrementally transforming them to produce an importable CSV.

Development / Contributing
--------------------------

Cram can be extended with your own custom scripts.
Your scripts do _not_ have to be written in Ruby,
nor do they have to be stored in cram’s installation directory.

For instance, to create a new `cram extract:he` command
for extracting Hebrew text from a document,
place your script here:

```
📁 $HOME/.local/lib
└── 📁 cram
    └── 📁 extract
        └── 🗎 he
```

You can even create bare (non-namespaced) commands
by saving custom scripts directly to `lib/cram/`.
To create a `cram foo` command, use:

```
📁 $HOME/.local/lib
└── 📁 cram
    └── 🗎 foo
```

All CLI arguments and options will be passed directly
to your script.

License
-------

© 2021 Ryan Lue. This project is licensed under the terms of the MIT License.
