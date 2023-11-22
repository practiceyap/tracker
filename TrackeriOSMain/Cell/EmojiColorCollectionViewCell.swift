import UIKit

final class EmojiColorCollectionViewCell: UICollectionViewCell {
    var emojiLabel: UILabel = {
        $0.textAlignment = .center
        $0.layer.cornerRadius = 8
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.font = UIFont.systemFont(ofSize: 32, weight: .medium)
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    var colorContainerView: UIView = {
        $0.layer.masksToBounds = true
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    var dynamicColorView: UIView = {
        
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 8
        
        return $0
    }(UIView())
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension EmojiColorCollectionViewCell {
    
    func configure(withEmoji emoji: String) {
        emojiLabel.text = emoji
    }
    
    func configure(withColor color: UIColor) {
        dynamicColorView.backgroundColor = color
    }
    
    func selectEmoji(withBackground isBackground: Bool) {
        emojiLabel.backgroundColor = isBackground ? .grayDay : .clear
    }
    
    
    func selectColor(color: UIColor, flag: Bool) {
        colorContainerView.layer.cornerRadius = flag ? 8 : 0
        colorContainerView.layer.borderWidth = flag ? 3 : 0
        colorContainerView.layer.masksToBounds = flag
        colorContainerView.layer.borderColor = color.withAlphaComponent(0.3).cgColor
    }
    
    private func setupColorView() {
        addSubview(emojiLabel)
        addSubview(colorContainerView)
        colorContainerView.addSubview(dynamicColorView)
        
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            emojiLabel.heightAnchor.constraint(equalToConstant: 52),
            emojiLabel.widthAnchor.constraint(equalToConstant: 52),
            colorContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            colorContainerView.centerYAnchor.constraint(equalTo: centerYAnchor),
            colorContainerView.heightAnchor.constraint(equalToConstant: 52),
            colorContainerView.widthAnchor.constraint(equalToConstant: 52),
            dynamicColorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            dynamicColorView.centerYAnchor.constraint(equalTo: centerYAnchor),
            dynamicColorView.heightAnchor.constraint(equalToConstant: 40),
            dynamicColorView.widthAnchor.constraint(equalToConstant: 40),
        ])
    }
}

