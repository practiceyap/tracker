import UIKit

class CreateTrackerTableViewCell: UITableViewCell {
    
    private lazy var mainTextLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .blackDay
        return $0
    }(UILabel())
    
    private lazy var secondaryTextLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.textColor = .grayDay
        $0.isHidden = true
        return $0
    }(UILabel())
    
    private lazy var textStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        return $0
    }(UIStackView())
    
    private lazy var actionImageView: UIImageView = {
        return $0
    }(UIImageView(image: UIImage(named: "buttonIconCell")))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setupUIComponents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CreateTrackerTableViewCell {
    private func setupUIComponents() {
        setupCellAppearance()
        setupStackView()
    }
    
    private func setupCellAppearance() {
        backgroundColor = .backgroundNight
        layer.cornerRadius = CGFloat(16)
        layer.masksToBounds = true
        actionImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(actionImageView)
        actionImageView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            actionImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            actionImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            actionImageView.heightAnchor.constraint(equalToConstant: 24),
            actionImageView.widthAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    func setupStackView() {
        contentView.addSubview(textStackView)
        [mainTextLabel, secondaryTextLabel].forEach {
            $0.backgroundColor = .clear
            $0.translatesAutoresizingMaskIntoConstraints = false
            textStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            textStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            textStackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(withChoice choice: ChoiceParametrs) {
        mainTextLabel.text = choice.name
    }
    
    func configureSecondaryTextLabel(withSchedule secondaryText: String) {
        if !secondaryText.isEmpty {
            secondaryTextLabel.text = secondaryText
            secondaryTextLabel.isHidden = false
        }
    }
}

