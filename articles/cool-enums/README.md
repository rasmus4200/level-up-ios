# Cool things you can do with Swift enums ⚡

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
            case .delinquent: delinquentState.isHidden = false
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

### Enums as Strings

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

### Associated values

Just when you through enums couldn’t get any more cool, you discover that enums also have the ability to contain associated values. 🚀

> Associated values are parameters you can include as part of an enum definition, to make use of later when making a decision later.

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

#### Tuples

Swift enums also support passing values as tuples.

```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```

This can be read as:

> “Define an enumeration type called Barcode, which can take either a value of upc with an associated value of type (Int, Int, Int, Int), or a value of qrCode with an associated value of type String.”

This definition doesn’t provide any actual Int or String values—it just defines the type of associated values that Barcode constants and variables can store when they are equal to Barcode.upc or Barcode.qrCode.

You can then create new barcodes using either type:

```swift
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

The to check what type of barcode you have by switching on them. Here you can also extract the associated value as a constant (with the `let` or `var` prefix.

```swift
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
```

And if everything is a `let` or a `var` you can replace them all with a single for brevity.

```swift
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
```

### Raw values

Associated values show how enumerations can declare that they store associated values of different types. As an alternative they can also come prepopulated with default values (called _raw values_) which are of the same type.

```swift
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}

enum CompassPoint: String {
    case north, south, east, west
}

print(CompassPoint.south.rawValue) // prints 'South'
```

### Enums with Computed Properties

```swift
enum Device {
  case iPad
  case iPhone

  var year: Int {
    switch self {
      case .iPhone: 
        return 2007
      case .iPad: 
        return 2010
    }
  }
}

let device = Device.iPhone
print(device.year)
```

Note enums can’t have stored properties. In other ways you can’t do this.

```swift
enum Device {
  case iPad
  case iPhone

  var year: Int // BOOM!
}
```

### Enums with mutating methods

Enums by themselves have no state. But you can simulate, or toggle an enums state by having it mutate itself. By creating a mutating function that can set the implicit self parameter, use can change the state of the referenced enum itself.

```swift
enum TriStateSwitch {
    case off
    case low
    case high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var ovenLight = TriStateSwitch.off
ovenLight.next() // ovenLight is now equal to .low
ovenLight.next() // ovenLight is now equal to .high
ovenLight.next() // ovenLight is now equal to .off again
```

This is really cool because it’s like a state machine within itself.

### Enums with static methods

```swift
enum Device {
    case iPhone
    case iPad

    static func getDevice(name: String) -> Device? {
        switch name {
        case "iPhone":
            return .iPhone
        case "iPad":
            return .iPad
        default:
            return nil
        }
    }
}

if let device = Device.getDevice(name: "iPhone") {
    print(device)
    //prints iPhone
}
```

### Enums with initializers

```swift
enum IntCategory {
    case small
    case medium
    case big
    case weird

    init(number: Int) {
        switch number {
        case 0..<1000 :
            self = .small
        case 1000..<100000:
            self = .medium
        case 100000..<1000000:
            self = .big
        default:
            self = .weird
        }
    }
}

let intCategory = IntCategory(number: 34645)
print(intCategory)
```

### Enums and Protocols

Again, blurring the line between enum and struct, but if you want an enum to confirm to a protocol, you can do it like this.

```swift
protocol LifeSpan {
    var numberOfHearts: Int { get }
    mutating func getAttacked() // heart -1
    mutating func increaseHeart() // heart +1
}

enum Player: LifeSpan {
    case dead
    case alive(currentHeart: Int)

    var numberOfHearts: Int {
        switch self {
        case .dead: return 0
        case let .alive(numberOfHearts): return numberOfHearts
        }
    }

    mutating func increaseHeart() {
        switch self {
        case .dead:
            self = .alive(currentHeart: 1)
        case let .alive(numberOfHearts):
            self = .alive(currentHeart: numberOfHearts + 1)
        }
    }

    mutating func getAttacked() {
        switch self {
        case .alive(let numberOfHearts):
            if numberOfHearts == 1 {
                self = .dead
            } else {
                self = .alive(currentHeart: numberOfHearts - 1)
            }
        case .dead:
            break
        }
    }
}

var player = Player.dead // .dead

player.increaseHeart()  // .alive(currentHeart: 1)
print(player.numberOfHearts) //prints 1

player.increaseHeart()  // .alive(currentHeart: 2)
print(player.numberOfHearts) //prints 2

player.getAttacked()  // .alive(currentHeart: 1)
print(player.numberOfHearts) //prints 1

player.getAttacked() // .dead
print(player.numberOfHearts) // prints 0
```

### Enums and Extensions

Enums can have extensions, and this is handy for when you want to separate your data structs from your methods.

Note the mutating keyword. Any time you want to modify the state of an enum, a mutating method definition is needed.

```swift
enum Entities {
    case soldier(x: Int, y: Int)
    case tank(x: Int, y: Int)
    case player(x: Int, y: Int)
}

extension Entities {
    mutating func attack() {}
    mutating func move(distance: Float) {}
}

extension Entities: CustomStringConvertible {
    var description: String {
        switch self {
        case let .soldier(x, y): return "Soldier position is (\(x), \(y))"
        case let .tank(x, y): return "Tank position is (\(x), \(y))"
        case let .player(x, y): return "Player position is (\(x), \(y))"
        }
    }
}
```

### Enums as generics

Yes, you can even generize enums.

```swift
enum Information<T1, T2> {
    case name(T1)
    case website(T1)
    case age(T2)
}
```

Here the compiler is able to recognize T1 as ‘Bob’, but T2 is not defined yet. Therefore, we must define both T1 and T2 explicitly as shown below.

```swift
let info = Information.name("Bob") // Error

let info =Information<String, Int>.age(20)
print(info) //prints age(20)
```

### Other cools things

#### Enums as guard clauses

Another example of how enums can be used in with guard statements.

```swift
enum ChatType {
    case authenticated
    case unauthenticated
}

class NewChatViewController: UIViewController {

    let chatType: ChatType

    public init(chatType: ChatType) { ... }

    guard chatType == .authenticated else {
        return
    }
```

#### Iterating over enums

```swift
enum Beverage: CaseIterable {
    case coffee, tea, juice
}
let numberOfChoices = Beverage.allCases.count

for beverage in Beverage.allCases {
    print(beverage)
}
```

#### Enums as Errors

```swift
public enum AFError: Error {

    case invalidURL(url: URLConvertible)
    case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
    case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
    case responseValidationFailed(reason: ResponseValidationFailureReason)
    case responseSerializationFailed(reason: ResponseSerializationFailureReason)

    public enum ParameterEncodingFailureReason {
        case missingURL
        case jsonEncodingFailed(error: Error)
        case propertyListEncodingFailed(error: Error)
    }

    public var underlyingError: Error? {
        switch self {
        case .parameterEncodingFailed(let reason):
            return reason.underlyingError
        case .multipartEncodingFailed(let reason):
            return reason.underlyingError
        case .responseSerializationFailed(let reason):
            return reason.underlyingError
        default:
            return nil
        }
    }

}

extension AFError {
    /// Returns whether the AFError is an invalid URL error.
    public var isInvalidURLError: Bool {
        if case .invalidURL = self { return true }
        return false
    }
}
```

## Summary

`Enums` are much more than simple switch statements on type. In Swift, we can leverage enums in much more expressive creative way. Let me know if you find any more cool examples as I am still playing with all the different things you can do with these things.

Happy coding! 🤖
