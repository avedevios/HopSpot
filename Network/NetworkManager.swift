//
//  NetworkApi.swift
//  HopSpot
//
//  Created by ake11a on 2022-11-20.
//

import Foundation

class NetworkManager {
    
    func getBeerList(completion: @escaping ([Beer]) -> ())  {
        let url = URL(string: "https://punkapi-alxiw.amvera.io/v3/beers?page=1&per_page=80")
        let request = URLRequest(url: url!)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            DispatchQueue.main.async{
                guard let data = data,
                      let response = try? JSONDecoder().decode([Beer].self, from: data) else {
                    completion([])
                    return
                }
                completion(response.shuffled())
            }
        }
        task.resume()
    }
}
