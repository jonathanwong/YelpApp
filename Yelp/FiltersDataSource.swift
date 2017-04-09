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
}

class FiltersDataSource {
    var categories: [[String: String]]!
    var distance: ParentCell!
    var items = [ParentCell]()
    var lastExpandedIndexPath: IndexPath?
    
    init() {
        categories = YelpCategories.categories()
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
            
        
        items.append(distance)
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        let parentCell = items[section]
        if section == Section.distance.rawValue {
            if parentCell.state == .expanded {
                print("numberRows: \(parentCell.count + 1)")
                return parentCell.count + 1
            }
            return 1
        } else if section == Section.sortBy.rawValue {
            return categories.count
        } else if section == Section.category.rawValue {
            return 1
        } else {
            return 0
        }
    }
    
    func cellIdentifierFor(indexPath: IndexPath) -> String {
        let parentCell = items[indexPath.section]
        
        if parentCell.state == .collapsed {
            if indexPath.row == 0 {
                return parentCell.parentTableViewCellIdentifier
            }
        }
        
        return parentCell.childTableViewCellIdentifier
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
        
//        guard indexPath.row + 1 <= indexPath.row + parentCell.count else { return }

        // index to start deleting rows
//        var deleteIndex = indexPath.row + 1
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
        
        if indexPathSelected.section == Section.distance.rawValue {
            let parentCell = items[indexPathSelected.row]
            switch (parentCell.state) {
            case .collapsed:
                if lastExpandedIndexPath != nil {
                    // close other expanded
                    
                    
                }
                expandItemAt(indexPath: indexPathSelected, parentCell: &items[indexPathSelected.row], tableView: tableView)
            case .expanded:
                collapseItemAt(indexPath: indexPathSelected, parentCell: &items[indexPathSelected.row], tableView: tableView)
            }
        }
        
        tableView.endUpdates()
    }
//    func updateCells(parentIndexPath: IndexPath, childIndexPath: IndexPath, parentCell: ParentCell) {
//        switch (parentCell.state) {
//            case .expanded
//            collapseItemAt(indexPath: <#T##IndexPath#>, parentCell: &<#T##ParentCell#>, tableView: <#T##UITableView#>)
//        }
//    }
}
