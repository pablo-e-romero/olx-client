//
//  ItemsViewController.swift
//  olx-client
//
//  Created by Pablo Romero on 1/25/17.
//  Copyright © 2017 Pablo Romero. All rights reserved.
//

import UIKit
import CoreData

class ItemsViewController: UITableViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet var loadingNextPageView: LoadingNextPageView!
    
    var isRequestingData: Bool = false
    var hasReachedLastPage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.titleView = UIImageView(image: #imageLiteral(resourceName: "OlxLogo"))
        
        self.setupTableView()
        self.requestPage()
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.requestPage()
    }
    
    // MARK: - Request data
    
    func requestPage(withOffset offset: UInt = 0) {
        
        if self.isRequestingData {
            return
        }
        
        self.isRequestingData = true
        self.loadingNextPageView.setLoadingMode(true)
        
        OLXAPIManager.sharedInstance.requestItems(offset: offset) { (reachedLastPage: Bool?, error: Error?) in
            
            if let error = error {
                
                self.loadingNextPageView.setLoadingError(error)
                UIAlertController.presentAlert(withError: error, overViewController: self, completionHandler: {
                    if let refreshControl = self.refreshControl {
                        refreshControl.endRefreshing()
                    }
                })
            } else {
                
                self.hasReachedLastPage = reachedLastPage!
                self.refreshLoadingNextPageView()
                
                if let refreshControl = self.refreshControl {
                    refreshControl.endRefreshing()
                }
            }
            
            self.isRequestingData = false
        }
    }
    
    func requestNextPage() {
        let sectionInfo = self.fetchedResultsController.sections![0]
        self.requestPage(withOffset: UInt(sectionInfo.numberOfObjects))
    }
    
    func requestNextPageIfCorrespond() {
    
        let hasToRequestNextPage = !self.hasReachedLastPage && !self.isRequestingData
    
        if (hasToRequestNextPage)
        {
            let contentInset = self.tableView.contentInset;
            let contentHeight = self.tableView.contentSize.height;
            let contentOffsetY = self.tableView.contentOffset.y;
            let visibleHeight = self.tableView.frame.size.height - contentInset.bottom;
            let footerHeight = self.tableView.tableFooterView?.frame.size.height ?? 0;
    
            let isLoadNextPageAreaVisible = (visibleHeight >= (contentHeight - footerHeight - contentOffsetY));
    
            if (isLoadNextPageAreaVisible)
            {
                // We want to avoid multiple calls to requestNextPage
                NSObject.cancelPreviousPerformRequests(withTarget: self,
                                                       selector: #selector(requestNextPage),
                                                       object: nil)
                
                let delay: TimeInterval = 0.5;
               
                self.perform(#selector(requestNextPage),
                             with: nil,
                             afterDelay: delay)
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    }
    
    // MARK: - Table view
    
    func setupTableView() {
        
        self.tableView.estimatedRowHeight = 339.0
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        self.refreshLoadingNextPageView()
        
        self.refreshControl!.addTarget(self,
                                       action: #selector(ItemsViewController.handleRefresh(refreshControl:)),
                                       for: UIControlEvents.valueChanged)
        self.refreshControl!.tintColor = UIColor.olxGreen
    }
    
    func refreshLoadingNextPageView() {
        if self.hasReachedLastPage || Item.isEmpty(context: CoreDataStack.sharedInstance.viewContext) {
            self.tableView.tableFooterView = nil
        } else {
            self.tableView.tableFooterView = self.loadingNextPageView
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        let sectionInfo = self.fetchedResultsController.sections![section]
        return sectionInfo.numberOfObjects
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell",
                                                 for: indexPath) as! ItemCell
        let item = self.fetchedResultsController.object(at: indexPath)
        cell.update(withItem: item)
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.tableView {
            self.requestNextPageIfCorrespond();
        }
    }
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Item> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "serverSort", ascending: true)]
        
        let context = CoreDataStack.sharedInstance.viewContext
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        
        _fetchedResultsController = fetchedResultsController
        
        do {
            try _fetchedResultsController!.performFetch()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        return _fetchedResultsController!
    }
    
    var _fetchedResultsController: NSFetchedResultsController<Item>? = nil
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        
        switch type {
        case .insert:
            self.tableView.insertSections(IndexSet(integer: sectionIndex), with: .fade)
            
        case .delete:
            self.tableView.deleteSections(IndexSet(integer: sectionIndex), with: .fade)
            
        default:
            return
        }
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            tableView.insertRows(at: [newIndexPath!], with: .fade)
            
        case .delete:
            tableView.deleteRows(at: [indexPath!], with: .fade)
            
        case .update:
            let item = anObject as! Item
            if let cell = tableView.cellForRow(at: indexPath!) as? ItemCell {
                cell.update(withItem: item)
            }
            
        case .move:
            tableView.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }

}
