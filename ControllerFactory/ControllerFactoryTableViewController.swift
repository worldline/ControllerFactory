//
//  ControllerFactoryTableViewController.swift
//  ControllerFactory
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit

private enum Sections: String {
    
    case controller = "Controller"
    case useCases = "Use cases"
    case action = "Action"
}

public class ControllerFactoryTableViewController: UITableViewController {
    
    var bundle = Bundle.main
    var excludedControllers = [String]()
    
    fileprivate var sections: [Sections] 	{
        get {
            if useCases.isEmpty {
                return [.controller, .action]
            }
            return [.controller, .useCases, .action]
        }
    }
    
    fileprivate var label = ""
    fileprivate var useCase: String? = nil
    fileprivate var useCases = [String]()
    
    fileprivate var viewController: UIViewController? = nil
    fileprivate var controllerName: ControllerName? = nil
    
    fileprivate var controllerClass: UIViewController.Type? {
        get {
            guard let controllerName = controllerName else { return nil }
            return classFromControllerName(controllerName) as? UIViewController.Type
        }
    }
    
    public final override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Controller factory"
    }
    
    public final override func viewWillAppear(_ animated: Bool) {
        
        reset()
        configureData()
        tableView.reloadData()
    }
    
    private func reset() {
        label           = ""
        useCase         = nil
        useCases        = [String]()
        viewController  = nil
        controllerName  = ControllerName.loadFromUserDefaults()
    }
    
    private func configureData() {
        
        guard let controllerName = controllerName else { return }
        
        if let useCases = (controllerClass.self as? ControllerFactoryUseCaseInstantiable.Type)?.getUseCases() {
            self.useCases = useCases
        }
        else if let useCases = (controllerClass.self as? ControllerFactoryUseCaseCompliant.Type)?.getUseCases() {
            self.useCases = useCases
        }
        else {
            UserDefaults.standard.set(nil, forKey: Constants.useCase)
        }
        
        label = controllerName.displayValue
        useCase = UserDefaults.standard.string(forKey: Constants.useCase)
    }
    
    fileprivate func getController() -> UIViewController? {
        
        if let useCase = useCase,
            let controllerClass = controllerClass as? ControllerFactoryUseCaseInstantiable.Type {
            viewController = controllerClass.initForControllerFactory(useCase: useCase)
        }
        else if let controllerClass = controllerClass as? ControllerFactoryInstantiable.Type {
            viewController = controllerClass.initForControllerFactory()
        }
        else {
            viewController = controllerClass?.init()
        }
        
        if let useCase = useCase {
            (viewController as? ControllerFactoryUseCaseCompliant)?.prepareForControllerFactory(useCase: useCase)
        }
        else {
            (viewController as? ControllerFactoryCompliant)?.prepareForControllerFactory()
        }
        
        return viewController
    }
    
    fileprivate func pushViewController() {
        
        guard let controller = getController() else { return }
        navigationController?.pushViewController(controller, animated: true)
    }
    
    fileprivate func presentViewController() {
        
        guard let controller = getController() else { return }
        present(controller, animated: true, completion: nil)
    }
    
    fileprivate func presentDismissableViewController() {
        
        guard let controller = getController() else { return }
        
        let navigationController = UINavigationController(rootViewController: controller)
        controller.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Dismiss", style: .done, target: controller, action: #selector(dismissModalAnimated))
        self.present(navigationController, animated: true, completion: nil)
    }
    
    public final override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let controller = segue.destination as? ControllerListTableViewController {
            controller.bundle = bundle
            controller.excludedControllers = excludedControllers
        }
    }
}

//MARK: UITableViewDataSource

extension ControllerFactoryTableViewController {
    
    public final override func numberOfSections(in tableView: UITableView) -> Int {
        
        return sections.count
    }
    
    public final override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return sections[section].rawValue
    }
    
    public final override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch sections[section] {
        case .controller:
            return 1
        case .useCases:
            return useCases.count
        case .action:
            return 3
        }
    }
    
    public final override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        cell.textLabel?.textAlignment = .left
        cell.accessoryType = .none
        
        switch sections[indexPath.section] {
        case .controller:
            cell.textLabel?.text = label
            cell.accessoryType = .disclosureIndicator
        case .useCases:
            let useCase = useCases[indexPath.row]
            cell.textLabel?.text = useCase
            if useCase == self.useCase {
                cell.accessoryType = .checkmark
            }
        case .action:
            switch indexPath.row {
            case 0:
                cell.textLabel?.text = "Push view controller"
            case 1:
                cell.textLabel?.text = "Present view controller"
            case 2:
                cell.textLabel?.text = "Present dismissable view controller"
            default:
                break
            }
            cell.textLabel?.textAlignment = .center
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension ControllerFactoryTableViewController {
    
    public final override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch sections[indexPath.section] {
        case .controller:
            UserDefaults.standard.removeObject(forKey: Constants.useCase)
            performSegue(withIdentifier: "ControllerListSegue", sender: self)
        case .useCases:
            useCase = useCases[indexPath.row]
            UserDefaults.standard.set(useCase, forKey: Constants.useCase)
            for i in 0..<useCases.count {
                let cell = tableView.cellForRow(at: IndexPath(row: i, section: indexPath.section))
                cell?.accessoryType = (i == indexPath.row) ? .checkmark : .none
            }
        case .action:
            switch indexPath.row {
            case 0:
                pushViewController()
            case 1:
                presentViewController()
            case 2:
                presentDismissableViewController()
            default:
                break
            }
        }
    }
}
