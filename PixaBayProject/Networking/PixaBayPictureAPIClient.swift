

import Foundation
import UIKit

class PictureAPIClient {
    static let manager = PictureAPIClient()
   
  
    func getPicturesFromAPI(searchTerm:String,completionHandler:@escaping(Result<[Hit],AppError>)-> Void ) {
        
        let urlString = "https://pixabay.com/api/?q=\(searchTerm.replacingOccurrences(of: " ", with: "_"))&key=\(Secrets.pixaBayKey.lowercased())&page=1&per_page=15"
            
               guard let url  = URL(string: urlString) else {
                   completionHandler(.failure(.badURL))
                   return
               }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let urlSession = URLSession(configuration: .default)
    
        urlSession.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                
            
            guard let data = data else {
                completionHandler(.failure(.noDataReceived))
                return
            }
              guard let response = response as? HTTPURLResponse, (200...299) ~= response.statusCode else {
                completionHandler(.failure(.badStatusCode))
                              return
            }
            if let error = error {
                completionHandler(.failure(.other(rawError: error)))
            }
            do {
                let pixaBayData = try Hit.returnDataAsHitArray(data: data)
                completionHandler(.success(pixaBayData ?? []))
            } catch {
    completionHandler(.failure(.couldNotParseJSON(rawError: error)))
            }
            }
        }.resume()
    }
    
   
}
