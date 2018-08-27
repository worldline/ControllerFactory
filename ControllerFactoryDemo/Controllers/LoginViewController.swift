//
//  LoginViewController.swift
//  ControllerFactoryDemo
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit
import ControllerFactory

class LoginViewController: BaseViewController {
    var useCase: String = ""
}

extension LoginViewController: ControllerFactoryUseCaseCompliant {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.titleLabel.text = self.titleLabel.text.map { "\($0)\n\(useCase)" }
    }
    
    static func getUseCases() -> [String] {
        return ["Not Enrolled", "Enrolled"]
    }
    
    func prepareForControllerFactory(useCase: String) {
        print("Use case: \(useCase)")

        self.useCase = useCase
    }
}
