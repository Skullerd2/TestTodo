import Foundation

class DetailViewModel {
    let networkManager = NetworkManager.shared
    
    let isEditing: Bool
    var taskModel: TaskModel?
    let indexForNew: Int
    init(isEditing: Bool, taskModel: TaskModel? = nil, indexForNew: Int = 0) {
        self.isEditing = isEditing
        self.taskModel = taskModel
        self.indexForNew = indexForNew + 1
    }
}

//MARK: - Networking

extension DetailViewModel {
    func addTask(task: TaskModel){
        networkManager.addTask(task: task) { result in
            switch result {
            case .success(let tasks):
                print("Success in adding task")
            case .failure(let failure):
                print("Failure in adding task: \(failure)")
            }
        }
    }
    
    func updateTask(task: TaskModel){
        networkManager.updateTask(task: task) { result in
            switch result {
            case .success(let tasks):
                print("Success in updating task")
            case .failure(let failure):
                print("Failure in updating task: \(failure)")
            }
        }
    }
}
