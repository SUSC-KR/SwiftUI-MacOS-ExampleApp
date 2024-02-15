//
//  ToDoListViewModel.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import Foundation

class ToDoListViewModel: ObservableObject {
    @Published var todos = [ToDo]()
    
    func currentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: Date())
    }
    
    func formattedDurationTime(for todo: ToDo) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: TimeInterval(todo.duration)) ?? "00:00:00"
    }
    

    func requestToDo() {
        ToDoNetworkManager.shared.requestNetworkToDo { response, error in
            DispatchQueue.main.async {
                print("데이터 가져오기")
                guard let response = response else {
                    print("NetWork에서 ToDo를 받아오는데 실패했습니다.")
                    return
                }
                self.todos = response
                self.objectWillChange.send()
                print(self.todos)
            }
        }
    }
    
    func putToDo(todo: ToDo) {
        ToDoNetworkManager.shared.putNetworkToDo(todo: todo) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("ToDo가 성공적으로 수정되었습니다.")
                    self.requestToDo()
                } else {
                    if let errorMessage = errorMessage {
                        print("ToDo 수정 실패: \(errorMessage)")
                    } else {
                        print("ToDo 수정 실패")
                    }
                }
                print(self.todos)
            }
        }
    }

    
    func PostToDo(todo: ToDo) {
        ToDoNetworkManager.shared.postNetworkToDo(todo: todo) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("ToDo가 성공적으로 추가되었습니다.")
                    self.requestToDo()
                } else {
                    if let errorMessage = errorMessage {
                        print("ToDo 추가 실패: \(errorMessage)")
                    } else {
                        print("ToDo 추가 실패")
                    }
                }
            }
        }
    }
    
    func deleteToDo(withId id: String) {
        ToDoNetworkManager.shared.deleteNetworkToDo(withId: id) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("ToDo 삭제 성공")
                    self.requestToDo()
                } else {
                    print("ToDo 삭제 실패: \(errorMessage ?? "알 수 없는 오류")")
                }
            }
        }
    }
}
