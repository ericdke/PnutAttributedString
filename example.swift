import Foundation

let text = post.text // The text from the post object
let attrStr = NSMutableAttributedString(string: text)

// SWIFT 3

// Starting position for each encoding representation
let startUTF = text.utf16.startIndex
let startUnicode = text.unicodeScalars.startIndex

// Iterate over the mentions objects
for mention in post.mentions {

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

// SWIFT 4

// In Swift 4, the standard library provides methods to convert between Swift String ranges and NSString ranges, making the calculations simpler.

for mention in post.mentions {

   // Compute String.UnicodeScalarView indices for first and last position
   let fromIdx = text.unicodeScalars.index(text.unicodeScalars.startIndex, offsetBy: mention.pos)
   let toIdx = text.unicodeScalars.index(fromIdx, offsetBy: mention.len)

   // Compute corresponding NSRange from Swift Range
   let nsRange = NSRange(fromIdx..<toIdx, in: text)

   // This NSRange is what we need for the attributed string
   attrStr.addAttribute(NSForegroundColorAttributeName, value: NSColor.red, range: nsRange)
}

// Idea and original code: [Martin R](https://stackoverflow.com/users/1187415/martin-r)