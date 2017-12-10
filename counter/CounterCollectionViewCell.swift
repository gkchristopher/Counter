import UIKit
import QuartzCore

class CounterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    @IBOutlet var arrowImageView: UIImageView!

    private var borderLayer = CAShapeLayer()
    private let card = UIView(frame: CGRect.zero)

    func configure(with counter: Counter) {
        nameLabel.text = counter.name
        countLabel.text = String(counter.count)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        addCardBackground()
//        addDividerLine()
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        isSelected = false
        isHighlighted = false
    }

    override var isSelected: Bool {
        didSet {
            card.backgroundColor = isSelected ? Theme.Colors.selected.color : Theme.Colors.unselected.color
        }
    }

    private func addCardBackground() {
        backgroundColor = Theme.Colors.navBar.color
        card.backgroundColor = Theme.Colors.unselected.color
        card.layer.shadowOffset = CGSize(width: 3, height: 3)
        card.layer.shadowOpacity = 0.8
        contentView.insertSubview(card, at: 0)
    }

    private func addDividerLine() {
        borderLayer.frame = contentView.bounds
        borderLayer.strokeColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1).cgColor
        borderLayer.fillColor = UIColor.clear.cgColor
        borderLayer.lineWidth = 0.5
        contentView.layer.addSublayer(borderLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        card.frame = contentView.bounds.insetBy(dx: 12, dy: 8)
        borderLayer.frame = contentView.bounds
        borderLayer.path = UIBezierPath(rect: contentView.bounds).cgPath
    }
}
