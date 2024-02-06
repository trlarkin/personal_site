#!/bin/sh

pandoc md/resume.md -o generated/resume.html  -f markdown -T html --filter pandoc-filter/exe/pandoc-filter

# pandoc md/blogs/first-blog.md -o generated/blogs/first-blog.html -f markdown -T html --filter pandoc-filter/exe/pandoc-filter
# pandoc md/blogs/pandoc-filters.md -o generated/blogs/pandoc-filters.html -f markdown -T html --filter pandoc-filter/exe/pandoc-filter

echo "
---
title: 'List of Blogs'
---

" > md/blogs/index.md

## I would like to get this working:
elements=$(ls md/blogs)
for file in $elements
do
    if test -d $1/$file
    then
        . md2html.sh $1/$file
    else
        pwd=$(pwd)
        old_name=$pwd/$1/$file
        new_name=${file%.md}
        echo $new_name
        echo "- @$new_name" >> md/blogs/index.md
        pandoc $pwd/md/blogs/$new_name.md -o $pwd/generated/blogs/$new_name.html -f markdown -T html --filter pandoc-filter/exe/pandoc-filter
    fi
done

pandoc md/blogs/index.md -o generated/blogs/index.html -f markdown -T html --filter pandoc-filter/exe/pandoc-filter
