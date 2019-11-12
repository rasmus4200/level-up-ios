# Enumerations

https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html

- A common type for a group of related values.
  - Enables you to work with values in a type-safe way
 - If familiar with C, you will know C enumerations assign names to integers
 - Enumerations in Swift more flexible - don’t have to provide a value.
 
- If value (known as _raw_ value) is provided, value can be a 
 - String
 - Character
 - Int 
 - Floating-point type

- Enumerations first class citizens
 - Adopt many features traditionally supported only by classes
 - Computed properties - provide additional information about enum current value
 - Instance methods - provide functionality related to value it represents
 - Initializers - provide initial case value
 - Extended - provide functionality beyond original implementation
 - Protocols - conform to interfaces to provide standard functionality

Syntax

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

## Raw Values

An alternative to _associated values_ are _raw values_.

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

### Links that help

- [Swift Enumerations](https://docs.swift.org/swift-book/LanguageGuide/Enumerations.html)

