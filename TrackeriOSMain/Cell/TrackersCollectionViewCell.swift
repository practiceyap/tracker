import UIKit

protocol TrackersCollectionViewCellDelegate: AnyObject {
    func didTrackerCompleted(_ cell: UICollectionViewCell)
}

final class TrackersCollectionViewCell: UICollectionViewCell {
    private var count: Int = 0
    private var isSelectedAddButton: Bool = false
    
    weak var delegate: TrackersCollectionViewCellDelegate?
    
    lazy var trackerBackgroundColorView: UIView = {
        $0.layer.masksToBounds = true
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.borderWidth = CGFloat(1)
        $0.layer.borderColor = (UIColor.backgroundNight).cgColor
        
        return $0
    }(UIView())
    
    lazy var emojiLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .backgroundNight
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    lazy var trackerNameLabel: UILabel = {
        $0.numberOfLines = 2
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.textColor = .white
        $0.textAlignment = .justified
        
        return $0
    }(UILabel())
    
    lazy var dayCounterLabel: UILabel = {
        $0.textColor = .blackDay
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.text = "\(count) дней"
        
        return $0
    }(UILabel())
    
    lazy var completeTaskButton: UIButton = {
        $0.setImage(UIImage(named: "add")?.withRenderingMode(.alwaysTemplate), for: .normal)
        $0.tintColor = .whiteDay
        $0.backgroundColor = .lightGray
        $0.layer.cornerRadius = CGSize(width: 34, height: 34).width / 2
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(didTapAddButton), for: .touchUpInside)
        
        return $0
    }(UIButton(type: .custom))
    
    private lazy var addButtonBackgroundView: UIView = {
        let backgroundAddButtonView = UIView()
        backgroundAddButtonView.isHidden = true
        backgroundAddButtonView.translatesAutoresizingMaskIntoConstraints = false
        backgroundAddButtonView.layer.cornerRadius = CGSize(width: 34, height: 34).width / 2
        backgroundAddButtonView.layer.masksToBounds = true
        backgroundAddButtonView.backgroundColor = .grayOpacity30
        
        return backgroundAddButtonView
    }()
    
    private lazy var horizontalStackView: UIStackView = {
        let horisontalStack = UIStackView()
        horisontalStack.axis = .horizontal
        horisontalStack.alignment = .center
        horisontalStack.backgroundColor = .clear
        
        return horisontalStack
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let verticalStack = UIStackView()
        verticalStack.axis = .vertical
        verticalStack.backgroundColor = .clear
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        
        return verticalStack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUIElement()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TrackersCollectionViewCell {
    @objc
    private func didTapAddButton() {
        guard let delegate else { return }
            delegate.didTrackerCompleted(self)
    }
    
    func endingWordDay(count: Int) -> String {
        var result: String
        switch (count % 10) {
        case 1: result = "\(count) день"
        case 2: result = "\(count) дня"
        case 3: result = "\(count) дня"
        case 4: result = "\(count) дня"
        default: result = "\(count) дней"
        }
        return result
    }
    
    func updateLableCountAndImageAddButton(count: Int, flag: Bool) {
        switch flag {
        case true:
            let image = UIImage(named: "done")?.withRenderingMode(.alwaysTemplate)
            completeTaskButton.setImage(image, for: .normal)
            self.count = count
            let textLable = endingWordDay(count: count)
            dayCounterLabel.text = textLable
        case false:
            let image = UIImage(named: "add")?.withRenderingMode(.alwaysTemplate)
            completeTaskButton.setImage(image, for: .normal)
            self.count = count
            let textLable = endingWordDay(count: count)
            dayCounterLabel.text = textLable
        }
    }
    
    func updateBackgraundAddButton(isHidden: Bool) {
        addButtonBackgroundView.isHidden = isHidden
    }
    
    func isEnableAddButton(flag: Bool) {
        completeTaskButton.isEnabled = flag
    }
    
    func setIsSelectedAddButton(flag: Bool) {
        isSelectedAddButton = flag
    }
    
    func config(tracker: Tracker, count: Int, isComplited: Bool) {
        trackerBackgroundColorView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        completeTaskButton.backgroundColor = tracker.color
        trackerNameLabel.text = tracker.name
        updateLableCountAndImageAddButton(count: count, flag: isComplited)
    }
    
    private func setupUIElement() {
        setupColorView()
        setupVerticallStack()
        setupHorisontalStack()
        setupBackgroundAddButtonView()
    }
    
    private func setupVerticallStack() {
        contentView.addSubview(verticalStackView)
        [trackerBackgroundColorView, horizontalStackView].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            verticalStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            verticalStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    private func setupHorisontalStack() {
        [dayCounterLabel, completeTaskButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            horizontalStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayCounterLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayCounterLabel.topAnchor.constraint(equalTo: trackerBackgroundColorView.bottomAnchor, constant: 16),
            
            completeTaskButton.heightAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).height),
            completeTaskButton.widthAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).width),
            completeTaskButton.topAnchor.constraint(equalTo: trackerBackgroundColorView.bottomAnchor, constant: 8),
            completeTaskButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    private func setupBackgroundAddButtonView() {
        completeTaskButton.addSubview(addButtonBackgroundView)
        
        NSLayoutConstraint.activate([
            addButtonBackgroundView.centerXAnchor.constraint(equalTo: completeTaskButton.centerXAnchor),
            addButtonBackgroundView.centerYAnchor.constraint(equalTo: completeTaskButton.centerYAnchor),
            addButtonBackgroundView.heightAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).height),
            addButtonBackgroundView.widthAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).width)
        ])
    }
    
    private func setupColorView() {
        [emojiLabel, trackerNameLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            trackerBackgroundColorView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            emojiLabel.topAnchor.constraint(equalTo: trackerBackgroundColorView.topAnchor, constant: 12),
            emojiLabel.leadingAnchor.constraint(equalTo: trackerBackgroundColorView.leadingAnchor, constant: 12),
            emojiLabel.heightAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).height),
            emojiLabel.widthAnchor.constraint(equalToConstant: CGSize(width: 34, height: 34).width),
            
            trackerNameLabel.leadingAnchor.constraint(equalTo: trackerBackgroundColorView.leadingAnchor, constant: 12),
            trackerNameLabel.trailingAnchor.constraint(equalTo: trackerBackgroundColorView.trailingAnchor, constant: -12),
            trackerNameLabel.bottomAnchor.constraint(equalTo: trackerBackgroundColorView.bottomAnchor, constant: -12)
        ])
    }
}
