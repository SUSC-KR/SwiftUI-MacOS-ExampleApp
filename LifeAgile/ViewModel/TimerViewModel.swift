//
//  TimerViewModel.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import Foundation

class TimerViewModel: ObservableObject {
    @Published var elapsedTime: TimeInterval = 0
    @Published var isTimerOn: Bool = false
    @Published var timer: Timer? = nil
    let toDoListViewModel = ToDoListViewModel()
    
    let timerInterval: TimeInterval = 1
    let totalDuration: TimeInterval = 60 * 60
    
    enum TimerType {
        case start
        case stop
        case reset
        
        var description: String {
            switch self {
                
            case .start:
                "Start"
            case .stop:
                "Break"
            case .reset:
                "Reset"
            }
        }
    }
    
    var progress: CGFloat {
        CGFloat(elapsedTime / totalDuration)
    }
    
    var formattedElapsedTime: String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter.string(from: elapsedTime) ?? "00:00:00"
    }
    
    func putTimerToDo(selectedToDo: inout ToDo) {
        selectedToDo.duration += Int(elapsedTime)
        let copySelectedToDo = selectedToDo // 선택된 ToDo를 복사합니다.
        DispatchQueue.main.async {
            self.putToDo(todo: copySelectedToDo)
        }
        print("Timer added to ToDo: \(selectedToDo.title)")
        
        resetTimer()
    }
    
    func putToDo(todo: ToDo) {
        ToDoNetworkManager.shared.putNetworkToDo(todo: todo) { success, errorMessage in
            DispatchQueue.main.async {
                if success {
                    print("ToDo가 성공적으로 수정되었습니다.")
                    self.toDoListViewModel.requestToDo()
                } else {
                    if let errorMessage = errorMessage {
                        print("ToDo 수정 실패: \(errorMessage)")
                    } else {
                        print("ToDo 수정 실패")
                    }
                }
            }
        }
    }
    
    
    func resetTimer() {
        elapsedTime = 0
        isTimerOn = false
        stopTimer()
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: timerInterval, repeats: true) { timer in
            self.elapsedTime += self.timerInterval
            if self.elapsedTime >= self.totalDuration {
                timer.invalidate()
            }
        }
    }
}
