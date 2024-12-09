//
//  QuestionFormView.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/26/24.
//

import Foundation
import SwiftUI
import PhotosUI


enum QuestionFormError: Error {
    case AnswerRequired
    case Required(field: String)
}


public struct QuestionFormView: View {
    @Bindable public var question: Question
    @State private var editingChoice: Choice?
    @State var choicesError = ""
    @State var questionError = ""
    var submit: (_ question: Question) -> ()
    
    
    @Environment(\.dismiss) private var dismiss
    @State var prevImage: UIImage?
    
    
    public var body: some View {
        Form {
            Section(header: Text("Question"), footer: Text(questionError).foregroundStyle(.red)) {
                TextField(
                    "Title",
                    text: $question.name
                )
                // https://stackoverflow.com/questions/62741851/how-to-add-placeholder-text-to-texteditor-in-swiftui
                TextField("Question Text", text: $question.text, axis: .vertical)
                    .lineLimit(3...)
                
                HStack {
                    Spacer()
                    ZStack {
                        QuestionImagePicker(successHandler: { uiImage in
                            prevImage = uiImage
                            if let url = FileManager.writeToDisk(image: uiImage, imageName: $question.id.uuidString){
                                question.imageUrl = url
                            }
                        }, imageUrl: $question.imageUrl)
                    }
                    Spacer()
                }
                
            }
            
            Section(
                header: Text("Choices"),
                footer: Text(choicesError).foregroundStyle(.red)
            ) {
                List($question.choices) { choice in
                    Button(action: {
                        editingChoice = choice.wrappedValue
                    }) {
                        HStack {
                            Text(choice.wrappedValue.text)
                            if choice.wrappedValue.isAnswer {
                                Text("✅")
                            }
                        }
                    }
                    .foregroundColor(.black)
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            deleteChoice(choice.id)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                    }
                }
                Button("Add Choice", systemImage: "plus.circle", action: {
                    editingChoice = Choice(text: "new choice")
                })
                .sheet(item: $editingChoice) { choice in
                    ChoiceFormView(choice: choice.clone(), callback: upsertChoice)
                }
            }
        }
        .navigationTitle("Add a new question")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                questionError = validateQuestion()
                choicesError = validateChoices()
                
                if [questionError, choicesError].allSatisfy({ $0.isEmpty }) {
                    submit(question)
                    dismiss()
                }
            }
        }
    }
    
    func upsertChoice(_ newChoice: Choice) {
        if let ind = question.choices.firstIndex(where: { $0.id == newChoice.id  }) {
            question.choices[ind] = newChoice
        } else {
            question.choices.append(newChoice)
        }
        editingChoice = nil
    }
    
    func deleteChoice(_ id: UUID) {
        question.choices = question.choices.filter({ $0.id != id })
    }
    
    func validateQuestion() -> String {
        var errorText = ""
        if(question.name.isEmpty) {
            errorText += "Name cannot be empty; "
        }
        if(question.text.isEmpty) {
            errorText += "Text cannot be empty; "
        }
        return errorText
    }
    
    func validateChoices() -> String {
        if(question.choices.isEmpty) {
            return "There must at least one choice!"
        }
        if(question.choices.filter({ $0.isAnswer }).isEmpty) {
            return "At least one of the choices should be an answer"
        }
        return ""
    }
    
}

#Preview {
    return NavigationStack {
        QuestionFormView(
            question: Question(name: "test name", text: "test text", choices: [
                Choice(text: "Test Choice")
            ]
                              ),
            submit: { _ in
                
            }
        )
        
    }
}
