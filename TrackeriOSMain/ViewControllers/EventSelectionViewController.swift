import UIKit

protocol EventSelectionViewControllerDelegate: AnyObject {
    func eventSelectionViewController(vc: UIViewController, categories: [TrackerCategory])
    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController)
}

final class EventSelectionViewController: UIViewController {
    weak var delegate: EventSelectionViewControllerDelegate?
    
    private lazy var greetingLabel: UILabel = {
        $0.text = "Создание трекера"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.backgroundColor = .clear
        $0.textColor = UIColor(named: "blackDay")
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UILabel())
    
    private lazy var eventSelectionStackView: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = 10
        
        return $0
    }(UIStackView())
    
    private lazy var selectHabitButton: UIButton = {
        let habitButton = setupButton(text: .habit, font: UIFont.systemFont(ofSize: 16, weight: .medium), cornerRadius: CGFloat(16))
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        
        return habitButton
    }()
    
    private lazy var selectIrregularEventButton: UIButton = {
        let irregularEventButton = setupButton(text: .irregularEvent, font: UIFont.systemFont(ofSize: 16, weight: .medium), cornerRadius: CGFloat(16))
        irregularEventButton.addTarget(self, action: #selector(didTapIrregularEventButton), for: .touchUpInside)
        
        return irregularEventButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLableGreate()
        setupStackView()
    }
}

private extension EventSelectionViewController {
    @objc
    func didTapHabitButton() {
        let createVC = createTrackerVC()
        createVC.reverseIsSchedule()
        present(createVC, animated: true)
    }
    
    @objc
    func didTapIrregularEventButton() {
        let createVC = createTrackerVC()
        present(createVC, animated: true)
    }
    
    func createTrackerVC() -> CreateTrackerViewController {
        let createVC = CreateTrackerViewController()
        createVC.delegate = self
        createVC.modalPresentationStyle = .formSheet
        return createVC
    }
    
    func setupButton(text: NameEvent, font: UIFont, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text.name, for: .normal)
        button.titleLabel?.textColor = UIColor.whiteDay
        button.backgroundColor = UIColor.blackDay
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius ?? CGFloat(0)
        button.layer.masksToBounds = cornerRadius == nil ? false : true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func setupLableGreate() {
        view.addSubview(greetingLabel)
        
        NSLayoutConstraint.activate([
            greetingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            greetingLabel.heightAnchor.constraint(equalToConstant: greetingLabel.font.pointSize)
        ])
    }
    
    func setupStackView() {
        view.addSubview(eventSelectionStackView)
        [selectHabitButton, selectIrregularEventButton].forEach {
            eventSelectionStackView.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            eventSelectionStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            eventSelectionStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            eventSelectionStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            selectHabitButton.heightAnchor.constraint(equalToConstant: 60),
            selectIrregularEventButton.heightAnchor.constraint(equalToConstant: 60)
            
        ])
    }
}

extension EventSelectionViewController: CreateTrackerViewControllerDelegate {
    func createTrackerViewController(vc: UIViewController, categories: [TrackerCategory]) {
        delegate?.eventSelectionViewController(vc: self, categories: categories)
    }
    
    func createTrackerViewControllerDidCancel(_ vc: CreateTrackerViewController) {
        vc.dismiss(animated: false)
        delegate?.eventSelectionViewControllerDidCancel(self)
    }
}
