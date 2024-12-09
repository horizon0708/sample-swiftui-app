//
//  ChoiceFormView.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/26/24.
//

import SwiftUI

struct ChoiceFormView: View {
    @Bindable public var choice: Choice
    @State private var choiceValidationText = ""
    public var callback: (_ choice: Choice) -> ()
    var body: some View {
        Form {
            Section(header: Text("Choice"), footer: Text(choiceValidationText).foregroundStyle(.red)) {
                TextField("Choice", text: $choice.text)
                TextField("Description", text: $choice.explanation, axis: .vertical)
                    .lineLimit(2...)
                Toggle("Is Answer", isOn: $choice.isAnswer)
            }
            
            HStack {
                Button(action: {
                    if isValid(name: choice.text) {
                        callback(choice)
                    }
                }) {
                    Text("Save")
                }
            }
        }
    }
    
    func isValid(name: String) -> Bool {
        if(name.isEmpty) {
            choiceValidationText = "Choice cannot be empty"
            return false
        }
        choiceValidationText = ""
        return true
    }
}

#Preview {
    ChoiceFormView(
        choice: Choice(text: "test choice"),
        callback: { choice in
        })
}
