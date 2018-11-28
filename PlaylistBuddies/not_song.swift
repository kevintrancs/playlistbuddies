//
//  Song.swift
//  PlaylistBuddies
//
//  Created by Kevin Tran on 11/26/18.
//  Copyright © 2018 Kevin Tran. All rights reserved.
//

import Foundation


class Song: Codable {
    var title: String = "Test_title"
    var artist: String = "Test_artist"
    var album: String = "Test_album "
    
    init(title: String, artist: String, album: String) {
        self.title = title
        self.artist = artist
        self.album = album
    }
}


class Playlist: Codable{
    var songs: [Song]
    var id: String
    var password: String
    init(songs: [Song], id: String, password: String) {
        self.songs = songs
        self.id = id
        self.password = password
    }
}
