//
//  HomeViewController.swift
//  TODO APP
//
//  Created by Piotr Tyl on 06/05/2022.
//

import UIKit

class HomeViewController: UIViewController, UINavigationControllerDelegate {

    private var taskList: [Task] = []
    
    private let noTasksView = EmptyTaskListView()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(TaskOnListTableViewCell.self, forCellReuseIdentifier: TaskOnListTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TODO APP"
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        noTasksView.delegate = self
        fetchData()
        tableView.reloadData()
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noTasksView.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        noTasksView.center = view.center
        tableView.frame = view.bounds
    }
    
    @objc func didTapAdd() {
        let vc = NewTaskViewController()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func toogleEditing() {
        if self.tableView.isEditing == true {
            self.tableView.isEditing = false
            self.navigationItem.leftBarButtonItem?.title = "Edit"
        }
        else {
            self.tableView.isEditing = true
            self.navigationItem.leftBarButtonItem?.title = "Done"
        }
    }
    
    private func fetchData() {
        taskList = UserDefaultsManager.shared.getTasksList()
        updateUI()
    }
    
    private func deleteTask(taskID: Int) {
        if UserDefaultsManager.shared.deleteTask(taskID: taskID) == true {
            taskList = UserDefaultsManager.shared.getTasksList()
            updateUI()
        }
        else {
            print("Something went wrong")
        }
    }
    
    private func setUpNoTasksView() {
        view.addSubview(noTasksView)
        noTasksView.isHidden = false
        
    }
      

    
    func updateUI() {
        
        if UserDefaultsManager.shared.isTaskListEmpty() == true {
            setUpNoTasksView()
            tableView.isHidden = true
            navigationItem.rightBarButtonItem = nil
            navigationItem.leftBarButtonItem = nil
        }
        
        else {
            tableView.reloadData()
            noTasksView.isHidden = true
            tableView.isHidden = false
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(toogleEditing))
        }
    }
    

    
}

extension HomeViewController: EmptyTaskListViewDelegate, UITableViewDelegate, UITableViewDataSource, NewTaskViewContollerDelegate {
    
    func NewTaskCauseAnUpdate(_ newTaskView: NewTaskViewController) {
        self.fetchData()
    }
    
    func emptyTaskListViewDidTapButton(_ emptyTaskList: EmptyTaskListView) {
        let vc = UINavigationController(rootViewController: NewTaskViewController())
        vc.navigationBar.prefersLargeTitles = true
        vc.viewControllers.first?.navigationItem.largeTitleDisplayMode = .always
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true) 
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TaskOnListTableViewCell.identifier, for: indexPath) as? TaskOnListTableViewCell else {
            return UITableViewCell()
        }
        let task = taskList[indexPath.row]
        cell.configure(with: task)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            let alert = UIAlertController(title: "Delete task", message: "Are you sure?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self]_ in
                self?.tableView.endUpdates()
                return
            }))
            alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: {[weak self] _ in
                self?.deleteTask(taskID: indexPath.row)
                self?.tableView.deleteRows(at: [indexPath], with: .fade)
                self?.tableView.endUpdates()
                return
            }))
            
            present(alert, animated: true)
            
            
        }
    }
    
}
