//
//  TimerView.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import SwiftUI


struct TimerView: View {
    @ObservedObject private var timerViewModel = TimerViewModel()
    @Binding var selectedToDo: ToDo?
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .stroke(lineWidth: 20)
                    .opacity(0.3)
                    .foregroundColor(.gray)
                
                Circle()
                    .trim(from: 0.0, to: timerViewModel.progress)
                    .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round, lineJoin: .round))
                    .foregroundColor(.red)
                    .rotationEffect(Angle(degrees: -90))
                
                Text("\(timerViewModel.formattedElapsedTime)")
                    .font(.largeTitle)
                    .bold()
            }
            .padding()
           
            HStack {
                // MARK: - Start, Break 버튼
                Button(action: {
                    if timerViewModel.isTimerOn {
                        timerViewModel.stopTimer()
                    } else {
                        timerViewModel.startTimer()
                    }
                    
                    timerViewModel.isTimerOn.toggle()
                }, label: {
                    Text(timerViewModel.isTimerOn ? TimerViewModel.TimerType.stop.description : TimerViewModel.TimerType.start.description)
                })
                .disabled(selectedToDo == nil)
                
                // MARK: - putToDo 버튼
                Button(action: {
                    guard var selectedToDo = selectedToDo else {
                        return
                    }
                    timerViewModel.putTimerToDo(selectedToDo: &selectedToDo)
                }, label: {
                    Text(TimerViewModel.TimerType.reset.description)
                })
                .disabled(selectedToDo == nil)
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    TimerView(selectedToDo: Binding<ToDo?>.constant(nil))
}
