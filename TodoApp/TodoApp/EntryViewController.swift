//
//  EntryViewController.swift
//  TodoApp
//
//  Created by 정종원 on 11/21/23.
//

import UIKit

class EntryViewController: UIViewController {
    
    @IBOutlet var field: UITextField!
    
    var update: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        field.delegate = self
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "save", style: .done, target: self, action: #selector(saveTask))
        
    }
    
    @objc func saveTask() {
        
        guard let text = field.text, !text.isEmpty else { return }
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        
        let newCount = count + 1
        
        UserDefaults().setValue(newCount, forKey: "count")
        UserDefaults().setValue(newCount, forKey: "task_\(newCount)")
        
        update?()
        
        navigationController?.popViewController(animated: true)

    }

}

extension EntryViewController: UITextFieldDelegate {
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        saveTask()
        
        return true
    }
    
}
