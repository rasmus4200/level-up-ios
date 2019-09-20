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

### Representing State

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

The enum `StatusState` captures all the valid states a tile can be in, and the `Tile.status` variable is set (of type enum), a convenient `switch` statement can be used to decide what to do next.

### Defining Types

But that’s only the tip of the iceberg. Look at how by combining enums, embedding them within eachother, and supplementing with a few simple computer properities makes checking network connectivity simple and easy.

```swift
class NetworkReachabilityManager {
    
    enum NetworkReachabilityStatus: Equatable {
        case unknown
        case notReachable
        case reachable(ConnectionType)
        
        enum ConnectionType {
            case ethernetOrWiFi
            case wwan
        }
    }
    
    // MARK: - Properties
    var isReachable: Bool { return isReachableOnWWAN || isReachableOnEthernetOrWiFi }
    var isReachableOnWWAN: Bool { return status == .reachable(.wwan) }
    var isReachableOnEthernetOrWiFi: Bool { return status == .reachable(.ethernetOrWiFi) }
    
    var status: NetworkReachabilityStatus {
        return .notReachable
    }
}
```


By defining enums within enums, and then adding methods, we can inspect ourselves and describe what we are.

This looks really. But there is something subtle going on here. We aren’t actually storing any state. All we have is the type of the enum and its ability to describe itself. 

If we want to add state to our data structure, we need to reach for one capable of storing properties. Like a `struct` or a `class`.

