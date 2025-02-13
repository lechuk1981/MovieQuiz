import UIKit

final class MovieQuizViewController: UIViewController,
                                     MovieQuizViewControllerProtocol,
                                     AlertPresenterDelegate {
    func highlightImageBorder(isCorrectAnswer: Bool) {
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = isCorrectAnswer ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
    
    private let alertPresenter: AlertPresenterProtocol = AlertPresenter()
    private var presenter: MovieQuizPresenter?

    @IBOutlet private weak var textLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction private func yesButtonClicked(_ sender: UIButton) {

        presenter?.yesButtonClicked()
        changeStateButton(isEnabled: false)
    }
    
    @IBAction private func noButtonClicked(_ sender: UIButton) {
        presenter?.noButtonClicked()
        changeStateButton(isEnabled: false)
    }
    
    private func changeStateButton(isEnabled: Bool) {
        noButton.isEnabled = isEnabled
        yesButton.isEnabled = isEnabled
    }
    
    private func resetAnswerBorder() {
            imageView.layer.borderWidth = 0
            imageView.layer.borderColor = UIColor.clear.cgColor
        }
    
    func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        activityIndicator.isHidden = true
    }
    
    func show(quiz viewModel: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: viewModel.title,
            message: viewModel.text,
            buttonText: viewModel.buttonText,
            buttonAction: { [weak self] in
                guard let self else { return }
                self.presenter?.restartGame()
            }
        )
        changeStateButton(isEnabled: true)
        alertPresenter.show(alertModel: alertModel)
    }
    
    func showNetworkError(message: String) {
        let model = AlertModel(title: "Ошибка",
                               message: message,
                               buttonText: "Попробовать еще раз") { [weak self] in
            guard let self else { return }
            self.presenter?.restartGame()
        }
        
        alertPresenter.show(alertModel: model)
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
        self.presenter?.restartGame()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        alertPresenter.delegate = self
        presenter = MovieQuizPresenter(viewController: self)
    }
    
    // MARK: - AlertPresenterDelegate
    func show(alert: UIAlertController) {
        self.present(alert, animated: true)
    }
    
    func show(quiz step: QuizStepViewModel) {
        resetAnswerBorder()
        changeStateButton(isEnabled: true)
        imageView.image = step.image
        textLabel.text = step.question
        counterLabel.text = step.questionNumber
        
    }
}
