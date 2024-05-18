//
//  SpotifyAuth.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import Foundation
import SwiftUI

class SpotifySession: ObservableObject {
    @Published var accessToken: String?
    @Published var tracks: [TrackItem] = []
    @Published var currentTrack: TrackItem?
    
    // Function to fetch the access token
    func fetchAccessToken() {
        // Implementation of token fetching
        fetchSpotifyAccessToken { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let token):
                    self.accessToken = token
                case .failure(let error):
                    print("Error fetching token: \(error)")
                    self.accessToken = nil
                }
            }
        }
    }
    func fetchTracks(searchQuery: String) {
         guard let token = accessToken, !searchQuery.isEmpty else {
             print("Access token is unavailable or query is empty.")
             return
         }

         let urlString = "https://api.spotify.com/v1/search?q=\(searchQuery)&type=track&limit=20"
         guard let url = URL(string: urlString) else { return }

         var request = URLRequest(url: url)
         request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

         URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
             guard let data = data, error == nil else { return }

             DispatchQueue.main.async {
                 self?.tracks = self?.parseSpotifyTracks(from: data) ?? []
             }
         }.resume()
     }

     private func parseSpotifyTracks(from jsonData: Data) -> [TrackItem] {
         let decoder = JSONDecoder()
         do {
             let response = try decoder.decode(SpotifySearchResponse.self, from: jsonData)
             return response.tracks.items
         } catch {
             print("Failed to decode JSON: \(error)")
             return []
         }
     }
}
struct SpotifyAuth: Codable {
    let accessToken: String
    let tokenType: String
    let expiresIn: Int

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case expiresIn = "expires_in"
    }
}

func fetchSpotifyAccessToken(completion: @escaping (Result<String, Error>) -> Void) {
    let url = URL(string: "https://accounts.spotify.com/api/token")!
    let clientId = ProcessInfo.processInfo.environment["CLIENT_ID"] ?? ""
    let clientSecret = ProcessInfo.processInfo.environment["CLIENT_SECRET"] ?? ""
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
    request.addValue("Basic \((clientId + ":" + clientSecret).data(using: .utf8)!.base64EncodedString())", forHTTPHeaderField: "Authorization")

    let bodyParameters = "grant_type=client_credentials"
    request.httpBody = bodyParameters.data(using: .utf8)
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        guard let data = data, error == nil else {
            completion(.failure(error!))
            return
        }

        do {
            let auth = try JSONDecoder().decode(SpotifyAuth.self, from: data)
            completion(.success(auth.accessToken))
        } catch {
            completion(.failure(error))
        }
    }

    task.resume()
}
