import Foundation

protocol ViewModelUpdatable: class {
    func updateUI()
    func showErrorState()
}

class CounterViewModel {

    // MARK: - Internal Properties

    var counter: Counter?
    weak var delegate: ViewModelUpdatable?
    var title: String? {
        return counter?.name
    }

    // MARK: - Init

    init(_ delegate: ViewModelUpdatable?) {
        self.delegate = delegate
    }

    // MARK: - Public Methods

    func addCounter() {
        counter = DataManager.shared.newCounter()
    }

    func increment() {
        counter?.count += 1
        delegate?.updateUI()
        DataManager.shared.save()
    }

    func decrement() {
        if let counter = counter, counter.count > 0 {
            counter.count -= 1
            delegate?.updateUI()
            DataManager.shared.save()
        } else {
            delegate?.showErrorState()
        }
    }

    func updateTitle(_ title: String) {
        counter?.name = title
        DataManager.shared.save()
    }
}
