//: Playground - noun: a place where people can play

class Storage {
    
    static let MaxCapacity = 200
    
    var localStorage: [Int]
    
    init?(capacity: Int) {
        
        /*if capacity < Storage.MaxCapacity {
            localStorage = [Int](repeating: 0, count: capacity)
        } else {
            return nil
        }*/
        
        guard capacity < Storage.MaxCapacity else {
            return nil
        }
        
        localStorage = [Int](repeating: 0, count: capacity)
    }
    
}

enum MyEnum {
    
    case item(number: Double)
    
    case itemTwo(str: String)
    
}
