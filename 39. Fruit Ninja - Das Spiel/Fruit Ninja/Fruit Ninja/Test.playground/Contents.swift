import UIKit

var str = "Hello, playground"

var stringArray = ["Apfel", "Apfel Grün", "Trauben", "Orange"]

print(stringArray.count) // 4 Elemente

let numberN = Int(arc4random_uniform(UInt32(stringArray.count))) // Zahl zwischen 0 - 3

print(numberN)
