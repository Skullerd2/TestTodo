import Alamofire
import Foundation

protocol NetworkRequestProtocol {
    func request<T: Decodable>(
        _ url: URLConvertible,
        method: HTTPMethod,
        parameters: Parameters?,
        encoding: ParameterEncoding,
        headers: HTTPHeaders?,
        decoder: JSONDecoder,
        completion: @escaping (Result<T, AFError>) -> Void
    )
}

extension Session: NetworkRequestProtocol {
    func request<T: Decodable>(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil,
        decoder: JSONDecoder = JSONDecoder(),
        completion: @escaping (Result<T, AFError>) -> Void
    ) {
        self.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers)
            .validate()
            .responseDecodable(of: T.self, decoder: decoder) { response in
                completion(response.result)
            }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    
    private let requestExecutor: NetworkRequestProtocol
    init(requestExecutor: NetworkRequestProtocol = Session.default) {
        self.requestExecutor = requestExecutor
    }
    private init() {
        self.requestExecutor = Session.default
    }
    
    func fetchTasks(completion: @escaping (Result<[String: [TaskModel]], AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        requestExecutor.request(
            "http://0.0.0.0:8080/api/getTasks",
            method: .post,
            parameters: nil,
            encoding: URLEncoding.default,
            headers: nil,
            decoder: decoder,
            completion: completion
        )
    }
    
    func addTask(task: TaskModel, completion: @escaping (Result<[String: [TaskModel]], AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let parameters: [String: Any] = [
            "name": task.name,
            "completed": task.completed,
            "photoBase64": task.photoBase64
        ]
        
        requestExecutor.request(
            "http://0.0.0.0:8080/api/addTask",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: ["Content-Type": "application/json"],
            decoder: decoder,
            completion: completion
        )
    }
    
    func updateTask(task: TaskModel, completion: @escaping (Result<[String: [TaskModel]], AFError>) -> Void) {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let parameters: [String: Any] = [
            "id": task.id,
            "name": task.name,
            "completed": task.completed,
            "photoBase64": task.photoBase64
        ]
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "Accept": "application/json"
        ]
        
        requestExecutor.request(
            "http://0.0.0.0:8080/api/updateTask",
            method: .post,
            parameters: parameters,
            encoding: JSONEncoding.default,
            headers: headers,
            decoder: decoder,
            completion: completion
        )
    }
}
