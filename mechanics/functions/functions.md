# Functions

Functions look different in Swift when compared to other languages. But they have some very nice features that enable you to write really clear, concise, expressive code. Let’s take a look now at what makes functions so special in Swift, and some of their more unique properties.

## Named Parameters

Named parameters are what we call the descriptors used to describe the names of variables defining our functions.

```swift
func greet(person: String, day: String) -> String {
    return "Hello \(person), today is \(day)."
}
```

This method has two named parameters - `person` and `day`. And you invoke methods in Swift by prefixing them in front of method values like this.

```swift
greet(person: "Bob", day: "Tuesday")
```

Knowing what this is called, `named parameter` is handy. Because another thing that Swift allows you to do is declare another type of label descriptor to make your methods even more expressive. Something called an argument label.

## Argument Labels

```swift
func greet(person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
```

See that word `from` in front of the named label `hometown`? That is called an argument label. Argument labels are labels that you use when calling a function:

```swift
greet(person: "Bill", from: "Cupertino")
```

But it is the named labels that are used within the function itself when processing. This can be confusing at first (not really knowing which label or parameter name to use and where). But having this option leads to some really nice expressive coding options. 

```swift
func greet(visitor person: String, from hometown: String) -> String {
    return "Hello \(person)!  Glad you could visit from \(hometown)."
}
greet(visitor: "Bill", from: "Cupertino")
```

And to help you remember the names of these things just remember this.

```swift
func someFunction(argumentLabel parameterName: Int) {
    // In the function body, parameterName refers to the argument value
    // for that parameter.
}
```

## Omitting Argument Labels

If you don’t want an argument label for a parameter, write an underscore (_) instead of an explicit argument label for that parameter.

```swift
func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
    // In the function body, firstParameterName and secondParameterName
    // refer to the argument values for the first and second parameters.
}
someFunction(1, secondParameterName: 2)
```

If a parameter has an argument label, the argument must be labeled when you call the function.

## Default Parameter Values

```swift
func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
    // If you omit the second argument when calling this function, then
    // the value of parameterWithDefault is 12 inside the function body.
}
someFunction(parameterWithoutDefault: 3, parameterWithDefault: 6) // parameterWithDefault is 6
someFunction(parameterWithoutDefault:
```

## Variadic Parameters

A *variadic parameter* accepts zero or more values of a specified type. Means that the parameter can be passed a varying number of input values when the function is called. Write by inserting three period characters (...) after the parameter’s type name.

The values pass are made available within the function body as an array of the appropriate type. For example a parameter with the name *numbers* and a type `Double…` is made available within the function’s body as a constant array.

```swift
func arithmeticMean(_ numbers: Double...) -> Double {
    var total: Double = 0
    for number in numbers {
        total += number
    }
    return total / Double(numbers.count)
}
arithmeticMean(1, 2, 3, 4, 5)
```

> Note 
> A function may have at most one variadic parameter.


### Links that help

- [Swift Functions](https://docs.swift.org/swift-book/LanguageGuide/Functions.html)


