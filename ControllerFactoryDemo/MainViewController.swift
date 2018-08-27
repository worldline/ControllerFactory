//
//  MainViewController.swift
//  ControllerFactoryDemo
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit
import ControllerFactory

class MainViewController: UIViewController {

    @IBAction func showControllerFactory(_ sender: Any) {
        
        ControllerFactory.printControllers()
        
        let controllerFactory = ControllerFactory.instantiate(bundle: Bundle.main, excludedViewControllers: ["BaseViewController"])
        
        show(controllerFactory, sender: self)
    }
}

extension MainViewController: ControllerFactoryInstantiable {
    static func initForControllerFactory() -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainViewController")
    }
}
