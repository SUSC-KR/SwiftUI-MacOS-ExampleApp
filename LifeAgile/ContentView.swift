//
//  ContentView.swift
//  LifeAgile
//
//  Created by Keith on 2/11/24.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject private var toDoListViewModel = ToDoListViewModel()
    @State var selectedToDo: ToDo?
    
    var body: some View {
        VStack {
            if let todo = selectedToDo {
                Text("Selected GOAL: \(todo.title)")
            } else {
                Text("No GOAL selected")
            }
            HStack {
                ToDoListView(selectedToDo: $selectedToDo)
                TimerView(selectedToDo: $selectedToDo)
            }
        }
        .padding()
        .onAppear{
            toDoListViewModel.requestToDo()
        }
        .environmentObject(toDoListViewModel)
    }
}


#Preview {
    ContentView()
}
