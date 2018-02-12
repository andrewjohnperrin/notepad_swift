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
        model.updateNote(note: noteData, text: textView.text)
    }
}

