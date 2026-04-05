//
//  NetworkManager.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class NetworkManager {
    
    // Fetches lightweight list items with pagination
    func getBeerList(page: Int, perPage: Int, completion: @escaping ([BeerListItem]) -> ()) {
        print("🌐 NetworkManager: Starting beer list request (page \(page), per_page \(perPage))...")
        guard let url = URL(string: "https://punkapi-alxiw.amvera.io/v3/beers?page=\(page)&per_page=\(perPage)") else {
            print("❌ Invalid URL")
            completion([])
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    completion([])
                }
                return
            }
            print("🌐 Received data: \(data.count) bytes")
            
            // Decode on background thread to avoid blocking UI
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let beers = try JSONDecoder().decode([BeerListItem].self, from: data)
                    print("✅ Successfully decoded \(beers.count) list items")
                    DispatchQueue.main.async {
                        completion(beers)
                    }
                } catch {
                    print("❌ JSON decoding error: \(error)")
                    DispatchQueue.main.async {
                        completion([])
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
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("❌ Network error: \(error)")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            // Decode on background thread to avoid blocking UI
            DispatchQueue.global(qos: .userInitiated).async {
                do {
                    let beers = try JSONDecoder().decode([Beer].self, from: data)
                    print("✅ Successfully decoded beer details")
                    DispatchQueue.main.async {
                        completion(beers.first)
                    }
                } catch {
                    // If array decoding fails, try decoding as single object
                    do {
                        let beer = try JSONDecoder().decode(Beer.self, from: data)
                        print("✅ Successfully decoded single beer object")
                        DispatchQueue.main.async {
                            completion(beer)
                        }
                    } catch {
                        print("❌ JSON decoding error: \(error)")
                        DispatchQueue.main.async {
                            completion(nil)
                        }
                    }
                }
            }
        }
        task.resume()
    }
}
