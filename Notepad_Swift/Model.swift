//
//  Model.swift
//  Notepad_Swift
//
//  Created by PointMotion on 2/12/18.
//  Copyright © 2018 Andrew Perrin. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class Model : NSObject
{
    var notes: [NSManagedObject] = []
    var currentIndex:Int?
    var managedContext:NSManagedObjectContext?
    
    override init() {
        super.init()
        fetchNotes()
    }
    
    func fetchNotes(){
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Notes")
        
        do {
            notes = try managedContext!.fetch(fetchRequest)
        }
        catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
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
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func delete(index: Int) {
        managedContext?.delete(notes[index])
        notes.remove(at: index)
        do {
            try managedContext!.save()
        }
        catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func updateNote(note: NSManagedObject, text: String) {
        note.setValue(text, forKeyPath: "note")
        do {
            try managedContext!.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}


