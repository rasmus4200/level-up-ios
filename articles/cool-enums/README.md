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

> Note: We aren’t actually storing any state here. Everything you see simply a type (an enum) and a computed value.

Here is an example of an enum using a method to reflect upon itself to give a description.

```swift
enum Character {
    enum Weapon {
        case bow
        case sword
        case dagger
    }
    
    case thief(weapon: Weapon)
    case warrior(weapon: Weapon)
    
    func getDescription() -> String {
        switch self {
        case let .thief(weapon):
            return "Thief chosen \(weapon)"
        case let .warrior(weapon):
            return "Warrior chosen \(weapon)"
        }
    }
}

let character1 = Character.warrior(weapon: .sword)
print(character1.getDescription())
// prints "Warrior chosen sword"

let character2 = Character.thief(weapon: .bow)
print(character2.getDescription())
//prints "Thief chosen bow"
```

If we want to store state (like something in a stored property) we need to rech for something more. Like a struct or a class.

### Combining with Structs

Deciding between pure `enums` and `enums` combined with `structs` often comes down to state. If you need state, you can get the same type and representation. You just need to convert one of the enums into a struct, and then store the enum as a type in the struct itself.

```swift
struct Character {
    enum CharacterType {
        case thief
        case warrior
    }
    enum Weapon {
        case bow
        case sword
        case dagger
    }
    let type: CharacterType
    let weapon: Weapon
}

let character = Character(type: .warrior, weapon: .sword)
print("\(character.type) chosen \(character.weapon)")
```

The advantage of the `struct` is you gain the ability to store state. Which one you choose will be a matter of context and style. But both can work.

## Enums as Strings

With Swift, enums don’t have to be just integers. We can also represent enums as Strings.

```swift
enum SegueIdentifier: String {
    case Login
    case Main
    case Options
}

// or

enum EmployeeType: String {
    case Executive
    case SeniorManagement = "Senior Management"
    case Staff
}
```

The beauty of the String, is you no longer need to have hard coded Strings spread throughout your library. You can now capture those as enum types and switch on them very conveniently.

```swift
override func prepareForSegue(...) {
    if let identifier = segue.identifier ... {
        switch segueIdentifier {
        case .Login:
            ...
        case .Main:
            ...
        case .Options:
            ...
        }
    }
    
    SequeIdentifer.Main.rawValue // returns the `String representation`
}
```

Associated values

Just when you through enums couldn’t get any more cool, you discover that enums also have the ability to contain associated values.

Associated values are parameters you can include as part of an enum definition, to make use of later when making a decision later.

For example, here is a `UIView` that supports two kinds of view: `email` and `listSelection`. By defining these as enums, and passing along other relevant information about each type, you can use that information later with creating your subViews.

```swift
import UIKit

public class StandardEntryView: UIView {
    
    var textField = UITextField()
    
    public enum Kind {
        case email(showHeaderView: Bool)
        case listSelection(pickerTitle: String)
    }
    
    public let kind: Kind
    
    public init(kind: Kind = Kind.email(showHeaderView: false)) {
        self.kind = kind
        super.init(frame: .zero)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func commonInit() {
        
        switch kind {
        case .email(let showHeaderView): // unwrapping the associated value
            textField = makeEmailTextField(showHeaderView: showHeaderView)
        case .listSelection(let pickerTitle):
            textField = makeListSelection(title: pickerTitle)
        }
    }
}
```
