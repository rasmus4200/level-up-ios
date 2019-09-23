# Enums

Enums are first class citizens in Swift. Here are some of the cool things they can do.

## Simple State Machines

Here is an example of an enum that can mutate its own state, and treat itself like a simple state machine.

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

Note the mutating method. This is necessary for declaring that this function will change this enums state - because by default enums don’t really change state - they simply represent it. This mutating keyword lets this enum change the state of itself.

## Guard clauses

Here is an example of how enums can be used in guard clauses.

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
}
```

If the type chat isn’t authenticated then we had better return early from this initializer in the ViewController. Enums make this really readable and clear.

## Minimize hard coded strings

With Swift enums you don’t even need to put up with hard coded strings. Instead you can define an enum of fixed type String, and then switch on it when you are preparing for segues in view controllers.

```swift
enum SegueIdentifier: String {
    case Login
    case Main
    case Options
}

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

Note that last line there. Raw value. That represents the raw underlying value of the enum, and if you even want the actual string, or whatever enum is represented as, you just call it.

## Enums as errors

One pattern you see a lot in Swift is enums being used as errors. 

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

Here is an example of an AlamoFire error (popular CocoaPod) and look at how beautifully it captures and represents all the different ways it’s errors can be.

Aldo not the extension method here at the bottom. Extension are great ways to add nice helper APIs to an already defined enum. In this case whether the URL is invalide due to the URL.

## Fluent Interfaces

And enums can just lead to some really nice code. Checkout this example of NetworkReachability that defines in enums all the way networks can’t be reached, and then through a series or really nice computed properties, all the various ways you can conveniently check.

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

# Basics

Now if all that looked cool, but when you squint you aren't sure why enums can do all these things, take a look at how far enums in Swift have come, and how they are first class citizens in the language.

## What are enums?

An enum, was a data structure created way back in the C days to represent common integer data in a more human readable form.

For example, to represent the different suits in a card game, you might assign integers to values like this in C.

```swift
enum cardsuit {
    Clubs    = 1,
    Diamonds = 2,
    Hearts   = 3,
    Spades   = 4
};
```

Then instead manually having to check a suits value

```swift
if (suit == 2) // yuck!
```

You could simply check the value of it’s enum

```swift
if (suit = Hearts) // nice!
```

Making your code much more readable.


In Swift we don’t have to assign values to our enums - the compiler does that for us automatically. 

```swift
enum CardSuit {
     case clubs
     case diamonds
     case hearts
     case spades
}
```

And the pattern you see a lot in Swift for enumerating enums is the `switch`.

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

This Tile class defines an enum StatusState that captures all the valid states a tile can be in, and then in the status property method a convenient switch statement can be used to decide what to do next.

## How different ?

Enums in Swift are first class citizens. That means they can do a lot more than emums in other languages. For example, in Swift enums can have:

- Computed properties
- Methods
- Initializers
- Extensions
- Generics
- Associated values

### Computed properities

While you can’t store a property directly on a Swift enum like this

```swift
enum Device {
  case iPad
  case iPhone

  var year: Int // 💥
}
```

You can provide computed properties like this

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

Here you can see we have x2 types of devices, iPad and iPhone, but the year is a computed property based on the state of the enum itself.

### Methods

Enums in Swift also support methods.

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
```

Here is an enum called `Character`, that describes an embedded enum (`Weapon`) but also defines two characters types, `thief` and `warrior`.

### Initializers

Another thing enums can do is initialize themselves.

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

This enum doesn't know what its initial value should be. So the initializer takes a value and sets its enum state on itself.

### Extensions

With Swift enum extensions, you can separate your data from methods like this.

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

 And you can even add extend and add new functionality to an enum like this.

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

### Generics

And if you are really into Generics, you can even define an enum based on a Generic types too.

```swift
enum Information<T1, T2> {
    case name(T1)
    case website(T1)
    case age(T2)
}

let info = Information.name("Bob") // Error
```

Here the compiler is able to recognize T1 as ‘Bob’, but T2 is not defined yet. Therefore, we must define both T1 and T2 explicitly as shown below.

```swift
let info = Information<String, Int>.age(20)
print(info) //prints age(20)
```

### Associated Values

Associated values are parameters you can include as part of an enum, and unwrap and make use of later when switching on your enum state.

For example this enums type take values associated with each respective enum.

```swift
enum SectionType {
    case email(showHeaderView: Bool)
    case listSelection(pickerTitle: String)
}
```

Then later on when you are using it you can pass along any relative data.

```swift
let section = SectionType.email(showHeaderView: false)
```

And then switch on, and unwrap it later.

```swift
switch section {
case .email(let showHeaderView): // unwrapping the associated value
    print("Email showHeaderView: \(showHeaderView)")
case .listSelection(let pickerTitle):
    print("List pickerTitle: \(pickerTitle)")
}
```

The let statements in the case section unwrap the associated value to that enum type. This is really hand for passing data along with the enum type. This also works for tuples.

### Associated Values as Tuples

Tuples are an ‘on the fly’ data structure where you can group a collection of variables together, like above as a series of ints, and then latter on unpack them and use them when processing.

They are another whole topic in themselves, but just do be alarmed if you see code like this and you are wondering what it means.

```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```

They way to read this is

> “Define an enumeration type called Barcode, which can take either a value of upc with an associated value of type (Int, Int, Int, Int), or a value of qrCode with an associated value of type String.”

This is going to sound strange, but here the associated type with the upc barcode is (Int, Int, Int, Int). That’s the tuple. That’s the type.

In our case it is also the associated value with the enum. I personally don’t like this way of defining associated types with enums, because I don’t know what all those ints actually mean. 

I would rather write it like this.

```swift
enum BarcodeWithNamedParams {
    case upc(numberSystem: Int, manufacturer: Int, product: Int, check: Int)
    case qrCode(productCode: String)
}
```

To me that is much more clear. But tuples are something you will periodically come across. So I want you to not be alarmed and now that all they are is an associated type without named parameters.

You create them like this

```swift
var productBarcode = Barcode.upc(8, 85909, 51226, 3)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

Then unpack them like this

```swift
switch productBarcode {
case .upc(let numberSystem, let manufacturer, let product, let check):
    print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
``` 

And if everything for a tuple is a let you can include only one let statement at the beginning of the line for brevity.

```swift
switch productBarcode {
case let .upc(numberSystem, manufacturer, product, check):
    print("UPC : \(numberSystem), \(manufacturer), \(product), \(check).")
case let .qrCode(productCode):
    print("QR code: \(productCode).")
}
```

### When should I use enums?

Considering using enums any time you have predefined state. 

```swift
enum Beverage: {
    case coffee, tea, juice
}

enum ChatType {
    case authenticated
    case unauthenticated
}

enum Device {
    case iPhone
    case iPad
}
```

Predefined state is when you know all the states a collection of data can be in, and you are looking for a convenient means of grouping them together.

Happy coding! 🤖
