//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {

    @IBOutlet weak var yelpSearchBar: UISearchBar!
    
    var businesses: [Business]!
    
    @IBOutlet weak var tableView: UITableView!
    
//    var movies: [NSDictionary]? // optional can be dict or nil, safer
//    var allMovies: [NSDictionary]?
    
//    var filteredData: [NSDictionary]?

    
    var rightSearchBarButtonItem:UIBarButtonItem!
    var leftNavBarButton: UIBarButtonItem!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 120
        

        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
        
            for business in businesses {
                print(business.name!)
                print(business.address!)
            }
        })
        
       
        
        initializeNavBar()
        initializeYelpSearchBar()

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if businesses != nil {
            return businesses!.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("BusinessCell", forIndexPath: indexPath) as! BusinessCell
        
        cell.business = businesses[indexPath.row]
        
        return cell
    }
    
    func initializeNavBar(){
    
        
        // Make search button and add into the navagation bar on the right
        rightSearchBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
        
        // make search bar into a UIBarButtonItem
        leftNavBarButton = UIBarButtonItem(customView:yelpSearchBar)

        
        // set back button with title "Back"
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .Plain, target: nil, action: nil)
        
    }
    
    func initializeYelpSearchBar(){
        yelpSearchBar.delegate = self
        yelpSearchBar.searchBarStyle = UISearchBarStyle.Minimal
        yelpSearchBar.hidden = true
    }
    
    /* ------------------------- searchBar -------------------- */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        
//        movies = searchText.isEmpty ? allMovies : allMovies!.filter({ (movie: NSDictionary) -> Bool in
//            return (movie["title"] as! String).rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
//        })
        tableView.reloadData()
    }
    
    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        //movies = allMovies
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        hideSearchBar()
    }
    
    
    /* Helper methods */
    func searchTapped (sender: AnyObject) {
        showSearchBar()
    }
    
    func showSearchBar() {
        yelpSearchBar.hidden = true
        //movieSearchBar.alpha = 0
        navigationItem.titleView = yelpSearchBar
        navigationItem.setRightBarButtonItem(nil, animated: true)
        navigationItem.setLeftBarButtonItem(nil, animated: true)
        UIView.animateWithDuration(0.5, animations: {
            self.yelpSearchBar.hidden = false
            //self.movieSearchBar.alpha = 1
            }, completion: { finished in
                self.yelpSearchBar.becomeFirstResponder()
        })
    }
    
    func hideSearchBar() {
        navigationItem.setRightBarButtonItem(rightSearchBarButtonItem, animated: true)
        navigationItem.titleView = nil
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
