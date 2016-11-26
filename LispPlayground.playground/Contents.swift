//: Playground - noun: a place where people can play

import UIKit

class Lexer {
    
    enum Lexem {
        
        case operation(lexem: String)
        
        case number(number: Double)
        
        case openBracket
        
        case closeBracket
    }
    
    let code: String
    let delimiters: [Character] = [ " ", "\t", "\n"]
    let brackets: [Character] = [ "(", ")" ]
    
    var position: Int = 0
    
    init(lispCode: String) {
        code = lispCode
    }
    
    func next() -> Lexem? {
        
        var result: Lexem? = nil
        
        if position < code.characters.count {
            var lexem = ""
            
            var index = code.index(code.startIndex, offsetBy: position)
    
            while delimiters.contains(code[index]) {
                position += 1
                
                if position < code.characters.count {
                    index = code.index(after: index)
                } else {
                    break
                }
            }
            
            while !delimiters.contains(code[index]) && position < code.characters.count {
                let symbol = code[index]
                lexem += String(symbol)
                position += 1
                
                if brackets.contains(symbol) {
                    if lexem.characters.count > 1 {
                        position -= 1
                        lexem.characters.removeLast()
                    }
                    break
                }
                
                if position < code.characters.count {
                    index = code.index(after: index)
                } else {
                    break
                }
            }
            
            switch lexem {
            case "(":
                result = .openBracket
                
            case ")":
                result = .closeBracket
                
            case _ where Double(lexem) == nil:
                result = .operation(lexem: lexem)
                
            case _ where Double(lexem) != nil:
                result = .number(number: Double(lexem)!)
                
            default:
                break
            }
        }
        
        return result
        
    }
    
}

class Node {
    
    var children: [Node] = []
    
    func calculate() -> Double {
        return 0
    }
    
}

class ValueNode : Node {
    
    var value: Double
    
    init(value: Double) {
        self.value = value
    }
    
    override func calculate() -> Double {
        return value
    }
    
}

class OperationNode : Node {
    
    let action: ([Double]) -> Double
    
    init(action: @escaping ([Double]) -> Double) {
        self.action = action
    }
    
    override func calculate() -> Double {
        
        var operands = [Double]()
        
        for node in children {
            operands.append(node.calculate())
        }
        
        return action(operands)
    }
}

class SyntaxAnalyzer {
    
    static let Plus: ([Double]) -> Double = {
        operands in
        
        var result = 0.0
        
        for operand in operands {
            result += operand
        }
        
        return result
    }
    
    static let Minus: ([Double]) -> Double = {
        operands in
        
        var result = 0.0
        
        for operand in operands {
            result -= operand
        }
        
        return result
    }
    
    static let Multiply: ([Double]) -> Double = {
        operands in
        
        var result = 1.0
        
        for operand in operands {
            result *= operand
        }
        
        return result
    }
    
    var lexer: Lexer
    
    var root: Node!
    
    init(lispCode: String) {
        lexer = Lexer(lispCode: lispCode)
    }
    
    func parse() {
        
        if assert(lexem: .openBracket) {
            root = createNode()
        } else {
            print("Cannot parse statement!")
        }
        
    }
    
    let operationMap = [ "+" : SyntaxAnalyzer.Plus,
                         "-" : SyntaxAnalyzer.Minus,
                         "*" : SyntaxAnalyzer.Multiply ]
    
    func createNode() -> Node {
        
        let operation = lexer.next()!
        
        var lexem = lexer.next()
        
        var node: Node!
        
        switch operation {
            
        case let .operation(value):
            node = OperationNode(action: operationMap[String(value)]!)
            
        default:
            return ValueNode(value: 0)
            
        }
        
        cycle: while lexem != nil {
            
            switch lexem! {
                
            case .closeBracket:
                break cycle
                
            case .openBracket:
                node.children.append(createNode())
                
            case let .number(value):
                node.children.append(ValueNode(value: value))
                
            default:
                break
            }
            
            lexem = lexer.next()
            
        }
        
        return node
    }
    
    func assert(lexem: Lexer.Lexem) -> Bool {

        var result = false
        
        if let newLexem = lexer.next() {
            
            switch (newLexem, lexem) {
                
            case let (.number(value), .number(value2)):
                result = value == value2
                
            case (.openBracket, .openBracket), (.closeBracket, .closeBracket):
                result = true
                
            case let (.operation(value), .operation(value2)):
                result = value == value2
                
            default:
                break
            }
            
        }
        
        return result
        
    }
}

let syntax = SyntaxAnalyzer(lispCode: "(+ 7 (* 5 2))")
syntax.parse()
syntax.root.calculate()
