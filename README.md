# MXRMessenger

<!-- [![CI Status](http://img.shields.io/travis/Scott Kensell/MXRMessenger.svg?style=flat)](https://travis-ci.org/Scott Kensell/MXRMessenger) -->
[![Version](https://img.shields.io/cocoapods/v/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)
[![License](https://img.shields.io/cocoapods/l/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)
[![Platform](https://img.shields.io/cocoapods/p/MXRMessenger.svg?style=flat)](http://cocoapods.org/pods/MXRMessenger)

## Why Another Chat Library?

`MXRMessenger` is a customizable chat library meant to provide a smooth-scrolling, responsive experience.  I felt the need to write it because

- [NMessenger](https://github.com/eBay/NMessenger) is Swift-only: see https://github.com/eBay/NMessenger/issues/40
- [JSQMessagesViewController](https://github.com/jessesquires/JSQMessagesViewController) is UIKit-based and was the library we were using until we experienced stability and performance issues.  It is also no longer being maintained.
- I could not find another [Texture](http://texturegroup.org) (or ASDK) chat library which was lightweight, customizable enough for our needs. Sometimes they depend on [SlackTextViewController](https://github.com/slackhq/slacktextviewcontroller#core) which I felt is too heavy and unnecessary a dependency for our specific needs.

That said, if you have never worked with [Texture](http://texturegroup.org), you are probably better off choosing one of the more mature libraries linked above.

## Features





## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

MXRMessenger is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "MXRMessenger"
```

## Author

Scott Kensell, skensell@gmail.com

## License

MXRMessenger is available under the MIT license. See the LICENSE file for more info.
