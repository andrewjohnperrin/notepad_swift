//
//  ViewController.swift
//  Notepad_Swift
//
//  Created by PointMotion on 2/11/18.
//  Copyright © 2018 Andrew Perrin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    var notes: [NSManagedObject] = []
    var currentIndex:Int?
    var managedContext:NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Notes"
        tableView.register(UITableViewCell.self,
                           forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        do {
            notes = try managedContext!.fetch(fetchRequest)
            self.tableView.reloadData()
        } 
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is NoteViewController
        {
            let thisnote = segue.destination as? NoteViewController
            thisnote?.noteData = notes[currentIndex!]
        }
    }

    @IBAction func addNote(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Name",
                                      message: "Add a new name",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let textField = alert.textFields?.first,
                let nameToSave = textField.text else {
                    return
            }
            
            self.save(name: nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
                managedContext!.delete(notes[indexPath.row])
                notes.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            do {
                try managedContext!.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentIndex = indexPath.row
        performSegue(withIdentifier: "noteSegue", sender: self)
    }
    
    func save(name: String) {
        let entity = NSEntityDescription.entity(forEntityName: "Notes", in: managedContext!)!
        
        let note = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        note.setValue(name, forKeyPath: "name")
        note.setValue("Enter Note Here", forKeyPath: "note")

        do {
            try managedContext!.save()
            notes.append(note)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let note = notes[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "Cell",
                                              for: indexPath)
            cell.textLabel?.text =
                note.value(forKeyPath: "name") as? String
            return cell
    }
}
