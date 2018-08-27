//
//  ControllerName.swift
//  ControllerFactory
//
//  Created by Benoit Caron on 09/05/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit

class ControllerName: NSObject, NSCoding {

    let className: String
    let displayValue: String
    
    init(className: String, displayValue: String) {
        self.className = className
        self.displayValue = displayValue
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? ControllerName else { return false }
        return self.className == object.className
    }
    
    required convenience init(coder aDecoder: NSCoder) {
        let className = aDecoder.decodeObject(forKey: "className") as! String
        let displayValue = aDecoder.decodeObject(forKey: "displayValue") as! String
        self.init(className: className, displayValue: displayValue)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(className, forKey: "className")
        aCoder.encode(displayValue, forKey: "displayValue")
    }
    
    private func serialized() -> Data? {
        return NSKeyedArchiver.archivedData(withRootObject: self)
    }
    
    private static func deserialize(data: Data) -> ControllerName? {
        return NSKeyedUnarchiver.unarchiveObject(with: data) as? ControllerName
    }
    
    func saveToUserDefaults() {
        UserDefaults.standard.set(self.serialized(), forKey: Constants.controller)
    }
    
    static func loadFromUserDefaults() -> ControllerName? {
        guard let data = UserDefaults.standard.data(forKey: Constants.controller) else { return nil }
        return ControllerName.deserialize(data: data)
    }
}
