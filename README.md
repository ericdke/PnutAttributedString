# PnutAttributedString

How to translate from pnut.io entities to NSAttributedString.

## Context

A pnut.io entity - like a mention, a link or a tag - has properties, including the entity position: `pos` and length: `len` in the text.

These `pos` and `len` properties are indices into the Unicode scalars view.

## Issue for iOS/macOS developers

You will want to use these indices in an NSAttributedString for adding colors and/or actions to the mentions, tags and links in the post text.

But these indices do not correspond to their counterpart in NSAttributedString, because NSString represents text as indices of the UTF-16 code points.

As a consequence, some Unicode characters (some emojis or combinations of emojis, for example) will lead to unexpected results such as offset indices and out of range character addressing.

## Solution

The solution is to translate between indices of different views (different text representations) before adding attributes to the NSAttributedString.

## Example

Example for mentions in Swift:

	import Foundation

	let text = post.text
	let attrStr = NSMutableAttributedString(string: text)

	for mention in post.mentions {

        let startUTF = text.utf16.startIndex
        let startUnicode = text.unicodeScalars.startIndex

		// Compute String.UnicodeScalarView indices for first and last position:
	    let from32 = text.unicodeScalars.index(startUnicode, offsetBy: mention.pos)
	    let to32 = text.unicodeScalars.index(from32, offsetBy: mention.len)

	    // Convert to String.UTF16View indices:
	    let from16 = String.UTF16View.Index(from32, within: text.utf16)
	    let to16 = String.UTF16View.Index(to32, within: text.utf16)

	    // Convert to NSRange by computing the integer distances:
        let loc = text.utf16.distance(from: startUTF, to: from16)
        let ln = text.utf16.distance(from: from16, to: to16)
	    let nsRange = NSRange(location: loc, length: ln)

	    // This NSRange is what we need for the attributed string:
	    attrStr.addAttribute(NSForegroundColorAttributeName, value: NSColor.red, range: nsRange)
	}

## Disclaimer

This works for 99.99% of the cases - still, some complex combinations of emojis can break the indices translation (think "Zalgo for graphemes"). Those situations are rare enough that I've decided to ignore them. Feel free to contribute if you find a solution which also works for these extreme cases.

## Thanks

All credit go to [Martin R.](http://stackoverflow.com/users/1187415/martin-r), this is *his* solution, I just wrote the additional text.
