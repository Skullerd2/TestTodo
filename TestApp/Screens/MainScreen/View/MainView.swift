
import UIKit
import Foundation

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
        $0.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom + 16 + 48, right: 0)
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
        $0.addTarget(self, action: #selector(showCreatingTaskView), for: .touchUpInside)
        return $0
    }(UIButton())
    
    //Properties
    
    let viewModel: MainViewModel
    
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
        viewModel.networkMonitoring.startMonitoring()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkChanged),
                                               name: .networkStatusChanged,
                                               object: nil)
        
        viewModel.gotTask = { [weak self] in
            self?.tableView.reloadData()
        }
        viewModel.getTasks()
    }
    
}


//MARK: - TableView

extension MainView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell") as? TaskCell else {
            return UITableViewCell()
        }
        let task = viewModel.tasks[indexPath.row]
        cell.selectionStyle = .none
        cell.configure(isCompleted: task.completed, title: task.name, date: task.date ?? Date.formattedDateTime())
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = viewModel.tasks[indexPath.row]
        let detailVM = DetailViewModel(isEditing: true, taskModel: task)
        let vc = DetailView(viewModel: detailVM)
        vc.configureView(title: task.name, completed: task.completed, imageData: task.photoBase64)
        vc.onTaskChanged = { [weak self] task in
            self?.viewModel.tasks[indexPath.row].id = task.id
            self?.viewModel.tasks[indexPath.row].name = task.name
            self?.viewModel.tasks[indexPath.row].completed = task.completed
            self?.viewModel.tasks[indexPath.row].photoBase64 = task.photoBase64
            self?.viewModel.saveTasksToDefaults()
            tableView.reloadData()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK: - User Interface

extension MainView {
    private func configureConstraints() {
        view.addSubview(titleBackground)
        view.addSubview(tableView)
        view.addSubview(createButton)
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


//MARK: - Logic Of View

extension MainView {
    @objc private func showCreatingTaskView() {
        let vc = DetailView(viewModel: DetailViewModel(isEditing: false, indexForNew: viewModel.tasks.count))
        vc.onTaskChanged = { [weak self] task in
            self?.viewModel.tasks.append(task)
            self?.tableView.reloadData()
            self?.viewModel.saveTasksToDefaults()
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func networkChanged() {
        if !viewModel.networkMonitoring.isConnected {
            let alertController = UIAlertController(title: "No internet connection", message: "Try again later", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default)
            alertController.addAction(action)
            present(alertController, animated: true)
        } else {
            viewModel.syncroniseTasks()
        }
    }
}

