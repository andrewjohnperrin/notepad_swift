//
//  NoteViewController.swift
//  Notepad_Swift
//
//  Created by PointMotion on 2/11/18.
//  Copyright © 2018 Andrew Perrin. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class NoteViewController: UIViewController {
    
    var noteData:NSManagedObject!
    var noteTitle:String?
    var noteBody:String?
    @IBOutlet weak var textView: UITextView!
    let model = Model()

    override func viewDidLoad() {
        super.viewDidLoad()
        noteTitle = noteData.value(forKeyPath: "name") as? String
        noteBody = noteData.value(forKeyPath: "note") as? String
        title = noteTitle
        textView.text = noteBody
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        saveNote()
    }
    
    func saveNote() {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        noteData.setValue(textView.text, forKeyPath: "note")
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    @IBAction func deleteButtonPressed(_ sender: UIButton) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        managedContext.delete(noteData)
        do {
            try managedContext.save()
            _ = navigationController?.popViewController(animated: true)

        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

