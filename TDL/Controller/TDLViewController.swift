//
//  ViewController.swift
//  TDL
//
//  Created by Nauman Bajwa on 11/19/19.
//  Copyright © 2019 Nauman Bajwa. All rights reserved.
//

import UIKit

class TDLViewController: UITableViewController {
    
    var itemArray = [Item]()
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist") 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
       
  //      print(dataFilePath!)
        
        

        loadItems()
        
        
    }

// Mark - TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell       = tableView.dequeueReusableCell(withIdentifier: "TDLCell", for: indexPath)
        cell.textLabel?.text = itemArray[indexPath.row].title
        
        if itemArray[indexPath.row].done == true {
            cell.accessoryType  = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    
// Mark - Tableview Delegate methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        saveItems()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New To Do Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            // what will happen once the user clicks the add user item button on our UIAlert
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            self.saveItems()

        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create New Item"
           textField = alertTextField
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: Model Manipulation methods
    func saveItems(){
        let encoder = PropertyListEncoder()
        do{
            let data = try encoder.encode(itemArray)
            try data.write(to: dataFilePath!)
        }catch {
            print("Error! Encoding item array error. \(error)")
        }
        tableView.reloadData()
    }
    
    func loadItems(){
        
        if let data = try?Data(contentsOf: dataFilePath!){
            let decoder = PropertyListDecoder()
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }catch{
                print("The data could not be decoded. \(error)")
            }
            
        }
        
    }
    
}

