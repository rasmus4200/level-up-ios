# Enumerations

An enumeration (_enum_) is common type for a group of related values that enables you to work with values in a type-safe way. If you are familiar with C, you will know C enumerations assign names to integers. Enumerations in Swift more flexible - you don’t have to provide a value.

```swift
enum SomeEnumeration {
    // enumeration definition goes here
}
```

Here’s an example for the four main points of a compass:

```swift
enum CompassPoint {
    case north
    case south
    case east
    case west
}
```

 > Note: Swift enums don’t have integer values set by default. In example above north, south, east, west don’t implicitly equal 0,1,2,3. Instead these enumeration cases are values in their own right of type _CompassPoint_.

Can define on a single line.

```swift
enum Planet {
    case mercury, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

Note when you define it is not plural _Planets_. Enums by convention are singular.

You can assign them to variables.

```swift
var directionToHead = CompassPoint.west
```

And then can infer type.

```swift
directionToHead = .east
```

## Matching values with Switch Statement

In Swift we match enumeration values with the _switch_ statement.

```swift
directionToHead = .south
switch directionToHead {
case .north:
    print("Lots of planets have a north")
case .south:
    print("Watch out for penguins")
case .east:
    print("Where the sun rises")
case .west:
    print("Where the skies are blue")
}
// Prints "Watch out for penguins"
```

A Swift _switch_ statement must be exhaustive. This prevents bugs and ensures cases aren’t missed. If you don’t need every case covered use can assign a _default_ one to catch cases not covered explicitly.

```swift
let somePlanet = Planet.earth
switch somePlanet {
case .earth:
    print("Mostly harmless")
default:
    print("Not a safe place for humans")
}
// Prints "Mostly harmless"
```

## Associated Values

Sometimes it is convenient to values to enum cases. These are called _associated values_.

```swift
enum Barcode {
    case upc(Int)
    case qrCode(String)
}

var productBarcode = Barcode.upc(8)
productBarcode = .qrCode("ABCDEFGHIJKLMNOP")
```

And then you can use or unpack the associated values like this.

```swift
switch productBarcode {
case .upc(let numberSystem):
    print("UPC: \(numberSystem)")
case .qrCode(let productCode):
    print("QR code: \(productCode).")
}
// Prints "QR code: ABCDEFGHIJKLMNOP."
```

### Associated Values as Tuples

Associated values in enums are tuples. Tuples are an ‘on the fly’ data structure where you can group a collection of variables together.

```swift
enum Barcode {
    case upc(Int, Int, Int, Int)
    case qrCode(String)
}
```


They way to read this is

> “Define an enumeration type called Barcode, which can take either a value of upc with an associated value of type (Int, Int, Int, Int), or a value of qrCode with an associated value of type String.”

The associated type with the upc barcode is (Int, Int, Int, Int). That’s the tuple. That’s the type.

In our case it is also the associated value with the enum. I personally don’t like this way of defining associated types with enums, because I don’t know what all those ints actually mean. 

I would rather write it like this.

```swift
enum BarcodeWithNamedParams {
    case upc(numberSystem: Int, manufacturer: Int, product: Int, check: Int)
    case qrCode(productCode: String)
}
```


## Raw Values

An alternative to _associated values_ are _raw values_. Raw values can be:

 - String
 - Character
 - Int 
 - Floating-point type


```switch
enum ASCIIControlCharacter: Character {
    case tab = "\t"
    case lineFeed = "\n"
    case carriageReturn = "\r"
}
```

These raw values are defined as type _Character_ and can be assigned _Character_ values. 

Raw values can be
Strings
Characters
Ints
Floating point (float, double)

 > Note: One difference between associated values and raw values is that associated values for an enum can change while raw values can’t.

### Implicitly Assigned Raw Values

When working with raw values, you don’t need to explicitly assign for every case. Swift will assign for you.

```swift
enum Planet: Int {
    case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
}
```

Or

```swift
enum CompassPoint: String {
    case north, south, east, west
}
```

Which you can then access as

```swift
let earthsOrder = Planet.earth.rawValue
// earthsOrder is 3

let sunsetDirection = CompassPoint.west.rawValue
// sunsetDirection is "west"
```

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


### When should I use enums?

Considering using enums any time you have predefined state. 

```swift
enum Beverage {
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

## Summary

`Enums` are much more than simple switch statements on type. In Swift, we can leverage enums in much more expressive creative way. Let me know if you find any more cool examples as I am still playing with all the different things you can do with these things.

Happy coding! 🤖
### Links that help

- [Swift Enumerations](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)

