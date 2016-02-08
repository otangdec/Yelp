//
//  BusinessesViewController.swift
//  Yelp
//
//  Created by Timothy Lee on 4/23/15.
//  Copyright (c) 2015 Timothy Lee. All rights reserved.
//

import UIKit

class BusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate, UIScrollViewDelegate {

    @IBOutlet weak var mapButton: UIBarButtonItem!
    @IBOutlet weak var yelpSearchBar: UISearchBar!
    var businesses: [Business]!
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var loadMoreOffset = 20
    var searchTerm = "Restaurants"
    
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
        
        yelpSearchBar.becomeFirstResponder()
        yelpSearchBar.tintColor = UIColor.whiteColor()
        
        initializeNavBar()
        initializeYelpSearchBar()
        


//        Business.searchWithTerm("Thai", completion: { (businesses: [Business]!, error: NSError!) -> Void in
//            self.businesses = businesses
//            self.allBusinesses = self.businesses
//            self.tableView.reloadData()
//        
//            for business in businesses {
//                print(business.name!)
//                print(business.address!)
//            }
//        })

        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets

        
        

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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (!isMoreDataLoading) {
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging){
                    isMoreDataLoading = true
                
                    // Update position of loadingMoreView, and start loading indicator
                    let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                    loadingMoreView?.frame = frame
                    loadingMoreView!.startAnimating()
                
                    // Load more result
                    loadMoreData()
            }
        }
    }
    
    func loadMoreData() {
        Business.searchWithTerm(yelpSearchBar.text!, offset: loadMoreOffset, sort: nil, categories: nil, deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
//        Business.searchWithTerm("Restaurants", offset: loadMoreOffset, sort: nil, categories: [], deals: nil, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            if error != nil {
                    self.loadingMoreView?.stopAnimating()
                    //TODO: show network error
            } else {
                    self.loadMoreOffset += 20
                    self.businesses.appendContentsOf(businesses)
                    //self.filteredBusinesses.appendContentsOf(businesses)
                    self.tableView.reloadData()
                    self.loadingMoreView?.stopAnimating()
                    self.isMoreDataLoading = false

            }
        })

    }
    
    /* ============================================================= */
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
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
//        rightSearchBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Search, target: self, action: "searchTapped:")
//        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
        
        // make search bar into a UIBarButtonItem
//        leftNavBarButton = UIBarButtonItem(customView:yelpSearchBar)

        navigationItem.titleView = yelpSearchBar
        
//        rightSearchBarButtonItem = UIBarButtonItem(image: UIImage(named: "Map"), style: UIBarButtonItemStyle.Plain, target: self, action: "goToMapView")
//
//        self.navigationItem.rightBarButtonItem = rightSearchBarButtonItem
        navigationItem.rightBarButtonItem = mapButton
        // set back button with title "Back"

        self.navigationItem.backBarButtonItem = UIBarButtonItem(image: UIImage(named: "List"), style: .Plain, target: nil, action: nil)


    }
    
    func goToMapView(){
        
    }
    
    func initializeYelpSearchBar(){
        yelpSearchBar.delegate = self
        yelpSearchBar.searchBarStyle = UISearchBarStyle.Minimal
//        yelpSearchBar.hidden = true
        yelpSearchBar.hidden = false
    }
    
    /* ------------------------- searchBar -------------------- */
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        searchBar.setShowsCancelButton(true, animated: true)
        //navigationItem.setRightBarButtonItem(nil, animated: true)
        
        Business.searchWithTerm(searchText, completion: { (businesses: [Business]!, error: NSError!) -> Void in
            self.businesses = businesses
            self.tableView.reloadData()
            
//            for business in businesses {
//                //print(business.name!)
//                //print(business.address!)
//            }
        })


        tableView.reloadData()
    }
    
    //MARK: UISearchBarDelegate
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        //navigationItem.setRightBarButtonItem(nil, animated: true)
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar){
        //movies = allMovies
        tableView.reloadData()
        searchBar.setShowsCancelButton(false, animated: true)
        navigationItem.setRightBarButtonItem(mapButton, animated: true)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.endEditing(true)
        navigationItem.setRightBarButtonItem(mapButton, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "BusinessDetailsSegue" {
            let cell = sender as! UITableViewCell
            let indexPath = tableView.indexPathForCell(cell)
            let business = businesses![indexPath!.row]
            
            let detailViewController = segue.destinationViewController as! DetailViewController
            detailViewController.business = business
        } else if segue.identifier == "MapSegue" {
            let mapViewController = segue.destinationViewController as! MapViewController
            if businesses != nil && businesses.count > 0 {
            mapViewController.businesses = businesses
            } else {
                mapViewController.businesses = []
            }
        }
        
        
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
