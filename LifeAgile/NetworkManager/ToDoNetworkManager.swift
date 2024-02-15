//
//  ToDoNetworkManager.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import Foundation

class ToDoNetworkManager {
    static let shared = ToDoNetworkManager()
    
    private let baseURLString = "https://65c22e16f7e6ea59682acdf8.mockapi.io/todos"
    
    private init() {}
    
    // MARK: -  POST TODO
    func postNetworkToDo(todo: ToDo, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: baseURLString) else {
            completion(false, "잘못된 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(todo)
            request.httpBody = jsonData
        } catch {
            completion(false, "데이터를 인코딩하는 중 오류 발생")
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 201 else {
                completion(false, "응답이 없습니다.")
                return
            }
            
            completion(true, nil)
        }.resume()
    }

    
    // MARK: - PUT TODO
    func putNetworkToDo(todo: ToDo, completion: @escaping(Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURLString)/\(todo.id)") else {
            completion(false, "잘못된 URL")
            return
        }
        
        var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonData = try JSONEncoder().encode(todo)
            request.httpBody = jsonData
        } catch {
            completion(false, "데이터를 인코딩하는 중 오류 발생")
            return
        }
            
        let _: Void = URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion(false, "url에 문제가 있음")
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false, "URL에서 응답 없음")
                return
            }
            
            completion(true, nil)
        }.resume()
        
    }
    
    
    // MARK: - REQUEST TODO
    func requestNetworkToDo(completion: @escaping ([ToDo]?, String?) -> Void) {
        guard let url = URL(string: baseURLString) else {
            completion(nil, "잘못된 URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(nil, "응답이 없습니다.")
                return
            }
            
            guard let data = data else {
                completion(nil, "데이터를 받지 못했습니다.")
                return
            }
            
            do {
                let decodedToDo = try JSONDecoder().decode([ToDo].self, from: data)
                completion(decodedToDo, nil)
            } catch {
                completion(nil, "데이터를 디코딩하는 중 오류 발생")
            }
        }.resume()
    }
    
    // MARK: - DELETE TODO
    func deleteNetworkToDo(withId id: String, completion: @escaping (Bool, String?) -> Void) {
        guard let url = URL(string: "\(baseURLString)/\(id)") else {
            completion(false, "잘못된 URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(false, error.localizedDescription)
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completion(false, "응답이 없습니다.")
                return
            }
            
            completion(true, nil)
        }.resume()
    }
}
