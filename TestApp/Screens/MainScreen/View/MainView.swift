//
//  ViewController.swift
//  TestApp
//
//  Created by Vadim on 12.10.2025.
//

import UIKit

class MainView: UIViewController {
    
    
    //UI-elements
    private lazy var titleLabel: UILabel = {
        $0.text = "Tasks"
        $0.font = UIFont(name: "Inter Bold", size: 24)
        $0.textColor = .white
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UILabel())

    private lazy var tableView: UITableView = {
        $0.delegate = self
        $0.dataSource = self
        $0.register(TaskCell.self, forCellReuseIdentifier: "taskCell")
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.separatorStyle = .none
        return $0
    }(UITableView())
    
    private lazy var titleBackground: UIView = {
        $0.roundBottomCorners(radius: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIView())
    
    private lazy var createButton: UIButton = {
        let config = UIImage.SymbolConfiguration(pointSize: 20, weight: .bold)
        let image = UIImage(systemName: "pencil", withConfiguration: config)?.withRenderingMode(.alwaysTemplate)
        $0.tintColor = .white
        $0.setImage(image, for: .normal)
        $0.backgroundColor = #colorLiteral(red: 0.454395771, green: 0.5721556544, blue: 0.9948783517, alpha: 1)
        $0.layer.cornerRadius = 24
        $0.translatesAutoresizingMaskIntoConstraints = false
        return $0
    }(UIButton())
    
    //Properties
    
    let viewModel: MainViewModel
    let tasks: [TaskCellViewModel] = []
    
    init(viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.9411764706, green: 0.9411764706, blue: 0.9411764706, alpha: 1)
        configureConstraints()
    }
    
}


//MARK: - TableView

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell else {
            return UITableViewCell()
        }
        cell.configure(isCompleted: false, title: "Title task", date: "2025-01-01 12:00:00")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - User Interface

extension MainView {
    private func configureConstraints() {
        view.addSubview(titleBackground)
        view.addSubview(createButton)
        view.addSubview(tableView)
        titleBackground.addSubview(titleLabel)
        
        
        NSLayoutConstraint.activate([
            titleBackground.topAnchor.constraint(equalTo: view.topAnchor),
            titleBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            titleBackground.heightAnchor.constraint(equalToConstant: 100),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: titleBackground.leadingAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: titleBackground.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            createButton.heightAnchor.constraint(equalToConstant: createButton.layer.cornerRadius * 2),
            createButton.widthAnchor.constraint(equalTo: createButton.heightAnchor),
            createButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            createButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16)
        ])
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleBackground.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}



