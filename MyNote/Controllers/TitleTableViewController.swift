//
//  TitleTableViewController.swift
//  MyNote
//
//  Created by Sergey Larkin on 2018/02/01.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData

class TitleTableViewController: UITableViewController {

    var titles = [Title]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadTitles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath)
        cell.textLabel?.text = titles[indexPath.row].name
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "TitleToContent", sender: self)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            deleteTitles(at: indexPath.row)
            titles.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.index = indexPath.row
            destinationVC.note = titles[indexPath.row]
            
        }
        
    }
    
    @IBAction func addTitle(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Add new title:", message: "", preferredStyle: .alert)
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            let textField = alert.textFields![0]
            let newTitle = Title(context: self.context)
            newTitle.name = textField.text!
            newTitle.text = ""
            
            self.titles.append(newTitle)
            self.saveTitle()
        }
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter new title"
            textField.autocapitalizationType = .sentences
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
    
    func saveTitle() {
        do {
           try context.save()
        } catch {
            print("Error saving title \(error)")
        }
        tableView.reloadData()
    }
    
    func loadTitles() {
        let request : NSFetchRequest<Title> = Title.fetchRequest()
        do {
            titles = try context.fetch(request)
        } catch {
            print("Error loadind titles \(error)")
        }
        tableView.reloadData()
    }
    
    func deleteTitles(at: Int) {
        let titleToDelete = titles[at]
        context.delete(titleToDelete)
    }
}
