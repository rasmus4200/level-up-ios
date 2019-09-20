# Cool things you can do with Swift enums

[Swift Enums](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html) are most more powerful than the traditional integer based enumerations we worked with in C. In this article I want to show you some of the cool things Swift enums can do, to make your code more readable and your programs easier to understand.

## Swift Enums are different

The first thing to realize about Swift enums is that they are first-class citizens. By that I mean in Swift enums support
- Computed properties
- Methods
- Intializers
- Protocols
- Extensions
- Generics

About the only thing they can’t do are [store properties](https://docs.swift.org/swift-book/LanguageGuide/Properties.html). But other than that they are pretty full on.

## How to use

Because of these enhancements, there are so many more things Swift enums can do that would couldn’t in other languages. Let’s start with the basics, and then look at more advanced examples from there.

### Capture State

Enums are great at capturing state. If you are ever wondering whether you should consider using an enum ask yourself.

> Does this thing represent state, and can it be represented by a set of predefined values.

If it does, an enum might work. Here is an example of an enum presenting the status of a tile in a `UIViewController`.

```swift
class Tile {
    enum StatusState {
        case loading
        case loaded
        case failed
        case delinquent
    }
    
    var status: StatusState {
        didSet {
            switch status {
            case .loading: loadingState.isHidden = false
            case .loaded: loadedState.isHidden = false
            case .failed: failedState.isHidden = false
            case .delinquent: delinquentState?.isHidden = false
            }
        }
    }
}
```
