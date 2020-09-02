//
//  ViewController.swift
//  Milestone Proj 4-6, Day 32
//
//  Created by Vanessa Chambers on 8/30/20.
//  Copyright © 2020 Vanessa Chambers. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var shoppingListItems = [String]()
    var shoppingListItemsLower = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // App title
        title = "Shopping List"
        
        // Adds items to shopping list
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        // Clear shopping list button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Clear List", style: .plain, target: self, action: #selector(clearList))
        
        // Share button in toolbar
        // spacer
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let shareButton = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))
        toolbarItems = [spacer, shareButton]
        navigationController?.isToolbarHidden = false
        
              
    }
    
    // Table View functions
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shoppingListItems.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // indexPath is current cell item
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = shoppingListItems[indexPath.row]
        return cell
    }
    
    @objc func addItem() {
        let addItemAC = UIAlertController(title: "Enter item", message: nil, preferredStyle: .alert)
        // Adds user input field
        addItemAC.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak addItemAC] _ in
            
            guard let listItem = addItemAC?.textFields?[0].text else { return }
            self?.submit(listItem)
            }
        
        addItemAC.addAction(submitAction)
        present(addItemAC, animated: true)
            
        
        
        //let itemLower = item.lowercased()
        /**if !shoppingListItemsLower.contains(itemLower) {
            insertToList(item)
        }
        else {
            let title = "Duplicate Item"
            let message = "Are you sure you want to add this item again?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default)  { UIAlertAction in
                self.insertToList(item)
                }
            )
               
            
            ac.addAction(UIAlertAction(title: "No", style: .default))
            present(ac, animated: true)
        } **/
    }
    
    @objc func submit(_ item: String) {
        if !shoppingListItemsLower.contains(item.lowercased()) {
            shoppingListItems.insert(item, at:0)
            shoppingListItemsLower += [item.lowercased()]
            
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        } else {
            let title = "Duplicate Item"
            let message = "Are you sure you want to add this item?"
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Yes", style: .default) { [weak self] _ in
                self?.shoppingListItems.insert(item, at:0)
                self?.shoppingListItemsLower += [item.lowercased()]
                
                let indexPath = IndexPath(row: 0, section: 0)
                self?.tableView.insertRows(at: [indexPath], with: .automatic)
                
            })
            ac.addAction(UIAlertAction(title: "No", style: .default))
            present(ac, animated: true)
            
        }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            _ = shoppingListItems[indexPath.row]
            shoppingListItems.remove(at: indexPath.row)
            /* bug: Don't know how to remove first isntance of an element in an array so it removes from one list but not the other
             
                shoppingListItemsLower.removeAll(where: {})
             
             */
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
            
    }
    
    @objc func clearList() {
        if shoppingListItems.isEmpty {
            return
        }
        // Alert controller to be sure they wanna clear
        let title = "Confirm Clear List"
        let message = "Are you sure you want to clear your shopping list?"
        let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
        // Yes and No buttons for alert controller
        ac.addAction(UIAlertAction(title: "Clear", style: .default) { [weak self] _ in
            // Clears shopping list
            self?.shoppingListItems.removeAll()
            self?.shoppingListItemsLower.removeAll()
            self?.tableView.reloadData()
        })
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in
            return
        })
        present(ac, animated: true)
    }
    
    @objc func shareTapped() {
        let shoppingList = shoppingListItems.joined(separator: "\n")
        let vc = UIActivityViewController(activityItems: [shoppingList], applicationActivities: [])
        // don't know what to do about this if it's in toolbar and not nav bar
        vc.popoverPresentationController?.barButtonItem = toolbarItems?[1]
        present(vc, animated: true)
        
        // BUG: dont actually know how to get it so that you can share the message via text. keep getting this error: Unable to initialize due to + [MFMessageComposeViewController canSendText] returns NO.
    }


}

