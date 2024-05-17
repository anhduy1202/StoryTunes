//
//  SpotifyModel.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import Foundation

struct SpotifySearchResponse: Codable {
    let tracks: TracksResponse
}

struct TracksResponse: Codable {
    let items: [TrackItem]
}

struct TrackItem: Codable {
    let album: Album
    let artists: [Artist]
    let name: String  // Track name
}

struct Album: Codable {
    let images: [SpotifyImage]
}

struct Artist: Codable {
    let name: String
}

struct SpotifyImage: Codable {
    let url: String
    let height: Int
    let width: Int
}

func parseSpotifyTracks(from jsonData: Data) -> [TrackItem] {
    let decoder = JSONDecoder()
    do {
        let response = try decoder.decode(SpotifySearchResponse.self, from: jsonData)
        return response.tracks.items
    } catch {
        print("Failed to decode JSON: \(error)")
        return []
    }
}
