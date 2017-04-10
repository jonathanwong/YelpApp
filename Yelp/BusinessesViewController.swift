//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController {
    
    @IBOutlet weak var businessTableView: UITableView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessTableView.rowHeight = UITableViewAutomaticDimension
        businessTableView.estimatedRowHeight = 120
        
        Business.searchWithTerm(term: "Thai", completion: { (businesses: [Business]?, error: Error?) -> Void in
            
            self.businesses = businesses
            self.businessTableView.reloadData()
            
            if let businesses = businesses {
                for business in businesses {
                    print(business.name!)
                    print(business.address!)
                }
                
            }
            }
        )
        
        /* Example of Yelp search with more search options specified
         Business.searchWithTerm("Restaurants", sort: .Distance, categories: ["asianfusion", "burgers"], deals: true) { (businesses: [Business]!, error: NSError!) -> Void in
         self.businesses = businesses
         
         for business in businesses {
         print(business.name!)
         print(business.address!)
         }
         }
         */
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navController = segue.destination as! UINavigationController
        let filtersViewController = navController.topViewController as! FiltersViewController
        filtersViewController.filtersViewControllerDelegate = self
     }
}

extension BusinessesViewController: FiltersViewControllerDelegate {
    func filtersViewController(filtersViewController: FiltersViewController, didUpdateFilters filters: [String : AnyObject]) {
        let categories = filters["categories"] as? [String]
        let sortBy = filters["sortBy"] as? NSNumber
        let offeringDeal = filters["offeringDeal"] as! Bool
        let yelpSort = YelpSortMode(rawValue: (sortBy?.intValue)!)
        
        
        Business.searchWithTerm(term: "Restaurants",
                                sort: yelpSort,
                                categories: categories,
                                deals: offeringDeal,
                                completion: {
                                    (businesses: [Business]?, error: Error?) -> Void in
                                    self.businesses = businesses
                                    self.businessTableView.reloadData()
        })
    }
}

extension BusinessesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BusinessTableViewCell", for: indexPath) as! BusinessTableViewCell
        cell.business = businesses[indexPath.row]
        
        return cell
    }
}
