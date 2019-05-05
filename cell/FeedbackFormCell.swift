protocol FeedbackFormViewProtocol {
    var viewModel: FeedbackFormViewModelProtocol
	func define(text: String, options: [String])
}

protocol FeedbackFormViewModelProtocol {
	func done(_ on: FeedbackFormViewModelProtocol, selectedOptionIndex: Int)
}

class FeedbackFormCell {
    var viewModel: FeedbackFormViewModelProtocol
}

extension FeedbackFormCell: FeedbackFormViewProtocol {
    func define(text: String, options: [String]) {
        title.text = text
        options.forEach { // cria os botoes }
    }

    @IBAction
    func onClick(button: UIButton) {
        self.viewModel.done(self, button.tag)
    }
}