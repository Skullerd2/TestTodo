
import Foundation

extension String {
    func formattedDate(from inputFormat: String = "yyyy-MM-dd",
                        to outputFormat: String = "dd.MM.yyyy") -> String? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = inputFormat
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        guard let date = inputFormatter.date(from: self) else { return nil }
        
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = outputFormat
        return outputFormatter.string(from: date)
    }
}
