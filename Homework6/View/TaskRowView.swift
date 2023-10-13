//
//  TaskRow.swift
//

import SwiftUI

struct TaskRowView: View {
    var task: Task
    @ObservedObject var taskStore: TaskStore

    @State private var animate = false
    @State private var scaleEffect = 1.0

    var body: some View {
        HStack {
            Text(task.title)
            Spacer()
            Button {
                animate.toggle()
                scaleEffect = 1.5

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    taskStore.toggleTaskCompletion(task: task)
                }
            } label: {
                Image(systemName: task.isCompleted || animate ? "checkmark.square" : "square")
                    .foregroundColor(task.isCompleted || animate ? Color.green : Color.red)
                    .scaleEffect(scaleEffect)
            }
            .buttonStyle(.plain)
        }
        .font(.title3)
        .bold()
        .padding([.top, .bottom], 15)
        .padding([.leading, .trailing], 10)
    }
}

struct TaskRow_Previews: PreviewProvider {
    static var previews: some View {
        TaskRowView(task: Task(title: "My Task", category: .noCategory, isCompleted: false), taskStore: TaskStore())
    }
}
