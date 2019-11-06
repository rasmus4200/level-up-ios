let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

// Closure as a function
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
let reversedNames1 = names.sorted(by: backward)

// Closure inlined
let reversedNames2 = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 > s2
})

// Inferring type from context
let reversedNames3 = names.sorted(by: { s1, s2 in return s1 > s2 } )

// Implicit return from single-expression
let reversedNames4 = names.sorted(by: { s1, s2 in s1 > s2 } )

// Shorthand $0 $1
let reversedNames5 = names.sorted(by: { $0 > $1 } )

// Operator methods that match our function signature
let reversedNames6 = names.sorted(by: >)

// Trailing closure
let reversedNames7 = names.sorted() { $0 > $1 }

// Capturing values
func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)

incrementByTen() // 10
incrementByTen() // 20
incrementByTen() // 30

// Closures are reference types
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen() // 40

incrementByTen() // 50

// Escaping closures
func escapingClosure(completionHandler: @escaping () -> Void) {}
func nonescapingClosure(closure: () -> Void) {}

class SomeClass {
    var x = 10
    func doSomething() {
        escapingClosure { self.x = 100 }
        nonescapingClosure { x = 200 }
    }
}

// Autoclosure

var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
customersInLine.count // 5

let customerProvider = { customersInLine.remove(at: 0) } // auto closure
customersInLine.count // 5

"Now serving \(customerProvider())!"
customersInLine.count // 4

// Also delayed execution - explicity

func serve(customer customerProvider: () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: { customersInLine.remove(at: 0) } ) // no args -> returns a string

// as an autoclosure

func serve(customer customerProvider: @autoclosure () -> String) {
    print("Now serving \(customerProvider())!")
}
serve(customer: customersInLine.remove(at: 0)) // nothing happen at the call site, but it all happens might happen in the implementation

// really an autoclosure is really deferring the evaluation of arguments till later
// i.e. here you are passing an argument, but it really isn't being executed until later
// that's what makes these things hard to read

// difference is by marking as @autoclosure we can call as it it only took a string
// think of it like this - autoclosure automatically closes a function and returns its type
// when you use in a function, you need not call as full function - you can just call the return type

// frameworks use these a lot... but avoid using... makes your code hard to read

// try writing if...

//func jif(_ condition: Bool, _ trueBranch: @autoclosure () -> Void, _ falseBranch: @autoclosure () -> Void) {
//    if condition {
//        trueBranch()
//    } else {
//        falseBranch()
//    }
//}

// make these autoclosures so they are not instantly evaluated when jif is called

//jif(1 == 1, print("True"), print("False")) // true!

// now if we remove the autoclosures...the signature needs to change

func jif(_ condition: Bool, _ trueBranch: () -> Void, _ falseBranch: () -> Void) {
    if condition {
        trueBranch()
    } else {
        falseBranch()
    }
}

jif(1 == 1, { print("True") }, { print("False") }) // true!

// the point: allows you do define functions that don't immediately evaluate their arguments when they are called
// you can always do an autoclosure on your own, by wrapping a func in {}
// autoclosure is sugar - it lets' you pass in a func without the func parms, and instead just evualte the output...
// it's a convenience things that framework authors use to make their API easier to read, work with and call.
// it is confusingl... but just understand all it does is let you define a closure as a variable and evaluate later...

// where people use this is in creating their own custom operators...

// https://www.swiftbysundell.com/articles/using-autoclosure-when-designing-swift-apis/
