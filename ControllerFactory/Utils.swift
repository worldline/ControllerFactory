//
//  Utils.swift
//  ControllerFactory
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit

extension UIViewController {
    @objc func dismissModalAnimated() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension String {
    
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
}

extension Bundle {
    func retrieveAllViewControllers() -> [ControllerName] {

        guard let bundlePath = self.executablePath else { return [] }

        var size: UInt32 = 0

        var viewControllers = [ControllerName]()

        let classes = objc_copyClassNamesForImage(bundlePath, &size)

        for index in 0..<size {
            if let className = classes?[Int(index)],
                let name = NSString.init(utf8String:className) as String?,
                NSClassFromString(name) is UIViewController.Type
            {
                let split = name.components(separatedBy: ".")
                let displayValue = split.count > 1 ? split[1] : split[0]

                viewControllers.append(ControllerName(className: name, displayValue: displayValue))
            }
        }

        return viewControllers
    }
}

func classFromControllerName(_ controllerName: ControllerName) -> AnyClass? {
    
    let cls: AnyClass? = NSClassFromString(controllerName.className)
    
    return cls
}
