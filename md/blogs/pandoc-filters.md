---
title: 'Pandoc Filters'
style: 'blog'
---

I am writing these blogs in markdown and using Pandoc to compile them into html. Lunky for me, Pandoc is written 
in Haskell and there is a way to alter how Pandoc works to fit my needs. These are called filters and I am experimenting with them a bit. 

Here is a rundown of how they work: 

1. The original file (I pretty much just use markdown but Pandoc accepts many formats) is passed into Pandoc
2. Pandoc parses the input into an internal (or native) representation
3. Filters act on the internal representation to produce a NEW internal representation
4. Pandoc takes the internal representatino and turns it into the output (I generally use PDF or HTML but again there are many)

The path looks like:
```
INPUT -{Pandoc}-> Internal -{Filter}-> New Internal -{Pandoc}-> OUTPUT
```

The first usefule thing I implemented was an ability to use the `@` symbol to 
tell Pandoc that the word that follows it is important and should have a link to a blog with the same 
name as the word. For example `@pandoc-filters` or @pandoc-filters will make a link back to this page. 
These pages don't even need to be @implemented and the link will just take you to where it expects I might 
one day add the link (click on implemented to see).

Here is an example of a @Haskell code that produces this effect:
```haskell
import qualified Data.Text        as T
import           Text.Pandoc.JSON

main :: IO ()
main = do
    toJSONFilter linkToBlog
    return ()

-- | adds a link to any blog with a word in the form @word
linkToBlog :: Inline -> Inline
linkToBlog (Str strText)
    | head strString == '@' = linkTo
    where
        strString = T.unpack strText
        toLowerStr = tail . T.unpack . T.toLower
        linkTo = Link
            ( T.empty , [] , [] )
            [ Underline [ Str (T.tail strText) ]]
            ( T.pack ("./" ++ toLowerStr strText ++ ".html") , T.empty )
linkToBlog x = x  -- any other case just don't do anything
```

Then when I call my homemade script:
```sh
pandoc $(pwd)/md/blogs/$name}.md -o $(pwd)/generated/blogs/$name.html -f markdown -T html --filter pandoc-filter/exe/pandoc-filter
```
where the `--filter` option is where I put the executable I get from Haskell code.

These are cool and I hope to continue to use them to make my life easier!