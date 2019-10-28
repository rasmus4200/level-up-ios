# Functions Types

Every function in Swift has a _function type_, made up of the parameter types and the return type of the function.

```swift
func addTwoInts(_ a: Int, _ b: Int) -> Int {
    return a + b
}
func multiplyTwoInts(_ a: Int, _ b: Int) -> Int {
    return a * b
}
```

These two functions two two _Int_ values, and return an _Int_ value. The type of both of these values is `(Int, Int) -> Int`. 

Even functions that have no input views, and no return type have a type.

```swif
func printHelloWorld() {
    print("hello, world")
}
```

The type of this function is `() -> Void`.

## Using Function Types

You use function types just like any other types in Swift. For example you can create a function type, assign it to a variable, and then save or invoke it later like this:

```swift
var mathFunction: (Int, Int) -> Int = addTwoInts
…
print("Result: \(mathFunction(2, 3))")
```

## Function Types as Parameter Types

You can use function types such as _(Int, Int) -> Int_ as a parameter type for another function.

```swift
func printMathResult(_ mathFunction: (Int, Int) -> Int, _ a: Int, _ b: Int) {
    print("Result: \(mathFunction(a, b))")
}
printMathResult(addTwoInts, 3, 5)
// Prints "Result: 8"
```

## Function Types as Return Types

You can use a function type as a return type of another function. You do this by writing a complete function type immediately after the return arrow (->) of the returning function.

Here are two simple functions each with type _(Int) -> Int_.

```swift
func stepForward(_ input: Int) -> Int {
    return input + 1
}
func stepBackward(_ input: Int) -> Int {
    return input - 1
}
```

And here is a function called `chooseStepFunction(backward:), whose return type is _(Int) -> Int_. And it returns either the _stepForward_ or _stepBackward_ function based on the Boolean parameter passed in.

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    return backward ? stepBackward : stepForward
}
```

And to step backward, or count down to zero, you could do something like this:

```swift
var currentValue = 3
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)

print("Counting to zero:")
// Counting to zero:
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// 3...
// 2...
// 1...
// zero!
```

Here we are setting up a conditional around `currentValue > 0`, passing that into our _chooseStepFunction_, and then taking the returned function and executing it (which in turn decrements the counter) and lowers the _currentValue_ again.

This is confusing! But cool. We are basically returning functions, executing them, storing the returned value of the executed function, and the using the result to repeat the process over and over again until _currentValue != 0_.

## Nested Functions

You can nest functions in Swift. Another way to do the above count backwards logic would be to nest or embed the _stepForward_, _stepBackward_ functions within the _chooseStepFunction_ like this.

```swift
func chooseStepFunction(backward: Bool) -> (Int) -> Int {
    func stepForward(input: Int) -> Int { return input + 1 }
    func stepBackward(input: Int) -> Int { return input - 1 }
    return backward ? stepBackward : stepForward
}
var currentValue = -4
let moveNearerToZero = chooseStepFunction(backward: currentValue > 0)
// moveNearerToZero now refers to the nested stepForward() function
while currentValue != 0 {
    print("\(currentValue)... ")
    currentValue = moveNearerToZero(currentValue)
}
print("zero!")
// -4...
// -3...
// -2...
// -1...
// zero!
```










### Links that help

- [Swift Functions](https://docs.swift.org/swift-book/LanguageGuide/Functions.html)


