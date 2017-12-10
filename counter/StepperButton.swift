import UIKit

@IBDesignable
class StepperButton: UIButton {

    // MARK: - Internal Properties

    @IBInspectable var isPlus: Bool = true {
        didSet {
            setNeedsLayout()
        }
    }

    override var tintColor: UIColor! {
        didSet {
            symbolLayer.fillColor = tintColor.cgColor
            symbolLayer.strokeColor = tintColor.cgColor
            layer.borderColor = tintColor.cgColor
        }
    }

    // MARK: - Private Properties

    private let symbolLayer = CAShapeLayer()

    // MARK: - Init / Deinit

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        initilize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initilize()
    }

    // MARK: - UIView Methods

    override func layoutSubviews() {
        super.layoutSubviews()

        symbolLayer.frame = bounds

        let length = min(bounds.width, bounds.height) / 4
        let insetFrame = bounds.insetBy(dx: length, dy: length)

        let path = UIBezierPath()
        path.move(to: CGPoint(x: insetFrame.minX, y: insetFrame.midY))
        path.addLine(to: CGPoint(x: insetFrame.maxX, y: insetFrame.midY))
        if isPlus {
            path.move(to: CGPoint(x: insetFrame.midX, y: insetFrame.minY))
            path.addLine(to: CGPoint(x: insetFrame.midX, y: insetFrame.maxY))
        }
        symbolLayer.path = path.cgPath
    }

    // MARK: - Private Methods

    private func initilize() {
        symbolLayer.frame = bounds
        symbolLayer.fillColor = tintColor.cgColor
        symbolLayer.strokeColor = tintColor.cgColor
        symbolLayer.lineWidth = 3
        layer.addSublayer(symbolLayer)

        layer.borderColor = tintColor.cgColor
        layer.borderWidth = 0.5
    }
}
