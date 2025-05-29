module Main where

import qualified Data.Text        as T
import           Text.Pandoc.JSON
import           Text.Pandoc.Walk

main :: IO ()
main = toJSONFilter compositeFilter

compositeFilter :: Pandoc -> Pandoc
compositeFilter = walk dollarHaskellBlock
                . walk linkToBlog

-- | Lets me act specially on codeblocks labeled '$haskell'
dollarHaskellBlock :: Block -> Block
dollarHaskellBlock (CodeBlock (identifier, cls:clss, keyValue) codeText)
    | "$haskell" <- T.unpack cls = CodeBlock (identifier, T.pack "haskell":clss, keyValue) newCodeText
        where
            newCodeText = codeText  -- do something here
dollarHaskellBlock x = x

-- | Set the style if style : 'blog', NOT IMPLEMENTED
setStyle :: Pandoc -> Pandoc
setStyle (Pandoc meta blocks)
    | hasStyle "blog" = Pandoc meta (ifBlogStyle : blocks)
    | otherwise = Pandoc meta blocks
    where
        hasStyle lookingfor = lookupMeta (T.pack "style") meta == Just (MetaString $ T.pack lookingfor)
        ifBlogStyle = undefined

-- | adds a link to any blog with a word in the form @word
linkToBlog :: Inline -> Inline
linkToBlog (Str strText)
    | Just ('@', strTextTail) <- T.uncons strText = Link
                ( T.empty , [] , [] )
                [ Underline [ Str (T.tail strText) ]
                ]
                ( T.pack ("./" ++ (T.unpack . T.toLower) strTextTail ++ ".html") , T.empty )
linkToBlog x = x
