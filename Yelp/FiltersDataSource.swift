//
//  FiltersDataSource.swift
//  Yelp
//
//  Created by Jonathan Wong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

enum Section: Int {
    case distance
    case sortBy
    case category
    case deals
}

class FiltersDataSource {
    var distance: ParentCell!
    var sortBy: ParentCell!
    var categories: [[String: String]]!
    var categoriesParent: ParentCell!
    var deals: ParentCell!
    var categoriesName: [String] = [String]()
    var items = [ParentCell]()
    var lastExpandedIndexPath: IndexPath?
    
    init() {
        distance = ParentCell(state: .collapsed,
                   children: [
                    "Auto",
                    "0.3 mile",
                    "1 mile",
                    "5 miles",
                    "20 miles"
            ],
                   selected: 0,
                   parentTableViewCellIdentifier: "DistanceHeaderTableViewCell",
                   childTableViewCellIdentifier: "DistanceTableViewCell")
        distance.actionAt = {
            (indexPath: IndexPath, tableView: UITableView) -> Void in
            // parentCell not selected
            // update the header label
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as! DistanceHeaderTableViewCell
            cell.headerLabel.text = self.items[indexPath.section].children[indexPath.row - 1]
            // collapse the row
            self.collapseItemAt(indexPath: indexPath, parentCell: &self.items[indexPath.section], tableView: tableView)
        }
        
        sortBy = ParentCell(state: .collapsed,
                            children: [
                                "Best matched",
                                "Distance",
                                "Highest Rated"
            ],
                            selected: 0,
                            parentTableViewCellIdentifier: "DistanceHeaderTableViewCell",
                            childTableViewCellIdentifier: "DistanceTableViewCell")
        sortBy.actionAt = {
            (indexPath: IndexPath, tableView: UITableView) -> Void in
            let cell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section)) as! DistanceHeaderTableViewCell
            cell.headerLabel.text = self.items[indexPath.section].children[indexPath.row - 1]
            // collapse the row
            self.collapseItemAt(indexPath: indexPath, parentCell: &self.items[indexPath.section], tableView: tableView)
        }
        
        categories = YelpCategories.categories()
        for dict in categories {
            if let name = dict["name"] {
                categoriesName.append(name)
            }
        }
        categoriesParent = ParentCell(state: .collapsed,
                                      children: categoriesName,
                                      selected: -1,
                                      parentTableViewCellIdentifier: "DistanceHeaderTableViewCell",
                                      childTableViewCellIdentifier: "SwitchTableViewCell")
        
        deals = ParentCell(state: .collapsed, children: ["Offering a Deal"], selected: 0, parentTableViewCellIdentifier: "SwitchTableViewCell", childTableViewCellIdentifier: "SwitchTableViewCell")
        
        items.append(distance)
        items.append(sortBy)
        items.append(categoriesParent)
        items.append(deals)
    }
    
    func titleAt(section: Int) -> String {
        if section == Section.distance.rawValue {
            return "Distance"
        } else if section == Section.sortBy.rawValue {
            return "Sort By"
        } else if section == Section.category.rawValue {
            return "Category"
        }
        return ""
    }
    
    func numberOfSections() -> Int {
        return 4
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        if section == Section.distance.rawValue ||
            section == Section.sortBy.rawValue ||
            section == Section.category.rawValue {
            let parentCell = items[section]
            if parentCell.state == .expanded {
                return parentCell.count + 1
            }
            return 1
        } else if section == Section.deals.rawValue {
            return 1
        }
        else {
            return 0
        }
    }
    
    func cellIdentifierFor(indexPath: IndexPath) -> String {
        if indexPath.section != Section.deals.rawValue {
            let parentCell = items[indexPath.section]
            
            if parentCell.state == .collapsed || parentCell.state == .expanded {
                if indexPath.row == 0 {
                    return parentCell.parentTableViewCellIdentifier
                }
            }
            
            return parentCell.childTableViewCellIdentifier
        }
        return "SwitchTableViewCell"
    }
    
    func expandItemAt(indexPath: IndexPath, parentCell: inout ParentCell, tableView: UITableView) {
        parentCell.state = .expanded
        
        // index to start inserting rows
        var insertIndex = indexPath.row + 1
        
        let indexPaths = (0..<parentCell.children.count).map {
            _ -> IndexPath in
            let ips = IndexPath(row: insertIndex, section: indexPath.section)
            insertIndex += 1
            return ips
        }
        print("inserting \(indexPaths.count)")
        
        tableView.insertRows(at: indexPaths, with: .fade)
        
        // update "chevron ('V')"
        let headerCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section))
        if headerCell is DistanceHeaderTableViewCell {
            (headerCell as! DistanceHeaderTableViewCell).chevron.transform = CGAffineTransform(rotationAngle: CGFloat(-Double.pi / 2))
        }
    }
    
    func collapseItemAt(indexPath: IndexPath, parentCell: inout ParentCell, tableView: UITableView) {
        parentCell.state = .collapsed

        // index to start deleting rows
        var deleteIndex = 1
        
        let indexPaths = (0..<parentCell.children.count).map {
            _ -> IndexPath in
            let ips = IndexPath(row: deleteIndex, section: indexPath.section)
            deleteIndex += 1
            return ips
        }
        print("deleting \(indexPaths.count)")
        
        tableView.deleteRows(at: indexPaths, with: .fade)
        
        // update "chevron ('V')"
        let headerCell = tableView.cellForRow(at: IndexPath(row: 0, section: indexPath.section))
        if headerCell is DistanceHeaderTableViewCell {
            (headerCell as! DistanceHeaderTableViewCell).chevron.transform = CGAffineTransform.identity
        }
    }
    
    func updateCells(indexPathSelected: IndexPath, tableView: UITableView) {
        tableView.beginUpdates()
        
        if indexPathSelected.section == Section.distance.rawValue ||
            indexPathSelected.section == Section.sortBy.rawValue ||
            indexPathSelected.section == Section.category.rawValue {
            let parentCell = items[indexPathSelected.section]
            switch (parentCell.state) {
            case .collapsed:
                if lastExpandedIndexPath != nil {
                    // todo: close other expanded

                }
                expandItemAt(indexPath: indexPathSelected, parentCell: &items[indexPathSelected.section], tableView: tableView)
            case .expanded:
                collapseItemAt(indexPath: indexPathSelected, parentCell: &items[indexPathSelected.section], tableView: tableView)
            }
        }
        
        tableView.endUpdates()
    }
}
