//
//  EmptyTaskListView.swift
//  TODO APP
//
//  Created by Piotr Tyl on 06/05/2022.
//

import UIKit

protocol EmptyTaskListViewDelegate: AnyObject {
    func emptyTaskListViewDidTapButton(_ emptyTaskList: EmptyTaskListView)
}

class EmptyTaskListView: UIView {

    weak var delegate: EmptyTaskListViewDelegate?
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.text = "No tasks added"
        label.textAlignment = .center
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.setTitle("Add new task", for: .normal)
        button.tintColor = .white
        button.layer.cornerRadius = 20
        button.layer.masksToBounds = true
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        addSubview(button)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    @objc private func didTapButton() {
        delegate?.emptyTaskListViewDidTapButton(self)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        label.frame = CGRect(x: 0, y: 5, width: width, height: 40)
        button.frame = CGRect(x: 0, y: label.bottom + 10, width: width, height: 40)
        
    }

}
