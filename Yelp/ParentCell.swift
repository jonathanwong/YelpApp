//
//  AccordionManager.swift
//  Yelp
//
//  Created by Jonathan Wong on 4/7/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit

public enum State {
    case collapsed
    case expanded
}

public struct ParentCell {
    var state: State
    var children: [String] // collapsed or expanded children
    var selected: Int       // currently selected
    var parentTableViewCellIdentifier: String
    var childTableViewCellIdentifier: String
    var actionAt: ((_ indexPath: IndexPath, _ tableView: UITableView) -> Void)?
    
    public init(state: State, children: [String], selected: Int, parentTableViewCellIdentifier: String, childTableViewCellIdentifier: String) {
        self.state = state
        self.children = children
        self.selected = selected
        self.parentTableViewCellIdentifier = parentTableViewCellIdentifier
        self.childTableViewCellIdentifier = childTableViewCellIdentifier
    }
    
    var count: Int {
        get {
            return children.count
        }
    }
}

public func != (lhs: (Int, Int), rhs: (Int, Int)) -> Bool {
    return lhs.0 != rhs.0 && lhs.1 != rhs.1
}
