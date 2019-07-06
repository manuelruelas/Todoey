//
//  ViewController.swift
//  Todoey
//
//  Created by Jorge Guzman on 7/1/19.
//  Copyright © 2019 Indq. All rights reserved.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
    var itemsArray : Results<Item>?
    let realm = try! Realm()
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemsArray?.count ?? 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        if let item = itemsArray?[indexPath.row]{
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        } else{
            cell.textLabel?.text = "No items added"
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = itemsArray?[indexPath.row]{
            do{
                try realm.write {
                    item.done = !item.done
                }
            } catch{
                print("Error saving done status \(error)")
            }
            
        }
       
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // MARK - Add new items
    
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            if let currentCategory = self.selectedCategory{
                do{
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.done = false
                        newItem.dateCreate = Date()
                        currentCategory.items.append(newItem)
                    }
                } catch{
                    print("Error saving new item, \(error)")
                }
                
            }
            
            self.tableView.reloadData()
            
            
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
        }
        alert.addAction(action)
        
        present(alert, animated: true,completion:nil)
    }
    
    
    // MARK - Model Manipulation Methods
    
    func saveItems(){
        
    }
    
    func loadItems (){
        itemsArray = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()

    }
}
// MARK: - Searchbar Methods

extension TodoListViewController:UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        itemsArray = itemsArray?.filter("title CONTAINS[cd] %@",searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0  {
            loadItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }

}
