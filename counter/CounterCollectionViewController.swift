import UIKit
import CoreData

class CounterCollectionViewController: UICollectionViewController {

    // MARK: - Private Properties

    private var isDataInitialized = false
    private var fetchedResultsController: NSFetchedResultsController<Counter>?
    private var selectedIndexPath: IndexPath?
    private let reuseIdentifier = "CounterCell"
    private let cellHeight: CGFloat = 80
    private let maximumColumnWidth: CGFloat = 425

    // MARK: - UIViewController Methods

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Counters"
        adjustCellWidth(for: view.bounds.size)
        collectionView?.backgroundColor = Theme.Colors.navBar.color

        initializeDataSource()

        // This prevents the pushed view controller from displaying a title on the back button
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let counterViewController = segue.destination as? CounterViewController else { return }
        guard let indexPath = selectedIndexPath else {
            counterViewController.configure(with: nil)
            return
        }
        guard let counter = fetchedResultsController?.object(at: indexPath) else { return }

        counterViewController.configure(with: counter)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        adjustCellWidth(for: size)
    }

    // MARK: - IBActions

    @IBAction func addCounter(_ sender: UIBarButtonItem) {
        selectedIndexPath = nil
        performSegue(withIdentifier: "ShowCounterDetail", sender: self)
    }

    // MARK: - Private Methods

    private func initializeDataSource() {
        DataManager.shared.initializeDataSource { [weak self] in
            guard let strongSelf = self else { return }
            guard let moc = DataManager.shared.managedObjectContext else { return }

            strongSelf.isDataInitialized = true
            let request = NSFetchRequest<Counter>(entityName: "Counter")
            request.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: true)]
            strongSelf.fetchedResultsController = NSFetchedResultsController(fetchRequest: request,
                                                                             managedObjectContext: moc,
                                                                             sectionNameKeyPath: nil,
                                                                             cacheName: nil)
            do {
                try strongSelf.fetchedResultsController?.performFetch()
            } catch {
                fatalError("Core Data Stack failed to initialize.")
            }
            strongSelf.fetchedResultsController?.delegate = strongSelf

            strongSelf.collectionView?.reloadData()
        }
    }

    private func adjustCellWidth(for size: CGSize) {
        guard let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout else { return }

        if size.width < maximumColumnWidth {
            flowLayout.itemSize = CGSize(width: size.width, height: cellHeight)
        } else {
            flowLayout.itemSize = CGSize(width: size.width / 2, height: cellHeight)
        }
    }

    // MARK: - UICollectionViewDataSource

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var numberOfItems: Int = 0

        if isDataInitialized, let sectionInfo = fetchedResultsController?.sections?.first {
            numberOfItems = sectionInfo.numberOfObjects
        }

        return numberOfItems
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
        if let counterCell = cell as? CounterCollectionViewCell, let counter = fetchedResultsController?.object(at: indexPath) {
            counterCell.configure(with: counter)
        }

        cell.isHighlighted = false
        cell.isSelected = false
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndexPath = indexPath
        performSegue(withIdentifier: "ShowCounterDetail", sender: self)
    }
}

// MARK: - Extensions -

// MARK: NSFetchedResultsControllerDelegate

extension CounterCollectionViewController: NSFetchedResultsControllerDelegate {

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        collectionView?.reloadData()
    }
}
