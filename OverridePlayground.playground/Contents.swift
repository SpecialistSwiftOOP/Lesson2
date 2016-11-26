//: Playground - noun: a place where people can play

import UIKit

class Media {
    
    var name = "Media"
    
    func printMedia() {
        print(name)
    }
}

class DigitalMedia : Media {
    
    var signature = "Signature"
    
    override func printMedia() {
        print("Name = \(name) and signature = \(signature)")
    }
    
}

let media: Media = DigitalMedia()
media.printMedia()

var obj: Media! = nil
obj = media
obj.name