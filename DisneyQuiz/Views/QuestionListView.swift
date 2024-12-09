//
//  QuestionListView.swift
//  DisneyQuiz
//
// https://developer.apple.com/documentation/swiftui/navigationstack
//  Created by James Kim on 11/26/24.
//

import SwiftUI

enum Player {
    case running
    case jumping
    case dead
}

struct QuestionListView: View {
    @State var questions = sampleQuestions
    
    var body: some View {
        NavigationStack {
            List{
                ForEach(questions) { question in
                    NavigationLink(question.name, value: question.id)
                }
                .onMove { from, to in
                    questions.move(fromOffsets: from, toOffset: to)
                }
                .onDelete { from in
                    questions.remove(atOffsets: from)
                }
                NavigationLink(
                    destination: QuestionFormView(question: Question(), submit: { question in
                        questions.append(question)
                    })
                ) {
                    Button("New Question", systemImage: "plus"){}
                }
                
            }
            .navigationDestination(for: UUID.self) { questionId in
                if let index =  questions.firstIndex(where: { $0.id == questionId}) {
                    QuestionFormView(question: questions[index].clone(), submit: {editedQuestion in
                        questions[index] = editedQuestion
                    })
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Question")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    
                }
            }
        }
    }
}

#Preview {
    QuestionListView()
}
