//
//  PlaylistAPI.swift
//  PlaylistBuddies
//
//  Created by Kevin Tran on 11/27/18.
//  Copyright © 2018 Kevin Tran. All rights reserved.
//

import Foundation

struct PlaylistAPI {
    
    static let baseURL = "http://0.0.0.0:5000/api/playlist"
    
    // connect
    static func playlist_url() -> URL{
        let params = ["name":"test_playlist", "pass":"test"]
        
        var queryItems = [URLQueryItem]()
        for (key, value) in params {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        var components = URLComponents(string: PlaylistAPI.baseURL)!
        components.queryItems = queryItems
        let url = components.url!
        return url
    }
    
    static func get_playlist(completion: @escaping (String?) -> Void){
        let url = PlaylistAPI.playlist_url()
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonDict = jsonObject as? [String: Any], let array = jsonDict["value"] as? [[String:Any]]
                    else{
                        print("failed")
                            completion(nil)
                            return
                    }
                    if let playlist = array.first{
                        print(playlist["playlist"])
                    }
                    
                }
                catch{
                    print("error on json \(error)")
                }
            
                DispatchQueue.main.async {
                    completion(dataString)
                }
            }
            else {
                if let error = error {
                    print("Error getting photos JSON response \(error)")
                }
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
        task.resume()
    }
    
}
