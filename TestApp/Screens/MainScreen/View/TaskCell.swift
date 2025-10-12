//
//  TaskCell.swift
//  TestApp
//
//  Created by Vadim on 12.10.2025.
//

import UIKit

class TaskCell: UITableViewCell {
    
    private lazy var containerView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var taskLabel: UILabel = {
        $0.font = UIFont(name: "Inter Medium", size: 20)
        $0.numberOfLines = 1
        $0.textAlignment = .left
        $0.textColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var dateLabel: UILabel = {
        $0.font = UIFont(name: "Inter Rugular", size: 14)
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.textColor = #colorLiteral(red: 0.4549019608, green: 0.5725490196, blue: 0.9960784314, alpha: 0.8)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var timeLabel: UILabel = {
        $0.font = UIFont(name: "Inter SemiBold", size: 12)
        $0.numberOfLines = 1
        $0.textAlignment = .right
        $0.textColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 0.8)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())
    
    private lazy var checkbox: CustomCheckbox = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(CustomCheckbox(isSelected: false))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureConstraints()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(isCompleted: Bool = false, title: String, date: String) {
        checkbox.isCompleted = isCompleted
        taskLabel.text = title
        let dateArray = date.components(separatedBy: " ")
        dateLabel.text = dateArray[0].formattedDate()
        timeLabel.text = dateArray[1]
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.layer.cornerRadius = 16
        containerView.backgroundColor = .white
        backgroundColor = .clear
    }
    
    
    private func configureConstraints() {
        addSubview(containerView)
        containerView.addSubview(checkbox)
        containerView.addSubview(taskLabel)
        containerView.addSubview(dateLabel)
        containerView.addSubview(timeLabel)
        
        NSLayoutConstraint.activate([
            checkbox.widthAnchor.constraint(equalToConstant: 20),
            checkbox.heightAnchor.constraint(equalTo: checkbox.widthAnchor),
            checkbox.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            checkbox.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8)
        ])
        
        NSLayoutConstraint.activate([
            taskLabel.leadingAnchor.constraint(equalTo: checkbox.trailingAnchor, constant: 8),
            taskLabel.centerYAnchor.constraint(equalTo: checkbox.centerYAnchor),
            taskLabel.trailingAnchor.constraint(equalTo: dateLabel.leadingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            dateLabel.bottomAnchor.constraint(equalTo: taskLabel.bottomAnchor),
            dateLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8),
            timeLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            timeLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8)
        ])
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor, constant: 4),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -4),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0),
        ])
        
    }
}
