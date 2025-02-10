//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Andrey Sopov on 08.02.2025.
//
import Foundation
import UIKit

final class MovieQuizPresenter {
    
    let questionsAmount: Int = 10
    private var currentQuestionIndex: Int = 0
    var currentQuestion: QuizQuestion?
    weak var viewController: MovieQuizViewController?
    
    func noButtonClicked() {
        guard let currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
    }
    
    func yesButtonClicked() {
        guard let currentQuestion else { return }
        viewController?.showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    func isLastQuestion() -> Bool {
        currentQuestionIndex == questionsAmount - 1
    }
    
    func resetQuestionIndex() {
        currentQuestionIndex = 0
    }
    
    func switchToNextQuestion() {
        print(currentQuestionIndex)
        currentQuestionIndex += 1
    }
    
    func convert(model: QuizQuestion) -> QuizStepViewModel {
        let quizStepViewModel = QuizStepViewModel(
            image:  UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
        
        return quizStepViewModel
    }
    
}
