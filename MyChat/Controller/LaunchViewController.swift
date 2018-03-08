//
//  LaunchViewController.swift
//  MyChat
//
//  Created by Yuanyuan Zhang on 08/03/2018.
//  Copyright © 2018 Ithink Team. All rights reserved.
//

import UIKit
import CoreData

class LaunchViewController: UIViewController, UINavigationControllerDelegate {

    var fetchResultController: NSFetchedResultsController<UserMO>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoEntry()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func autoEntry() {
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<UserMO> = UserMO.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            fetchResultController.delegate = self as? NSFetchedResultsControllerDelegate
            
            do {
                try fetchResultController.performFetch()
                if let fetchedObjects = fetchResultController.fetchedObjects {
                    print("= user count is \(fetchedObjects.count)")
                    if fetchedObjects.count > 0 {
                        Global.user = fetchedObjects[0]
                        self.performSegue(withIdentifier: "showMyChat", sender: self)
                    } else {
                        self.performSegue(withIdentifier: "showEntry", sender: self)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func ReLaunchUnwindSegue(_ sender: UIStoryboardSegue) {
        
        // logout
        if let appDelegate = (UIApplication.shared.delegate as? AppDelegate) {
            let context = appDelegate.persistentContainer.viewContext
            context.delete(Global.user)
            appDelegate.saveContext()
        }
    }

}
