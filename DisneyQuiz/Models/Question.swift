//
//  Question.swift
//  DisneyQuiz
//
//  Created by James Kim on 11/25/24.
//

import Foundation
import SwiftUI
import PhotosUI
import SwiftData

@Observable public class Choice: Identifiable {
    public var id = UUID()
    public var text = ""
    public var explanation = ""
    public var isAnswer = false
    
    init(text: String, isAnswer: Bool = false) {
        self.text = text
        self.isAnswer = isAnswer
    }
    
    func clone() -> Choice {
        let newChoice = Choice(text: self.text)
        newChoice.id = self.id
        newChoice.explanation = self.explanation
        newChoice.isAnswer = self.isAnswer
        return newChoice
    }
}

@Observable public class Question: Identifiable {
    public var id = UUID()
    public var name: String
    public var text: String = ""
    public var choices: [Choice] = []
    public var imageUrl: URL?
    
    init(name: String, text: String, choices: [Choice]) {
        self.name = name
        self.text = text
        self.choices = choices
    }
    
    init() {
        self.name = "New Question"
    }
    
    func clone() -> Question {
        let newQuestion = Question()
        newQuestion.id = self.id
        newQuestion.name = self.name
        newQuestion.text = self.text
        newQuestion.choices = self.choices
        newQuestion.imageUrl = self.imageUrl
        return newQuestion
    }
}

let sampleQuestions = [
    Question(
        name: "Question 1",
        text: "Some Question?",
        choices: [
            Choice(
                text: "Choice 1",
                isAnswer: true
            ), 
            Choice(
                text: "Choice 2"
            ),
            Choice(
                text: "Choice 4"
            ),
            Choice(
                text: "Choice 4"
            )
        ]
    ),
    Question(
        name: "Question 2",
        text: "Some Question?",
        choices: [
            Choice(
                text: "Choice 1"
            ),
            Choice(
                text: "Choice 2",
                isAnswer: true
            ),
            Choice(
                text: "Choice 4"
            ),
            Choice(
                text: "Choice 4"
            )
        ]
    ),
    Question(
        name: "Question 3",
        text: "Some Question?",
        choices: [
            Choice(
                text: "Choice 1"
            ),
            Choice(
                text: "Choice 2"
            ),
            Choice(
                text: "Choice 4",
                isAnswer: true
            ),
            Choice(
                text: "Choice 4"
            )
        ]
    ),
]


