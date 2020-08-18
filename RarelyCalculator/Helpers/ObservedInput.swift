//
//  ObservedResult.swift
//  RarelyCalculator
//
//  Created by liasica on 2020/08/17.
//

import Foundation

struct FormulaError: LocalizedError, Equatable {
    private var description: String!
    
    init(_ description: String) {
        self.description = description
    }
    
    var errorDescription: String? {
           return description
       }
    
    public static func ==(lhs: FormulaError, rhs: FormulaError) -> Bool {
           return lhs.description == rhs.description
       }
}

extension FormulaError {
    static let denominatorIsZero = FormulaError(NSLocalizedString("Denominator can't be zero", comment: ""))
    static let notNumber = FormulaError(NSLocalizedString("Not number", comment: ""))
}

enum AccumulatorType: UInt {
    case number = 1
    case symbol = 2
}

struct Accumulator {
    var value: String
    var dataType: AccumulatorType
    
    init(_ value: String, _ type: AccumulatorType) {
        self.value = value == "" ? "0" : value
        self.dataType = type
    }
}

// math functions
func add(_ a: BDouble, _ b: BDouble) -> BDouble {
    return a + b
}

func sub(_ a: BDouble, _ b: BDouble) -> BDouble {
    return a - b
}

func mul(_ a: BDouble, _ b: BDouble) -> BDouble {
    return a * b
}

func div(_ a: BDouble, _ b: BDouble) -> BDouble {
    return a / b
}

typealias MathType = (_ a: BDouble, _ b: BDouble) -> BDouble

let mathOps: [String: MathType] = [
    "+": add,
    "-": sub,
    "×": mul,
    "÷": div
]

class ObservedInput: ObservableObject {
    let objectWillChange = ObjectWillChangePublisher()
    
    // 暂存数据
    @Published var storage: [Accumulator] = []
    
    // 当前输入
    @Published var entry: String = "" {
        willSet {
            if newValue != "" {
                self.result = ""
            }
            objectWillChange.send()
        }
    }
    
    // 计算结果
    @Published var result: String = ""
    
    func entryText() -> String {
        let res = self.result
        let entry = self.entry
        return res != "" ? res : (entry == "" ? "0" : entry)
    }
    
    func clearText() -> String {
        if self.entry != "" {
            return "C"
        } else if self.storage.count > 0 {
            return "CE"
        } else {
            return "AC"
        }
    }
    
    // 暂存运算符
    func store(symbol: String) {
        let entry = self.entry
        
        if entry != "" {
            // 将输入的数字进行暂存
            storage.append(Accumulator(entry, .number))
            // 暂存后清除输入数据
            self.entry = ""
        } else if let last = storage.last {
            if last.dataType == .symbol {
                storage.removeLast()
            }
        } else {
            self.result = FormulaError.notNumber.errorDescription!
            return
        }
        
        self.storage.append(Accumulator(symbol == "/" ? "÷" : (symbol == "*" ? "×" : symbol), .symbol))
    }
    
    func minus() {
        self.doDeformEntry(-1)
    }
    
    func percentage() {
        self.doDeformEntry(100)
    }
    
    func doDeformEntry(_ num: Int) {
        let entry = self.entry == "" ? "0" : self.entry
        var result: String = ""
        
        do {
            let r = try self.doMath(BDouble(entry)!, BDouble(num), op: "÷")
            result = r.description
            self.storage.append(Accumulator(result, .number))
        } catch let err as FormulaError {
            result = err.errorDescription ?? NSLocalizedString("Error", comment: "")
        } catch {
            result = NSLocalizedString("Calculation error", comment: "")
        }
        self.entry = ""
        self.result = result
    }
    
    func clear() {
        if self.entry != "" {
            self.entry = "" // C
        } else if self.storage.count > 0 {
            self.storage.removeLast() // CE
        } else {
            self.clearAll() // AC
        }
    }
    
    func clearAll() {
        self.entry = ""
        self.result = ""
        self.storage = []
    }
    
    func doMath(_ a: BDouble, _ b: BDouble, op: String) throws -> BDouble {
        if op == "÷" && b.description == "0" {
            // 抛出错误
            throw FormulaError.denominatorIsZero
        }
        let mathFunc = mathOps[op]
        return mathFunc!(a, b)
    }
    
    func doEqual() throws -> String {
        var storage = self.storage
        let entry = self.entry
        if entry == "" {
            if let last = storage.last, last.dataType == .symbol {
                storage.removeLast()
            }
        } else {
            storage.append(Accumulator(self.entry, .number))
        }
        var cnt = storage.count
        
        var n = 0
        var a: BDouble?
        var b: BDouble?
        var mathOp: String? // 运算符
        
        // 1 + 10 + 20 × 10 ÷ 5 - 20
        while n < cnt {
            let accumulator = storage[n]
            if accumulator.dataType == .number {
                if a == nil {
                    a = BDouble(accumulator.value)
                } else {
                    b = BDouble(accumulator.value)
                    // 判断下一个运算符
                    if n < storage.count - 1 {
                        let symbol = storage[n + 1]
                        if symbol.value == "+" || symbol.value == "-" {
                            let r = try self.doMath(a!, b!, op: symbol.value)
                            print(n, "->", "a =", a!.description, symbol.value, b!.description, "=", r.description)
                            a = r
                            mathOp = nil
                            b = nil
                        } else {
                            // 获取下一个数字
                            let v = symbol.value
                            let _num = storage[n + 2]
                            if v == "/", _num.value == "0" {
                                // 抛出错误
                                throw FormulaError.denominatorIsZero
                            }
                            let _b = BDouble(_num.value)
                            let _mathFunc = mathOps[v]
                            print(n, "->", "b =", b!.description, symbol.value, _b!.description, "=", _mathFunc!(b!, _b!).description)
                            // b = _mathFunc!(b!, _b!)
                            storage[n].value = _mathFunc!(b!, _b!).description
                            storage.remove(at: n + 1)
                            storage.remove(at: n + 1)
                            cnt = storage.count
                            continue
                        }
                    }
                }
            } else {
                if mathOp == nil {
                    mathOp = accumulator.value
                }
            }
            
            n += 1
        }
        
        if a != nil && b != nil && mathOp != nil {
            let r = try self.doMath(a!, b!, op: mathOp!)
            print(n, "->", "a =", a!.description, mathOp!, b!.description, "=", r.description)
            a = r
        }
        
        return a!.description
    }
    
    // 运算
    func equal() {
        if self.storage.count < 2 {
            return
        }
        
        var result: String?
        do {
            result = try doEqual()
        } catch let err as FormulaError {
            result = err.errorDescription ?? NSLocalizedString("Calculation error", comment: "")
        } catch {
            result = NSLocalizedString("Calculation error", comment: "")
        }
        
        self.storage = []
        self.result = result!
        self.entry = ""
    }
}
