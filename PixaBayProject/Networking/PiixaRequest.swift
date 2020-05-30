

import Foundation

enum Methods:String {
          case GET
          case POST
      }

struct PixaRequest {
  var path: String {
    return "api"
  }
    
    var method:Methods = .GET
  
  
  var parameters: Parameters = ["key": "\(Secrets.pixaBayKey)",  "per_page": "10"]
    
    mutating func changePerPage(perPage:Int) {
     parameters["per_page"] = String(perPage)
    }
    
}

//extension PixaRequest {
//  static func from() -> PixaRequest {
//    let defaultParameters = ["key": "\(Secrets.pixaBayKey)",  "per_page": "5"]
//   //let parameters = ["q": searchTerm.replacingOccurrences(of: " ", with: "_")].merging(defaultParameters, uniquingKeysWith: +)
//    return PixaRequest(parameters: defaultParameters)
//  }
    
//}

