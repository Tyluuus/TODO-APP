//
//  NewTaskViewController.swift
//  TODO APP
//
//  Created by Piotr Tyl on 07/05/2022.
//

import UIKit

protocol NewTaskViewContollerDelegate: AnyObject {
    func NewTaskCauseAnUpdate(_ newTaskView: NewTaskViewController)
}

class NewTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let pickerData = ["Work", "Shopping", "Other"]
    weak var delegate: NewTaskViewContollerDelegate?
    
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.text = "Add details of a new task"
        return label
    }()
    
    private let taskName: UITextField = {
        let taskName = UITextField()
        taskName.placeholder = "Task name"
        taskName.keyboardType = .default
        taskName.textAlignment = .center
        taskName.autocapitalizationType = .none
        taskName.backgroundColor = .secondarySystemBackground
        taskName.layer.cornerRadius = 10
        taskName.autocorrectionType = .no
        return taskName
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.text = "Deadline for a task"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
        
    }()
    
    private let dateToDo: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.timeZone = .autoupdatingCurrent
        return datePicker
    }()
    
    private let pickerLabel: UILabel = {
       let label = UILabel()
        label.text = "Category"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .regular)
        return label
    }()
    
    private let categoryPicker: UIPickerView = {
        let categoryPicker = UIPickerView()
        
        return categoryPicker
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(helloLabel)
        view.addSubview(taskName)
        view.addSubview(dateLabel)
        view.addSubview(dateToDo)
        view.addSubview(pickerLabel)
        view.addSubview(categoryPicker)
        categoryPicker.delegate = self
        categoryPicker.dataSource = self
        categoryPicker.selectRow(0, inComponent: 0, animated: true)
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapLeftButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add task", style: .done, target: self, action: #selector(didTapAddNewTaskButton))
        view.backgroundColor = .systemBackground
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let spacer = view.height/20
        let normHight = view.height/15
        helloLabel.frame = CGRect(x: 0, y: navigationItem.titleView?.bottom ?? 50 + 25, width: view.width, height: normHight)
        taskName.frame = CGRect(x: 25, y: helloLabel.bottom + spacer, width: view.width - 50, height: normHight)
        dateLabel.frame = CGRect(x: 0, y: taskName.bottom + spacer, width: view.width/2, height: normHight)
        dateToDo.frame = CGRect(x: view.width/2, y: taskName.bottom + spacer, width: view.width/2 - view.safeAreaInsets.right, height: normHight)
        pickerLabel.frame = CGRect(x: 0, y: dateToDo.bottom + spacer, width: view.width, height: normHight)
        categoryPicker.frame = CGRect(x: 0, y: pickerLabel.bottom, width: view.width , height: normHight*2)
       
    }
   
    @objc func didTapLeftButton() {
        self.delegate?.NewTaskCauseAnUpdate(self)
        if (self.navigationController?.viewControllers.count == 1) {
            self.navigationController?.viewControllers.insert(HomeViewController(), at: 0)
        }
        self.navigationController?.popToRootViewController(animated: false)
        
    }
    
    @objc func didTapAddNewTaskButton() {
        
        if checkIfFilled() == true {
            let task = Task(
                name: taskName.text ?? "",
                date: dateToDo.date,
                category: pickerData[categoryPicker.selectedRow(inComponent: 0)]
            )
            if UserDefaultsManager.shared.addNewTask(task: task) == true {
                let alert = UIAlertController(title: "Success", message: "New task was added", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _  in
                    self.delegate?.NewTaskCauseAnUpdate(self)
                    if (self.navigationController?.viewControllers.count == 1) {
                        self.navigationController?.viewControllers.insert(HomeViewController(), at: 0)
                    }
                    self.navigationController?.popToRootViewController(animated: false)
                }))
                present(alert, animated: true)
                
            }
            
            
            
        }
    }

    func checkIfFilled() -> Bool {
        if self.taskName.text?.count ?? -1 <= 0 {
            let alert = UIAlertController(title: "A name not entered", message: "Please enter a task name", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true)
            return false
        }
        
        if self.dateToDo.date < Date() {
            let alert = UIAlertController(title: "A date in past", message: "Please pick a date in future", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: nil))
            present(alert, animated: true)
            return false
        }
        
        return true

    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let row = pickerData[row]
        return row
    }
    

}


