# PnutAttributedString

How to translate from pnut.io entities to NSAttributedString in Swift.

## Context

A pnut.io entity - like a mention, a link or a tag - has properties, including the entity position: `pos` and length: `len` in the text.

These `pos` and `len` properties are indices into the Unicode scalars view.

## Issue for iOS/macOS developers

You will want to use these indices in an NSAttributedString for adding colors and/or actions to the mentions, tags and links in the post text.

But these indices do not always correspond to their counterpart in NSAttributedString, because NSString represents text as indices of the UTF-16 code points.

As a consequence, some Unicode characters (some emojis or combinations of emojis, for example) will lead to unexpected results such as offset indices and out of range character addressing.

## Solution

The solution is to translate between indices of different views (different text representations) before adding attributes to the NSAttributedString with NSRange.

## Example

See `example.swift`.

## Disclaimer

This works for most of the cases - still, some complex combinations of emojis can break the indices translation (think "Zalgo for graphemes"). Those situations are rare enough that I've decided to ignore them. Feel free to contribute if you find a solution which also works for these extreme cases.

## Thanks

Original idea and code by [Martin R](http://stackoverflow.com/users/1187415/martin-r).