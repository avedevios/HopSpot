//
//  NetworkManager.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class NetworkManager {
    
    private let session: URLSession = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 10
        config.timeoutIntervalForResource = 10
        return URLSession(configuration: config)
    }()
    
    // Fetches lightweight list items with pagination
    func getBeerList(page: Int, perPage: Int, completion: @escaping ([BeerListItem], Bool) -> ()) {
        print("🌐 NetworkManager: Starting beer list request (page \(page), per_page \(perPage))...")
        guard let url = URL(string: "https://punkapi-alxiw.amvera.io/v3/beers?page=\(page)&per_page=\(perPage)") else {
            print("❌ Invalid URL")
            completion([], false)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                let isTimeout = (error as NSError).code == NSURLErrorTimedOut
                print("❌ Network error: \(error)")
                DispatchQueue.main.async {
                    completion([], isTimeout)
                }
                return
            }
            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    completion([], false)
                }
                return
            }
            print("🌐 Received data: \(data.count) bytes")
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let beers = try JSONDecoder().decode([BeerListItem].self, from: data)
                    print("✅ Successfully decoded \(beers.count) list items")
                    DispatchQueue.main.async {
                        completion(beers, false)
                    }
                } catch {
                    print("❌ JSON decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion([], false)
                    }
                }
            }
        }
        task.resume()
    }
    
    // Fetches full beer details by id — called only when opening the detail screen
    func getBeerDetails(id: Int, completion: @escaping (Beer?) -> ()) {
        print("🌐 NetworkManager: Fetching details for beer id=\(id)...")
        guard let url = URL(string: "https://punkapi-alxiw.amvera.io/v3/beers/\(id)") else {
            print("❌ Invalid URL for id \(id)")
            completion(nil)
            return
        }
        
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ NetworkManager: Network error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                print("❌ NetworkManager: No data received")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            print("🌐 NetworkManager: Received \(data.count) bytes for beer details")
            
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let beer = try JSONDecoder().decode(Beer.self, from: data)
                    print("✅ NetworkManager: Successfully decoded beer details")
                    DispatchQueue.main.async {
                        completion(beer)
                    }
                } catch {
                    print("❌ NetworkManager: JSON decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion(nil)
                    }
                }
            }
        }
        task.resume()
    }
}
