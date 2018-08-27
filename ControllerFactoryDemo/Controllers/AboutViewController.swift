//
//  AboutViewController.swift
//  ControllerFactoryDemo
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit
import ControllerFactory

class AboutViewController: BaseViewController {

}

extension AboutViewController: ControllerFactoryCompliant {
    
    func prepareForControllerFactory() {
        print("Prepared for ControllerFactory")
    }
}
