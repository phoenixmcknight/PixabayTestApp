

import Foundation
import UIKit

class PictureAPIClient {
    static let manager = PictureAPIClient()
    
   private lazy var baseURL: URL = {
      return URL(string: "https://pixabay.com")!
    }()
    
//    let session: URLSession
//
//    init(session: URLSession = URLSession.shared) {
//      self.session = session
//
//    }
    
   
  
    func getPicturesFromAPI(requestTwo:PixaRequest,searchTerm:String,currentPage:Int,completionHandler:@escaping(Result<[Hit],AppError>)-> Void ) {
        
      
        
        let parameters = ["page":"\(currentPage)","q":searchTerm.replacingOccurrences(of: " ", with: "_")].merging(requestTwo.parameters, uniquingKeysWith: +)
        
      
        var request = URLRequest(url: baseURL.appendingPathComponent(requestTwo.path)).encode(with: parameters)
        
        request.httpMethod = requestTwo.method.rawValue
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
    
        
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
