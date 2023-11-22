import UIKit

final class HeaderReusableView: UICollectionReusableView {
    lazy var label: UILabel = {
        $0.backgroundColor = .clear
        $0.font = UIFont.boldSystemFont(ofSize: 19)
        $0.textColor = .blackDay
        $0.numberOfLines = 1
        
        return $0
    }(UILabel())
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension HeaderReusableView {
    func setupLabel() {
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12),
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
