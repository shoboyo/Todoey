//
//  ViewController.swift
//  Todoey
//
//  Created by Raileanu Razvan Andrei on 17/11/2018.
//  Copyright © 2018 MetaLanguage. All rights reserved.
//

import UIKit
import CoreData
import  AVFoundation

class TodoListViewController: UITableViewController {

    var itemArray = [Item]()
    
    var selectedCategory : Category? {
        didSet{
            loadItems()
        }
    }
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
//        if let items = defaults.array(forKey: "TodoListArray") as? [Item] {
//            itemArray = items
//
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    //MARK - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        let item = itemArray[indexPath.row]
        cell.textLabel?.text = item.title
       
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
    
    }
    
    //MARKET - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(itemArray[indexPath.row])
        
       itemArray[indexPath.row].done = !itemArray[indexPath.row].done
//    context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
       saveItems()
        
        tableView.reloadData()
        
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        
    }
    
    //MARK - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        
        let alert = UIAlertController(title: "Add New Todoey Item", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add item", style: .default) { (action) in
            //what will happen once the user clicks the add item button
           
        
            
           let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false;
            newItem.parentCategory = self.selectedCategory
            self.itemArray.append(newItem)
           
            self.saveItems()
            self.tableView.reloadData()
            
        }
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new item"
            textField = alertTextField
           
            
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
        
    }
    
    //MARK - Model Manipulation Methods
    func saveItems() {
        
        
        do {
            
            try  context.save()
            
        } catch{
            print ("Error saving content \(error)")
        }
    }
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil){
       // let request : NSFetchRequest<Item> = Item.fetchRequest()
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }else{
            request.predicate = categoryPredicate
        }
        
        
        do {
        itemArray = try context.fetch(request)
        }catch {
            print ("Error catching data from context \(error)")
        }
    }
    
   
}

//MARK - Search bar methods
extension TodoListViewController: UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        
        request.predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        loadItems(with: request)
        
        
       
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
        }
        DispatchQueue.main.async {
            searchBar.resignFirstResponder()
        }
    }
    
}
