//
//  Command.swift
//  Places App
//
//  Created by Shashwat  on 04/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation

class PlacesCommand  {
    func getDataForUrl(_ url : URL, responseHandler : @escaping (Result<[Any],ResponseError>) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil, data != nil {
                if let _ = data {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        if let jsonDict = json as? [String:Any]{
                            let results = jsonDict["results"]
                            if let status = jsonDict["status"] as? String {
                                if status == "OVER_QUERY_LIMIT" {
                                    responseHandler(.failure(ResponseError.limitExceeded("OVER_QUERY_LIMIT")))
                                }
                            }
                            
                            if let resultArray = results as? [[String:Any]] {
                                responseHandler(.success(resultArray))
                            }
                        }
                    }
                }
            }else {
                if let response = response as? HTTPURLResponse {
                    responseHandler(.failure(ResponseError.errorCode(response.statusCode)))
                }else{
                    responseHandler(.failure(ResponseError.unknown))
                }
            }
        }
        dataTask.resume()
    }
}
