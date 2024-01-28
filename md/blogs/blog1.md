# Blog 1

## Preface
This is the first "blog" in what will hopefully be a series of notes/explanations on some topics in functional programming. These topics will include dependent types and linear types. Enjoy!

## My issue with Scheme
Scheme is a beautiful language, and the toy language "Pie" uses the Scheme syntax as its base. My problem with it is that it is not pretty, and how pretty something is can really affect my opinion on it. In Scheme we end up with things like:
```scheme
(define swap
    (lambda (p)
        (elim-Pair 
            Nat Atom
            (Pair Atom Nat
            p
            (lambda (a d)
                (cons d a))))))
```
to define a function that swaps elements in a `Pair` (basically a 2-tuple as far as I understand). That said, I think it is actually good to learn a lisp-like language first because it forces you to understand things. In this case specifically the above code is technically from a language called "Pie" and I think as I go through *The Little Typer* I will try to  convert code like that above into something more Haskelish for practice. Of course we are using Pie here in part **BECAUSE** Haskell does not have dependent types so the more Haskelish code will in fact not actually be Haskell. 

## Getting Going

It is important to know a few things about Pie (the language),
1. Functions are applied in the form 
    ```scheme
    (function arg1 arg2 ... argN)
    ```
2. Anonymous functions are created by using 
    ```scheme
    (lambda (arg1 arg2 ...)
        ( ...body... ))
    ```
3. Naming a function that can be used elsewhere is
    ```scheme
    (define function-name
        ( ...thing you want to name... ))
    ```
Now we can talk about it. 

The way we can make a 2-tuple in Pie (which is called a Pair) is with `cons`. I am skeptical calling `cons` a function because they do not directly say that in the book I'm using, but it acts like one:
```scheme
> (cons 1 2)
"Error: 2-interactions from an unsaved 
editor:4:2: Can't determine a type"
```
And we already have an error 😐. Pie is very strict with its types, so we can actually do this by using the `the` function, which lets us tell Pie what the type of out `Pair` is:
```scheme
> (the (Pair Nat Nat) (cons 1 2))
(the (Pair Nat Nat)
  (cons 1 2))
```
Where `Nat` is the type of a natural number (0, 1, 2, ...). We can then take the first element in the `Pair` with `car`:
```scheme
> (car
   (the (Pair Nat Nat) (cons 1 2)))
(the Nat 1)
```
And we just get 1. Another type we are going to want to use is the `Atom` type, which for now just think of as a string of letters following a `'` mark:
```scheme
> 'hello
(the Atom 'hello)
> 'world
(the Atom 'world)
```
Note we do not need to use the `the` function because `'hello` and `'world` are clearly `Atom`s (I think).

Now that I have used `the` a few times, have you noticed something weird? Maybe you don' thtink so, but to me `the` taking in a TYPE as input is odd. If you were in C and someone wrote:
```c
x = make_number(1, float);
y = make_number(1, int);
[x is the float 1.0]
[y is the int 1]
```
I would be pretty taken aback, but in Pie, we will see types and data used side-by-side all the time. 

Now we have three types: `Nat`, `Atom`, and `Pair`. `Pair` stands out here as different, because we dont just have an instance of `Pair`, we have a `(Pair Nat Nat)` or `(Pair Atom Nat)` where the instance of the type is defined based on what the elements in the `Pair` will be. This means we can essentially use types like parameters to make types (eg `Pair`) and to change the behavior of a function (eg `the`). 

Since we are going to be using types like values, lets give all types a type, called `U`. This means the same way {`0`, `1`, `2`, `3`, `4`, ...} are all `Nat`s and {`'hello`, `'world`, ...} are all `Atom`s, {`Nat`, `Atom`, `Pair Atom Nat`, ...} are all `U`s.

Lets go back to that funky code from the beginning:
```scheme
(define swap
    (lambda (p)
        (elim-Pair 
            Nat Atom
            (Pair Atom Nat)
            p
            (lambda (a d)
                (cons d a)))))
```
yeah that one! Lets say that elim-Pair is defined to take in three types then a pair and a function of two arguments. In Haskell we cannot pass types around like this, but what if I add a little bit of syntax. I will now say that instead of the regular `->` in a type declaration, we also have `-@` which means the argument was a type, not a value of a vertain type, and from then on I want Haskell to know and enforce that if the type is ever mentioned again treat it as the type that was input. The type signature might look something like:
```haskell
elimPair :: U1 -@ U2 -@ U3 -@ (Pair U1 U2) -> (U1 -> U2 -> U3)

-- a valid input could be
elimPair Bool Int String (cons True 1) (\a b -> "hello")

-- an invalid input
elimPair Int Int Float (cons 2.5 1) (\a b -> a)
{-fails because U1 is Int, and the 
Pair is a (Pair Float Int), which is 
not allowed since U1 us an Int -}
``` 
Okay, but what does `elim-Pair` do? `elim-Pair` takes out `Pair` and breaks it into pieces, then uses those elements to in the function to add as input. The use of types as arguments is helpful because we only need to define this one function for any combination of types, but we do not have to weaken our type system. 

## Conclusion
This might not really properly show why we want dependent types, or what they really do, or explain how to use them, but I hope it shows the main odd idea about them, that they can be passed around like data. Hopefully I will also get better at this. 