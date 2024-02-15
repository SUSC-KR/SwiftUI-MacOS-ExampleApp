//
//  NetworkManager.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    
    private init() { }
    
    
    func requestNetworkToDo(completed: @escaping ([ToDo]?, String? ) -> ()){
        let endPoint = "https://65c22e16f7e6ea59682acdf8.mockapi.io/todos"
        
        guard let url = URL(string: endPoint) else {
            completed(nil, "잘못된 URL")
            return
        }
        
        let _: Void = URLSession.shared.dataTask(with: url) {data, response, error in
            print("Task", url)

            print(data, response, error)
            if error != nil {
                completed(nil, "url에 문제가 있음")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "URL에서 응답 없음")
                return
            }
            guard let data = data else {
                completed(nil, "데이터를 받지 못했습니다.")
                return
            }
            
            do {
                print("do")
                let decodedToDo = try JSONDecoder().decode([ToDo].self, from: data)
                completed(decodedToDo, nil)
            } catch {
                print(error)
            }
        }.resume()
    }
}

