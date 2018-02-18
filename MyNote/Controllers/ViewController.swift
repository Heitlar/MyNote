//
//  ViewController.swift
//  MyNote
//
//  Created by Sergey Larkin on 2018/02/01.
//  Copyright © 2018 Sergey Larkin. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var textView: UITextView!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var notes = [Title]()
    var index = Int()
    var note: Title? {
        didSet {
            self.loadText()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        print(index)
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        let newNote = Title(context: context)
        newNote.text = textView.text
        notes[index].text = newNote.text
        saveText()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }


    func saveText() {
        do {
            try context.save()
        } catch {
            print("Error saving note text \(error)")
        }
    }
    
    func loadText() {
        let request : NSFetchRequest<Title> = Title.fetchRequest()
        let predicate = NSPredicate(format: "name CONTAINS %@", note!.name!)
        request.predicate = predicate
        do {
            notes = try context.fetch(request)
            textView.text = notes[index].text
        } catch {
            print("Error loading note text \(error)")
        }
    }
}

