//
//  TaskListView.swift
//

import SwiftUI

struct TaskListView: View {
    @ObservedObject var taskStore: TaskStore
    var tasks: [Task]
    @State private var searchText = ""

    var tasksSearch: [Task] {
        if searchText.isEmpty {
            return tasks
        } else {
            return tasks.filter { $0.title.contains(searchText) }
        }
    }

    var body: some View {
        NavigationStack {
            List(tasksSearch, id: \.self) { task in
                NavigationLink(value: task) {
                    VStack {
                        TaskRowView(task: task, taskStore: taskStore)
                    }
                    .padding([.leading, .trailing], 20)
                }
            }
            .navigationDestination(for: Task.self) { task in
                TaskDetailView(task: $taskStore.tasks
                    .first(where: { $0.id == task.id })!)
            }
            .listStyle(.inset)
            .navigationTitle("My Tasks")
            .toolbar {
                if tasks.first?.isCompleted == false {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        NewTaskButtonView(taskStore: taskStore)
                    }
                }
            }
        }
        .searchable(text: $searchText)
    }
}

struct TaskListView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            TaskListView(taskStore: TaskStore(), tasks: Task.example)
        }
    }
}
