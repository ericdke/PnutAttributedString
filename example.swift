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