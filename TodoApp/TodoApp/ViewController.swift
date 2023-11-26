//
//  ViewController.swift
//  TodoApp
//
//  Created by 정종원 on 11/21/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //사용자가 입력한 모든 작업을 보관
    var tasks = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "To Do List"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //Set Up 초기값 설정
        if !UserDefaults().bool(forKey: "setup") {
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        //Get all current saved tasks
        updateTasks()
        
    }
    
    func updateTasks() {
        
        tasks.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        
        for x in 0 ..< count {
            
            if let task = UserDefaults().value(forKey: "task_\(x + 1)") as? String {
                tasks.append(task)
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    //Todo 추가
    @IBAction func didTapAdd(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "New Task", message: "Enter new task", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Enter task..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Add Task", style: .default, handler: { [weak self] _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.addTask(text)
            }
        }))
        
        present(alert, animated: true)
        
    }
    
    func addTask(_ task: String) {
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else { return }
        let newCount = count + 1
        
        UserDefaults().setValue(newCount, forKey: "count")
        UserDefaults().setValue(task, forKey: "task_\(newCount)")
        
        updateTasks()
        
    }
    
}


//MARK: - TableView Delegate Method
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        //스와이프 했을시 edit
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editTask(at: indexPath)
            completionHandler(true)
        }
        
        //스와이프 했을시 delete
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            // UserDefaults 삭제
            UserDefaults.standard.removeObject(forKey: "task_\(indexPath.row + 1)")
            UserDefaults.standard.removeObject(forKey: "taskDone_\(indexPath.row + 1)")
            
            // count update
            let newCount = UserDefaults.standard.integer(forKey: "count") - 1
            UserDefaults.standard.set(newCount, forKey: "count")
            
            // array update
            self?.tasks.remove(at: indexPath.row)
            
            // UI update
            self?.tableView.deleteRows(at: [indexPath], with: .fade)
            
            completionHandler(true)
        }
        
        let swipeConfig = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        swipeConfig.performsFirstActionWithFullSwipe = false
        return swipeConfig
    }
    
    func editTask(at indexPath: IndexPath) {
        let alert = UIAlertController(title: "Edit Task", message: "Edit your task", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.text = self.tasks[indexPath.row]
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { [weak self] _ in
            if let textField = alert.textFields?.first, let text = textField.text, !text.isEmpty {
                self?.updateTask(at: indexPath, with: text)
            }
        }))
        
        present(alert, animated: true)
    }
    
    func updateTask(at indexPath: IndexPath, with newText: String) {
        
        UserDefaults.standard.setValue(newText, forKey: "task_\(indexPath.row + 1)")
        
        tasks[indexPath.row] = newText
        
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
}

//MARK: - TableView DataSource Method
extension ViewController: UITableViewDataSource {
    
    //cell의 개수를 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    //DQ를 이용 cell반환
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        //        cell.textLabel?.text = tasks[indexPath.row]
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "customCell", for: indexPath) as? CustomCell {
            
            cell.todoLabel.text = tasks[indexPath.row]
            
            
            return cell
        } else {
            return UITableViewCell()
        }
        
    }
    
    
}

