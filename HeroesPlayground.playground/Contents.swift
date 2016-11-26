//: Playground - noun: a place where people can play

import UIKit

struct Position {
    
    var x: Int
    var y: Int
    
}

class Grid {
    
    var cells: [[String]?]
    
    init(width: Int, height: Int) {
        cells = [[String]?](repeating: nil, count: height)
        
        for i in 0..<height {
            cells[i] = [String](repeating: " ", count: width)
        }
    }
    
}

class Canvas {
    
    let grid: Grid
    var position: Position
    
    init(grid: Grid) {
        self.grid = grid
        self.position = Position(x: 0, y: 0)
    }
    
    func draw(text: String) {
        grid.cells[position.x]![position.y] = text
    }
    
    func moveTo(position: Position) {
        self.position = position
    }
    
    func clear() {
        
        for i in 0..<grid.cells.count {
            let rowCount = grid.cells[i]!.count
            for j in 0..<rowCount {
                grid.cells[i]![j] = " "
            }
        }
    }
}

class Resource {
    
    func draw(canvas: Canvas) {
        
    }
}

class ImageResource : Resource {
    
    let image: String
    
    init(image: String) {
        self.image = image
    }
    
    override func draw(canvas: Canvas) {
        canvas.draw(text: image)
    }
    
}

class GameObject {
    
    let title: String
    var position: Position
    let image: Resource
    
    init(title: String, image: Resource) {
        self.title = title
        position = Position(x: 0, y: 0)
        self.image = image
    }
    
}

enum Race {
    
    case human
    
    case undead
    
    case elves
    
    case warlock
    
    case dungeon
    
    case demon
    
    case elemental
    
}

enum Color {
    
    case black
    
    case white
    
    case blue
    
    case red
    
    case green
    
}

class Castle : GameObject {
    
    let race: Race
    var level: Int
    var color: Color
    
    init(title: String, image: Resource, race: Race) {
        self.race = race
        level = 1
        color = .red
        super.init(title: title, image: image)
    }
    
}

class Forest : GameObject {
    
    var color: Color
    
    override init(title: String, image: Resource) {
        color = .green
        super.init(title: title, image: image)
    }
}

class Rock : GameObject {
    
}

enum Sex {
    
    case male
    
    case female
    
}

class Hero : GameObject {
    
    var level: Int
    var hp: Int
    var attackDamage: Int
    
    let race: Race
    let sex: Sex
    
    init(title: String, image: Resource, race: Race, sex: Sex) {
        level = 1
        hp = 100
        attackDamage = 10
        self.race = race
        self.sex = sex
        super.init(title: title, image: image)
    }
    
}

class Warlock : Hero {
    
    var abilityPower: Int
    
    init(title: String, image: Resource, sex: Sex) {
        abilityPower = 10
        super.init(title: title, image: image, race: .warlock, sex: sex)
    }
    
}

enum MaterialType {
    
    case wood
    
    case steel
    
    case gold
    
    case gems
    
    case sulfur
    
}

class Mine : GameObject {
    
    let material : MaterialType
    
    var amount: Int
    
    init(title: String, image: Resource, material: MaterialType) {
        
        self.material = material
        amount = 0
        super.init(title: title, image: image)
    }
    
}

class GameLevel {
    
    let grid: Grid
    
    var objects: [GameObject]
    
    let width: Int
    let height: Int
    
    init(width: Int, height: Int) {
        grid = Grid(width: width, height: height)
        objects = []
        self.width = width
        self.height = height
    }
    
    func add(object: GameObject) {
        objects.append(object)
    }
    
    func draw() {
        let canvas = Canvas(grid: grid)
        canvas.clear()
        
        for obj in objects {
            canvas.moveTo(position: obj.position)
            obj.image.draw(canvas: canvas)
        }
        
        for row in grid.cells {
            for item in row! {
                print(item, terminator: "")
            }
            
            print()
        }
    }
}

let level = GameLevel(width: 5, height: 5)

for i in 0..<level.width {
    var forest = Forest(title: "Forest", image: ImageResource(image: "^"))
    forest.position = Position(x: i, y: 0)
    level.add(object: forest)
    
    forest = Forest(title: "Forest", image: ImageResource(image: "^"))
    forest.position = Position(x: i, y: level.height - 1)
    level.add(object: forest)
}

for i in 1..<level.height - 1 {
    var forest = Forest(title: "Forest", image: ImageResource(image: "^"))
    forest.position = Position(x: 0, y: i)
    level.add(object: forest)
    
    forest = Forest(title: "Forest", image: ImageResource(image: "^"))
    forest.position = Position(x: level.width - 1, y: i)
    level.add(object: forest)
}

var object: GameObject = Hero(title: "HeroOne", image: ImageResource(image: "+"), race: .human, sex: .female)
object.position = Position(x: 2, y: 2)
level.add(object: object)

object = Warlock(title: "Warlock", image: ImageResource(image: "-"), sex: .male)
object.position = Position(x: 1, y: 1)
level.add(object: object)

object = Mine(title: "Mine", image: ImageResource(image: "*"), material: .gold)
object.position = Position(x: 3, y: 3)
level.add(object: object)

level.draw()



