//
//  Command.swift
//  Places App
//
//  Created by Shashwat  on 04/06/19.
//  Copyright © 2019 Shashwat . All rights reserved.
//

import Foundation

class PlacesCommand  {
    func getDataForUrl(_ url : URL, responseHandler : @escaping (Result<[Any],Error>) -> ()) {
        let dataTask = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error == nil {
                if let _ = data {
                    if let json = try? JSONSerialization.jsonObject(with: data!, options: []) {
                        if let jsonDict = json as? [String:Any]{
                            let results = jsonDict["results"]
                            if let resultArray = results as? [[String:Any]] {
                                responseHandler(.success(resultArray))
                            }
                        }
                    }
                }
            }else {
                responseHandler(.failure(error!))
            }
        }
        dataTask.resume()
    }
}
