//
//  SpotifyFunc.swift
//  StoryTunes
//
//  Created by Daniel Truong on 5/17/24.
//

import Foundation

func searchSpotifyTracks(searchQuery: String, accessToken: String, completion: @escaping (Result<Data, Error>) -> Void) {
    // URL-encode the search query to handle spaces and special characters
    guard let encodedQuery = searchQuery.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid search query"])))
        return
    }

    // Construct the URL for the Spotify search API endpoint
    let urlString =     "https://api.spotify.com/v1/search?q=\(encodedQuery)&type=track&market=NA"

    print(urlString)
    guard let url = URL(string: urlString) else {
        completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
        return
    }

    // Prepare the HTTP request
    var request = URLRequest(url: url)
    request.httpMethod = "GET"
    request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

    // Perform the HTTP request
    let task = URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            // Handle errors, such as network issues
            completion(.failure(error))
            return
        }

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            // Handle HTTP errors
            completion(.failure(NSError(domain: "", code: httpResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed with HTTP code: \(httpResponse.statusCode)"])))
            return
        }

        if let data = data {
            completion(.success(data))
        } else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
        }
    }

    task.resume()
}
