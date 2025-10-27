import Foundation

class MainViewModel {
    
    private let networkManager = NetworkManager.shared
    let networkMonitoring = NetworkMonitor.shared
    private let defaults = UserDefaults.standard
    var tasks: [TaskModel]
    
    init(tasks: [TaskModel]) {
        self.tasks = tasks
    }
    
    var gotTask: (() -> Void)?
}

//MARK: Network

extension MainViewModel {
    func getTasks() {
        networkManager.fetchTasks { [weak self] result in
            switch result {
            case .success(let tasks):
                self?.tasks = tasks["values"]!
                self?.saveTasksToDefaults()
                DispatchQueue.main.async {
                    self?.gotTask?()
                }
            case .failure(let error):
                self?.tasks = (self?.loadTasksFromDefaults())!
                DispatchQueue.main.async {
                    self?.gotTask?()
                }
                print("Error in fetching tasks: \(error)")
            }
        }
    }
    
    func syncroniseTasks() {
        DispatchQueue.global(qos: .utility).async { [weak self] in
            guard let self = self else { return }

            networkManager.fetchTasks { result in
                switch result {
                case .success(let tasks):
                    let tasksOnServer = tasks["values"] ?? []

                    let uniqueTasks = tasksOnServer.filter { serverTask in
                        !self.tasks.contains(where: { $0.id == serverTask.id })
                    }
                    self.tasks.append(contentsOf: uniqueTasks)

                    for task in self.tasks {
                        if tasksOnServer.contains(where: { $0.id == task.id }) {
                            self.networkManager.updateTask(task: task) { result in
                                switch result {
                                case .success:
                                    print("Success updating \(task.id)")
                                case .failure(let error):
                                    print("Error updating: \(error)")
                                }
                            }
                        } else {
                            self.networkManager.addTask(task: task) { result in
                                switch result {
                                case .success:
                                    print("Success adding \(task.id)")
                                case .failure(let error):
                                    print("Error adding: \(error)")
                                }
                            }
                        }
                    }

                case .failure(let error):
                    print("Error fetching tasks: \(error)")
                }
            }
        }
    }
    
}

//MARK: Storage

extension MainViewModel {
    func saveTasksToDefaults() {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(tasks)
            defaults.set(data, forKey: "tasks")
        } catch {
            print("Error saving tasks: \(error)")
        }
    }
    
    func loadTasksFromDefaults() -> [TaskModel] {
        guard let data = defaults.data(forKey: "tasks") else { return [] }
        do {
            let decoder = JSONDecoder()
            let tasks = try decoder.decode([TaskModel].self, from: data)
            return tasks
        } catch {
            print("Error loading tasks: \(error)")
            return []
        }
    }
}
