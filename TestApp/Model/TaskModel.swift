import Foundation
import UIKit

struct TaskModel: Codable {
    var id: String
    var name: String
    var completed: Bool
    var photoBase64: String?
    var date: String?
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case completed
        case photoBase64
        case date
    }
    
    init(id: String = "", name: String, completed: Bool, photoBase64: String? = nil, date: String? = nil) {
        self.id = id
        self.name = name
        self.completed = completed
        self.photoBase64 = photoBase64
        self.date = date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.photoBase64 = try container.decodeIfPresent(String.self, forKey: .photoBase64)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
