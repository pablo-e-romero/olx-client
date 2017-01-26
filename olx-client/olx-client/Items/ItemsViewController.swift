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

    @IBOutlet var loadingNextPageView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "OLX"
        
        self.setupTableView()
        self.requestFirstPage()
    }

    func handleRefresh(refreshControl: UIRefreshControl) {
        self.requestFirstPage()
    }
    
    func requestFirstPage() {
        
        OLXAPIManager.sharedInstance.requestItems { (error: Error?) in
            
            self.refreshLoadingNextPageView()
            
            if let refreshControl = self.refreshControl {
                refreshControl.endRefreshing()
            }
            
            if let error = error {
                UIAlertController.presentAlert(withError: error,
                                               overViewController: self)
            }
        }
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
  
    }
    
    // MARK: - Table view
    
    func setupTableView() {
        
        self.refreshLoadingNextPageView()
        
        self.refreshControl?.addTarget(self,
                                       action: #selector(ItemsViewController.handleRefresh(refreshControl:)),
                                       for: UIControlEvents.valueChanged)
    }
    
    func refreshLoadingNextPageView() {
        let context = CoreDataStack.sharedInstance.viewContext
        if Item.isEmpty(context: context) {
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
    
    // MARK: - Fetched results controller
    
    var fetchedResultsController: NSFetchedResultsController<Item> {
        
        if _fetchedResultsController != nil {
            return _fetchedResultsController!
        }
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        
        fetchRequest.fetchBatchSize = 20
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false),
                                        NSSortDescriptor(key: "title", ascending: true)]
        
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
