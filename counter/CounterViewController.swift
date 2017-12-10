import UIKit

class CounterViewController: UIViewController {

    // MARK: - Internal Properties

    var viewModel: CounterViewModel!

    // MARK: - IBOutlets

    @IBOutlet var countLabel: UILabel!
    @IBOutlet var minusButton: StepperButton!

    // MARK: - Private Properties

    private var titleTextField = UITextField(frame: CGRect.zero)
    fileprivate var isNewCounter = false

    // MARK: - Public Methods

    func configure(with counter: Counter?) {
        if let counter = counter {
            viewModel.counter = counter
        } else {
            viewModel.addCounter()
            isNewCounter = true
        }
    }

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()

        title = viewModel.title ?? "Unnamed Counter"
        setupTitleTextField()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isNewCounter {
            titleTextField.becomeFirstResponder()
        }
    }

    // MARK: - Init / Deinit

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        viewModel = CounterViewModel(self)
    }

    // MARK: - IBActions

    @IBAction func handlePlusButtonTapped(_ sender: StepperButton) {
        viewModel.increment()
    }

    @IBAction func handleMinusButtonTapped(_ sender: StepperButton) {
        viewModel.decrement()
    }

    // MARK: - Private Methods

    private func setupTitleTextField() {
        titleTextField.frame = CGRect(x: 0, y: 0, width: 200, height: 30)
        titleTextField.text = title
        let font = UIFont.preferredFont(forTextStyle: .headline)
        titleTextField.font = font
        titleTextField.textAlignment = .center
        titleTextField.textColor = Theme.Colors.titleTint.color
        titleTextField.isUserInteractionEnabled = true
        titleTextField.delegate = self
        navigationItem.titleView = titleTextField
    }
}

// MARK: - Extensions _

// MARK: ViewModelUpdatable

extension CounterViewController: ViewModelUpdatable {

    func updateUI() {
        if let counter = viewModel.counter {
            countLabel.text = String(counter.count)
        } else {
            countLabel.text = String(0)
        }
    }

    func showErrorState() {
        view.isUserInteractionEnabled = false
        countLabel.textColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.countLabel.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.view.isUserInteractionEnabled = true
        }
    }
}

// MARK: UITextFieldDelegate

extension CounterViewController: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        isNewCounter = false
        if let trimmedText = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines) {
            textField.text = trimmedText
            title = trimmedText
            viewModel.updateTitle(trimmedText)
        }
        return true
    }
}
