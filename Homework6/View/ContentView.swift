//
//  ContentView.swift
//

import SwiftUI

struct ContentView: View {
    @StateObject var taskStore = TaskStore()

    var body: some View {
        TabView {
            Group {
                if taskStore.incompleteTasks.isEmpty {
                    Text("No completed tasks found.")
                } else {
                    TaskListView(
                        taskStore: taskStore,
                        tasks: taskStore.incompleteTasks
                    )
                }
            }
            .tabItem {
                Label(
                    "Tasks",
                    systemImage: "list.bullet.circle"
                )
            }
            Group {
                if taskStore.completedTasks.isEmpty {
                    Text("No tasks found.")
                } else {
                    TaskListView(
                        taskStore: taskStore,
                        tasks: taskStore.completedTasks
                    )
                }
            }
            .tabItem {
                Label(
                    "Completed",
                    systemImage: "checkmark.circle"
                )
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        TabView {
            ContentView()
        }
    }
}
