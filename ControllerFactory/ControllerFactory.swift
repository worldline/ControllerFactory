//
//  ControllerFactory.swift
//  ControllerFactory
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit

@objc public protocol ControllerFactoryInstantiable {
    static func initForControllerFactory() -> UIViewController
}

@objc public protocol ControllerFactoryUseCaseInstantiable {
    static func getUseCases() -> [String]
    static func initForControllerFactory(useCase: String) -> UIViewController
}

@objc public protocol ControllerFactoryCompliant {
    func prepareForControllerFactory()
}

@objc public protocol ControllerFactoryUseCaseCompliant {
    static func getUseCases() -> [String]
    func prepareForControllerFactory(useCase: String)
}

@objcMembers public class ControllerFactory: NSObject {
    
    private static let defaultBundle = Bundle.main
    private static let defaultExcludedControllers = [String]()
    
    // We must have all methods explicitely declared instead of using default values for objective c exposure
    
    public static func instantiate() -> ControllerFactoryTableViewController {
        
        return ControllerFactory.instantiate(bundle: ControllerFactory.defaultBundle, excludedViewControllers: [String]())
    }
    
    public static func instantiate(bundle: Bundle) -> ControllerFactoryTableViewController {
        
        return ControllerFactory.instantiate(bundle: bundle, excludedViewControllers: ControllerFactory.defaultExcludedControllers)
    }
    
    public static func instantiate(excludedViewControllers: [String]) -> ControllerFactoryTableViewController {
        
        return ControllerFactory.instantiate(bundle: ControllerFactory.defaultBundle, excludedViewControllers: excludedViewControllers)
    }
    
    public static func instantiate(bundle: Bundle, excludedViewControllers: [String]) -> ControllerFactoryTableViewController {
        let controller = UIStoryboard(name: "Storyboard", bundle: Bundle(for: ControllerFactory.self)).instantiateViewController(withIdentifier: "ControllerFactoryTableViewController") as! ControllerFactoryTableViewController

        controller.bundle = bundle
        controller.excludedControllers = excludedViewControllers

        return controller
    }
    
    // Use this method to select help you choose the controllers to exclude
    public static func printControllers() {
        print(ControllerFactory.defaultBundle.retrieveAllViewControllers()
            .map { $0.className }
            .joined(separator:"\n"))
    }
    
    // Use this method to select help you choose the controllers to exclude
    public static func printControllers(bundle: Bundle) {
        print(bundle.retrieveAllViewControllers()
            .map { $0.className }
            .joined(separator:"\n"))
    }
}
