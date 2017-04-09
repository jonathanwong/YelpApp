//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Jonathan Wong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

@objc protocol FiltersViewControllerDelegate {
    @objc optional func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String: AnyObject])
}

class FiltersViewController: UIViewController {
    
    @IBOutlet weak var filtersTableView: UITableView!

    var categories: [[String: String]]!
    var switchStates: [Int: Bool]! = [Int: Bool]()
    let filtersDataSource = FiltersDataSource()
    var lastSelectedIndex: IndexPath?
    var selectedHeaderIndex: IndexPath?
    
    weak var filtersViewControllerDelegate: FiltersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        categories = YelpCategories.categories()
        
        filtersTableView.register(UINib(nibName: "DistanceHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "DistanceHeaderTableViewCell")
        filtersTableView.register(UINib(nibName: "DistanceTableViewCell", bundle: nil), forCellReuseIdentifier: "DistanceTableViewCell")
        
        filtersTableView.rowHeight = UITableViewAutomaticDimension
        filtersTableView.estimatedRowHeight = 80
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        var filters = [String: AnyObject]()
        
        var selectedCategories = [String]()
        for (row, isSelected) in switchStates {
            if isSelected {
                selectedCategories.append(categories[row]["code"]!)
            }
        }
        
        if selectedCategories.count > 0 {
            filters["categories"] = selectedCategories as AnyObject
        }
        
        filtersViewControllerDelegate?.filtersViewController!(filtersViewController: self, didUpdateFilters: filters)
        dismiss(animated: true, completion: nil)
    }
}

extension FiltersViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return filtersDataSource.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersDataSource.numberOfRowsInSection(section: section)
        
        
        
//        return categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchTableViewCell", for: indexPath) as! SwitchTableViewCell
//        cell.switchLabel.text = categories[indexPath.row]["name"]
//        cell.switchTableViewCellDelegate = self
//        cell.onSwitch.isOn = switchStates[indexPath.row] ?? false
//        
//        return cell
        let cellIdentifier = filtersDataSource.cellIdentifierFor(indexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        
        if indexPath.section == Section.distance.rawValue {
            let parentCell = filtersDataSource.items[indexPath.section]
            if indexPath.row == 0 {
                let title = parentCell.selected - 1 >= 0 ? parentCell.children[parentCell.selected - 1] : parentCell.children[0]
                (cell as! DistanceHeaderTableViewCell).headerLabel.text = title
            } else {
                (cell as! DistanceTableViewCell).distanceLabel.text = parentCell.children[indexPath.row - 1]
                print("parent cell index selected: \(parentCell.selected)")
                if parentCell.selected + 1 == indexPath.row {
                    cell.accessoryType = .checkmark
                } else {
                    cell.accessoryType = .none
                }
            }
        }
        
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // check if a parentCell is selected
        print(indexPath.row)
        print(indexPath.section)
        print("selected index: \(indexPath.row - 1)")
        if indexPath.row == 0 {
            filtersDataSource.updateCells(indexPathSelected: indexPath, tableView: tableView)
        } else {
            let parentCell = filtersDataSource.items[indexPath.section]
            if parentCell.actionAt != nil {
                parentCell.actionAt!(indexPath, tableView)
            }
            filtersDataSource.items[indexPath.section].selected = indexPath.row - 1
        }
    }
}

extension FiltersViewController: SwitchTableViewCellDelegate {
    func switchTableViewCell(switchTableViewCell: SwitchTableViewCell, didChangeValue value: Bool) {
        let indexPath = filtersTableView.indexPath(for: switchTableViewCell)!
        switchStates[indexPath.row] = value
    }
}
