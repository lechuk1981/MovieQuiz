import UIKit

final class MovieQuizViewController: UIViewController {
    
    
    @IBOutlet weak private var textLabel: UILabel!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var counterLabel: UILabel!
    
    private struct QuizQuestion {
        let image: String
        let text: String
        let correctAnswer: Bool
    }
    
    private struct QuizStepViewModel {
        let image: UIImage
        let question: String
        let questionNumber: String
    }
    
    private struct QuizResultsViewModel {
        let title: String
        let text: String
        let buttonText: String
    }
    
    
    private let questions: [QuizQuestion] = [
        .init(image: "The Godfather", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Dark Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Kill Bill", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Avengers", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Deadpool", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Green Knight", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Old", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "Tesla", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "Vivarium", text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
    ]
    
    
    private var correctAnswers = 0
    private var currentQuestionIndex = 0
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {
       let currentQuestion = questions[currentQuestionIndex]
       showAnswerResult(isCorrect: currentQuestion.correctAnswer)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        
        let currentQuestion = questions[currentQuestionIndex]
        showAnswerResult(isCorrect: !currentQuestion.correctAnswer)
        
    }
    
       
    private func show(quiz result: QuizResultsViewModel) {
        
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert)
        
        let action = UIAlertAction(
            title: result.buttonText,
            style: .default) {  [weak self] _ in
                guard let self = self else { return }
                
                self.currentQuestionIndex = 0
                self.correctAnswers = 0
                
                let firstQuestion = self.questions[self.currentQuestionIndex]
                let viewModel =  self.convert(model: firstQuestion )
                
                self.show(quiz: viewModel)
            }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        
        let model = convert(model: questions[currentQuestionIndex])
        imageView.image = model.image
        textLabel.text = model.question
        counterLabel.text = model.questionNumber
        
        super.viewDidLoad()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        
        let quizStepViewModel = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
        
        return quizStepViewModel
    }
    
    private func show(quiz step: QuizStepViewModel) {
        
        let model = convert(model: questions[currentQuestionIndex])
        imageView.image = model.image
        textLabel.text = model.question
        counterLabel.text = model.questionNumber
        
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        
        if isCorrect {
            correctAnswers += 1
        }
        
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self = self else { return }
            
            self.showNextQuestionOrResults()
        }
    }
    
    private func showNextQuestionOrResults() {
        
        imageView.layer.borderColor = UIColor.ypBlack.cgColor
        
        if currentQuestionIndex == questions.count - 1 {
            let text = "Ваш результат: \(correctAnswers)/10"
            let viewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: text,
                buttonText: "Сыграть ещё раз")
            show(quiz: viewModel)
            
        } else {
            
            currentQuestionIndex += 1
            
            let nextQuestion = questions[currentQuestionIndex]
            let viewModel = convert(model: nextQuestion)
            
            show(quiz: viewModel)
        }
    }
}
