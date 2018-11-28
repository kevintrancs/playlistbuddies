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
    static func playlist_url(name: String, password: String) -> URL{
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
    
    static func convert_to_string(playlist: Playlist) -> String?{
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(playlist)
            let json_string = String(data: jsonData, encoding: String.Encoding.utf8)
            return json_string!
        }
        catch{
            print("I dun goofed.")
            return nil
        }
        return nil
    }
    
    static func convert_to_playlist(json: String) -> Playlist?{
        do{
            let jsonDecoder = JSONDecoder()
            let playlist = try jsonDecoder.decode(Playlist.self, from: json.data(using: .utf8)!)
            return playlist
        }
        catch{
            print("I dun goofed.")
            return nil
        }
        return nil
    }
    
    static func sample_playlist(){
        var s = [Song]()
        let song = Song(title: "test", artist: "test", album: "test")
        let song2 = Song(title: "test", artist: "test", album: "test")
        s.append(song)
        s.append(song2)
        var playlist = Playlist(songs: s, id: "test_name", password: "test")
        let jsonEncoder = JSONEncoder()
        do{
            let jsonData = try jsonEncoder.encode(playlist)
            let json = String(data: jsonData, encoding: String.Encoding.utf8)
        }
        catch{
            print("I dun goofed.")
        }
    }
    
    // holy shit this is ugly
    static func get_playlist(name: String, password: String, completion: @escaping (String?) -> Void){
        let url = PlaylistAPI.playlist_url(name: name, password: password)
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if let data = data, let dataString = String(data: data, encoding: .utf8){
                do{
                    let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let jsonDict = jsonObject as? [String: Any], let array = jsonDict["value"] as? [[String: Any]]
                    else{
                        print("failed")
                            completion(nil)
                            return
                    }
                    if let playlist = array.first{
                        let my_list = playlist["playlist"] as! String
                        var the_play = PlaylistAPI.convert_to_playlist(json: my_list)
                        print(the_play?.songs[0].title)
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
