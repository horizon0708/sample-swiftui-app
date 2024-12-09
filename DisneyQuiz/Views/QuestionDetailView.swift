//
//  QuestionDetail.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/25/24.
//

import Foundation
import SwiftUI

public struct QuestionDetailView: View {
    let question: Question
    @State var pickedChoice: Choice?
    
    public var body: some View {
        if let pickedChoice {
            Text(pickedChoice.isAnswer ?
                "Correct!":
                "Wrong! Try Again!")
        }
        List(question.choices) { choice in
            Button(action: {
                pickedChoice = choice
            }) {
                Text(choice.text)
            }
        }
    }
}

#Preview {
    QuestionDetailView(question: sampleQuestions[0])
}
