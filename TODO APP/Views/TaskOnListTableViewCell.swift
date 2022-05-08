//
//  TaskOnListTableViewCell.swift
//  TODO APP
//
//  Created by Piotr Tyl on 08/05/2022.
//

import UIKit

class TaskOnListTableViewCell: UITableViewCell {

    static let identifier = "TaskOnListTableViewCell"
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .bold)
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(nameLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(categoryLabel)
        contentView.clipsToBounds = true
        accessoryType = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameLabel.frame =  CGRect(x: 0, y: 0, width: width/2, height: height/2 + height/4)
        dateLabel.frame = CGRect(x: 0, y: nameLabel.bottom, width: width/2, height: height/4)
        categoryLabel.frame = CGRect(x: width/2 + 5, y: height/4, width: width/2 - 5, height: height/2)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameLabel.text = nil
        dateLabel.text = nil
        categoryLabel.text = nil
    }
        
    func configure(with viewModel: Task) {
        nameLabel.text = viewModel.name
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        let modifiedDate = Calendar.current.date(byAdding: .hour, value: +3,to: Date()) ?? Date()
        dateLabel.text = dateFormatter.string(from: viewModel.date)
        if viewModel.date < modifiedDate { dateLabel.textColor = .systemRed }
        else { dateLabel.textColor = .systemGreen}
        categoryLabel.text = viewModel.category
        switch viewModel.category {
        case "Work":
            contentView.backgroundColor = .systemGray
            categoryLabel.text = categoryLabel.text! + "🗓"
        case "Shopping":
            contentView.backgroundColor = .systemMint
            categoryLabel.text = categoryLabel.text! + "💰"
        case "Other":
            contentView.backgroundColor = .systemBlue
            categoryLabel.text = categoryLabel.text! + "🐶"
        default:
            return
        }
    }

}
