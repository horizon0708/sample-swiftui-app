//
//  SwiftUIView.swift
//  DisneyQuiz
//
//  Created by James Kim on 12/1/24.
//

import SwiftUI

// Unfinished quiz view
struct QuizView: View {
    public var questions: [Question]
    @State var currentQuestionIndex = 0;
    @State var correctAnswerCount = 0;
    @State var pickedChoice: Choice? {
        didSet {
            if let choice = pickedChoice, choice.isAnswer {
                correctAnswerCount += 1
            }
        }
    }
    @State var isDone: Bool = false
    
    var currentQuestion: Question {
        get {
            return questions[currentQuestionIndex]
        }
    }
    
    var body: some View {
        List(currentQuestion.choices) { choice in
            Button(choice.text) {
                pickedChoice = choice
            }
        }
        .alert("Quiz done", isPresented: $isDone) {
            Button("Okay") {
                
            }
        } message: {
            Text("Quiz Done!")
        }
    }
    
    func goToNextQuestion() {
        // if nothing was picked then you can't go to the next question
        if(pickedChoice == nil) {
            return
        }
        pickedChoice = nil
        if(currentQuestionIndex + 1 < questions.count) {
            currentQuestionIndex += 1
        } else {
            isDone = true
        }
    }
    
}

#Preview {
    QuizView(questions: sampleQuestions)
}
