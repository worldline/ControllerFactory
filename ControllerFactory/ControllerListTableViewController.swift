//
//  ControllerListTableViewController.swift
//  ControllerFactory
//
//  Created by Benoit Caron on 16/01/2018.
//  Copyright © 2018 worldline. All rights reserved.
//

import UIKit
import ObjectiveC

class ControllerListTableViewController: UITableViewController {
    
    var searchController: UISearchController!
    
    var bundle = Bundle.main
    var excludedControllers = [String]()
    
    var savedController = ControllerName.loadFromUserDefaults()
    
    var dataSource = [String: [ControllerName]]()
    var dataSourceSectionTitles: [String] { get { return dataSource.keys.sorted() } }
    
    var filteredDataSource = [String: [ControllerName]]()
    var filteredDataSourceSectionTitles: [String] { get { return filteredDataSource.keys.sorted() } }
    
    var currentDataSource: [String: [ControllerName]] { get { return shouldShowSearchResults ? filteredDataSource : dataSource } }
    var currentDataSourceSectionTitles: [String] { get { return shouldShowSearchResults ? filteredDataSourceSectionTitles : dataSourceSectionTitles } }
    
    var shouldShowSearchResults = false
    
    let indexTitles = ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Controller list"
        
        configureDataSource()
        configureSearchController()
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false

        searchController.searchBar.placeholder = "Search controllers..."
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()

        tableView.tableHeaderView = searchController.searchBar
    }
    
    func configureDataSource() {
        
        let viewControllers = retrieveWantedViewControllers(in: bundle)
        viewControllers.forEach { dataSource[$0.displayValue[0]] = [ControllerName]() }
        viewControllers.forEach { dataSource[$0.displayValue[0]]?.append($0) }
        
        if let savedController = savedController,
            let section = dataSourceSectionTitles.index(of: savedController.displayValue[0]),
            let index = dataSource[savedController.displayValue[0]]?.index(of: savedController) {
            let indexPath = IndexPath(row: index, section: section)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
        
        tableView.reloadData()
    }
    
    func retrieveWantedViewControllers(in bundle: Bundle) -> [ControllerName] {
        
        // Demo controllers
        //        return [
        //            ControllerName(className: "AboutViewController", displayValue: "AboutViewController"),
        //            ControllerName(className: "AccountViewController", displayValue: "AccountViewController"),
        //            ControllerName(className: "SettingsViewController", displayValue: "SettingsViewController"),
        //            ControllerName(className: "AuthenticationViewController", displayValue: "AuthenticationViewController"),
        //            ControllerName(className: "EnrolementStep1ViewController", displayValue: "EnrolementStep1ViewController"),
        //            ControllerName(className: "EnrolementStep2ViewController", displayValue: "EnrolementStep2ViewController"),
        //            ControllerName(className: "EnrolementStep3ViewController", displayValue: "EnrolementStep3ViewController"),
        //            ControllerName(className: "MessageViewController", displayValue: "MessageViewController"),
        //            ControllerName(className: "DocumentsViewController", displayValue: "DocumentsViewController"),
        //            ControllerName(className: "SplashScreenViewController", displayValue: "SplashScreenViewController"),
        //            ControllerName(className: "BaseViewController", displayValue: "BaseViewController"),
        //            ControllerName(className: "HomeViewController", displayValue: "HomeViewController"),
        //            ControllerName(className: "MenuViewController", displayValue: "MenuViewController"),
        //            ControllerName(className: "DebugViewController", displayValue: "DebugViewController")
        //        ]
        
        return bundle.retrieveAllViewControllers()
            .sorted(by: { $0.displayValue < $1.displayValue })
            .filter { !excludedControllers.contains($0.className) }
    }
}

//MARK: UITableViewDataSource

extension ControllerListTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return currentDataSourceSectionTitles.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDataSource[currentDataSourceSectionTitles[section]]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 35
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return indexTitles
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentDataSourceSectionTitles[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath)
        
        let controller = currentDataSource[currentDataSourceSectionTitles[indexPath.section]]?[indexPath.row]
        
        cell.textLabel?.text = controller?.displayValue
        cell.textLabel?.font = cell.textLabel?.font.withSize(14)
        
        if let savedController = savedController,
            controller == savedController {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
        
        return cell
    }
}

//MARK: UITableViewDelegate

extension ControllerListTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let controller = currentDataSource[currentDataSourceSectionTitles[indexPath.section]]?[indexPath.row]
        controller?.saveToUserDefaults()
        
        UserDefaults.standard.set(0, forKey: Constants.useCase)
        
        searchController.isActive = false
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        
        // Because we can have more indexes than sections, touching an index which has no section counterpart would return 0,
        // thus scrolling the tableview to the top.
        // This implementation prevents such erratic jumps
        
        return indexTitles[0...index]
            .reversed()
            .compactMap { currentDataSourceSectionTitles.index(of: $0) }
            .first ?? 0
    }
}

//MARK: UISearchResultsUpdating

extension ControllerListTableViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        
        var viewControllers = retrieveWantedViewControllers(in: bundle)
        
        filteredDataSource = [String: [ControllerName]]()
        
        if let searchString = searchController.searchBar.text,
            searchString != "" {
            viewControllers = viewControllers.filter { ($0.displayValue as NSString).range(of: searchString, options: .caseInsensitive).location != NSNotFound }
        }
        
        viewControllers.forEach { filteredDataSource[$0.displayValue[0]] = [ControllerName]() }
        viewControllers.forEach { filteredDataSource[$0.displayValue[0]]?.append($0) }
        
        tableView.reloadData()
    }
}

//MARK: UISearchBarDelegate
extension ControllerListTableViewController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        shouldShowSearchResults = false
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            tableView.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
}
