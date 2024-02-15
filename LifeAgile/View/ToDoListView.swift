//
//  ToDoListView.swift
//  LifeAgile
//
//  Created by Keith on 2/12/24.
//

import SwiftUI

struct ToDoListView: View {
    @EnvironmentObject var toDoListViewModel: ToDoListViewModel
    @State private var showingForm = false
    @State private var newToDoTitle = ""
    @State private var todoToDelete: ToDo? = nil
    @State private var todoToEdit: ToDo? = nil
    @State private var isAlertShown = false
    @Binding var selectedToDo: ToDo?
    
    var body: some View {
        VStack {
            List {
                ForEach(toDoListViewModel.todos, id: \.id) { todo in
                    HStack {
                        Button {
                            self.selectedToDo = todo
                        } label: {
                            Text(todo.title)
                                .font(.title2)
                        }
                        Spacer()
                        Text(self.toDoListViewModel.formattedDurationTime(for: todo))
                        Button {
                            self.todoToEdit = todo
                            self.showingForm.toggle()
                        } label: {
                            Image(systemName: "pencil")
                        }
                        Button {
                            self.todoToDelete = todo
                            self.isAlertShown = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            
            Button(action: {
                showingForm.toggle()
            }, label: {
                Text("목표 추가하기")
            }).padding()
        }
        .sheet(isPresented: $showingForm) {
            VStack{
                if let todoToEdit = self.todoToEdit {
                    TextField("Enter ToDo title", text: $newToDoTitle)
                        .padding()
                        .onAppear {
                            self.newToDoTitle = todoToEdit.title
                        }
                } else {
                    TextField("Enter ToDo title", text: $newToDoTitle)
                        .padding()
                }
                
                Button("Save") {
                    if let todoToEdit = self.todoToEdit {
                        var copyToDoEdit = todoToEdit
                        copyToDoEdit.title = newToDoTitle
                        toDoListViewModel.putToDo(todo: copyToDoEdit)
                    } else {
                        let newToDo = ToDo(id: UUID().uuidString, title: newToDoTitle, createdAt: toDoListViewModel.currentDate(), duration: 0)
                        toDoListViewModel.PostToDo(todo: newToDo)
                    }
                    showingForm.toggle()
                    newToDoTitle = ""
                }
                .padding()
            }
        }
        .padding()
        .alert(isPresented: $isAlertShown) {
            Alert(
                title: Text("Confirm"),
                message: Text("목표를 정말 삭제하시겠습니까?"),
                primaryButton: .destructive(Text("Delete")) {
                    if let todoToDelete = self.todoToDelete {
                        toDoListViewModel.deleteToDo(withId: todoToDelete.id)
                    }
                },
                secondaryButton: .cancel()
            )
        }
    }
}

#Preview {
    ToDoListView(selectedToDo: Binding<ToDo?>.constant(nil))
}
