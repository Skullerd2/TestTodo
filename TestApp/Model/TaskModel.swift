import Foundation
import UIKit

struct TaskModel: Decodable {
    let id: Int
    var name: String
    var completed: Bool
    var photoBase64: Data?
    var date: String
    
    enum CodingKeys: CodingKey {
        case id
        case name
        case completed
        case photoBase64
        case date
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.completed = try container.decode(Bool.self, forKey: .completed)
        self.photoBase64 = try container.decodeIfPresent(Data.self, forKey: .photoBase64)
        self.date = try container.decode(String.self, forKey: .date)
    }
}
