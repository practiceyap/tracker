import UIKit

final class CreateCategoriesTableViewCell: UITableViewCell {
    private lazy var categoryNameLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .blackDay
        
        return $0
    }(UILabel())
    
    private lazy var selectionIndicatorImageView: UIImageView = {
        $0.backgroundColor = .clear
        $0.isHidden = false
        
        return $0
    }(UIImageView(image: UIImage(named: "selected")))
    
      override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundNight
        layer.cornerRadius = CGFloat(16)
        layer.masksToBounds = true
        setupCategoryNameLabel()
        setupSelectionIndicatorImageView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateCategoriesTableViewCell {
    
    func configure(text: String) {
        categoryNameLabel.text = text
    }
    
    func setSelectionIndicatorVisibility(hidden: Bool) {
        selectionIndicatorImageView.isHidden = hidden
    }
    
    private func setupCategoryNameLabel() {
        contentView.addSubview(categoryNameLabel)
        categoryNameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 12)
        ])
    }
    
    private func setupSelectionIndicatorImageView() {
        contentView.addSubview(selectionIndicatorImageView)
        selectionIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            selectionIndicatorImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            selectionIndicatorImageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -12)
        ])
    }
}

