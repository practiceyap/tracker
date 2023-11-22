import UIKit

protocol CreateTrackerViewControllerDelegate: AnyObject {
    func createTrackerViewController(vc: UIViewController, categories: [TrackerCategory])
    func createTrackerViewControllerDidCancel(_ vc: CreateTrackerViewController)
}

final class CreateTrackerViewController: UIViewController{
    private let manager: ManagerProtocol = ManagerStub.shared
    weak var delegate: CreateTrackerViewControllerDelegate?
    
    private var isSchedule: Bool = true
    private var listSettings: [ChoiceParametrs] { isSchedule ? [.category] : [.category, .schedule] }
    private let dataSection: [Header] = [.emoji, .color]
    private let emojis: [String] = ["🙂", "😻", "🌺", "🐶", "❤️", "😱", "😇", "😡", "🥶",
                                   "🤔", "🙌", "🍔", "🥦", "🏓", "🥇", "🎸", "🏝️", "😪"]
    
    private let colors: [UIColor] = [.colorSelection1, .colorSelection2, .colorSelection3,.colorSelection4,
                                     .colorSelection5, .colorSelection6, .colorSelection7, .colorSelection8,
                                     .colorSelection9, .colorSelection10, .colorSelection11, .colorSelection12,
                                     .colorSelection13, .colorSelection14, .colorSelection15, .colorSelection16,
                                     .colorSelection17, .colorSelection18]
    

    private var schedule: [WeekDay] = [] {
        didSet { checkingForEmptiness() }
    }
    private var selectedColor: [UIColor] = []
    private var nameNewCategory: String = "Важное"

    private var nameTracker: String = ""
    
    private lazy var newHabitLabel: UILabel = {
        $0.text = isSchedule ? "Новое нерегулярное событие" : "Новая привычка"
        $0.textColor = .blackDay
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        
        return $0
    }(UILabel())
    
    private lazy var createNameTextField: UITextField = {
        $0.placeholder = "Введите название трекера"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.indent(size: CGFloat(12))
        $0.backgroundColor = .backgroundNight
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.masksToBounds = true
        $0.clearButtonMode = .whileEditing
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        $0.delegate = self
        
        return $0
    }(UITextField())
    
    private lazy var characterRestrictionsView: UILabel = {
        $0.backgroundColor = .clear
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.text = "Ограничение 38 символов"
        $0.textColor = .redDay
        $0.numberOfLines = 1
        $0.textAlignment = .center
        $0.isHidden = true
        
        return $0
    }(UILabel())
    
    private lazy var contentStackView: UIStackView = {
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .vertical
        $0.spacing = CGFloat(24)
        
        return $0
    }(UIStackView())
    
    private lazy var selectionTableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = isSchedule ? .none : .singleLine
        $0.separatorInset = UIEdgeInsets(top: 0, left: 24, bottom: 0, right: 0)
        $0.register(CreateTrackerTableViewCell.self, forCellReuseIdentifier: "\(CreateTrackerTableViewCell.self)")
        
        return $0
    }(UITableView())
    
    private lazy var emojiCollectionView: TrackerCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let params = GeometricParams(cellCount: 7, leftInset: 6, rightInset: 6, cellSpacing: 2)
        let emojiCollectionView = TrackerCollectionView(frame: .zero, collectionViewLayout: layout, params: params)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        emojiCollectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiColorCollectionViewCell.self)")
        emojiCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        emojiCollectionView.allowsMultipleSelection = false
        emojiCollectionView.backgroundColor = .clear
        emojiCollectionView.isScrollEnabled = false
        emojiCollectionView.scrollIndicatorInsets = .zero
        
        return emojiCollectionView
    }()
    
    private lazy var colorCollectionView: TrackerCollectionView = {
        let layout = UICollectionViewFlowLayout()
        let params = GeometricParams(cellCount: 6, leftInset: 6, rightInset: 6, cellSpacing: 2)
        let colorCollectionView = TrackerCollectionView(frame: .zero, collectionViewLayout: layout, params: params)
        colorCollectionView.dataSource = self
        colorCollectionView.delegate = self
        colorCollectionView.register(EmojiColorCollectionViewCell.self, forCellWithReuseIdentifier: "\(EmojiColorCollectionViewCell.self)")
        colorCollectionView.register(HeaderReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(HeaderReusableView.self)")
        colorCollectionView.allowsMultipleSelection = false
        colorCollectionView.backgroundColor = .clear
        colorCollectionView.isScrollEnabled = false
        colorCollectionView.scrollIndicatorInsets = .zero
        
        return colorCollectionView
    }()
    
    private lazy var cancelButton: UIButton = {
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.borderWidth = CGFloat(1)
        $0.layer.borderColor = UIColor.redDay.cgColor
        $0.layer.masksToBounds = true
        $0.backgroundColor = .clear
        $0.setTitle("Отменить", for: .normal)
        $0.setTitleColor(.redDay, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    private lazy var createButton: UIButton = {
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .grayDay
        $0.setTitle("Создать", for: .normal)
        $0.titleLabel?.textColor = .redDay
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(didTapCreateButton) , for: .touchUpInside)
        
        return $0
    }(UIButton())
    
    private lazy var buttonStack: UIStackView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.axis = .horizontal
        $0.spacing = CGFloat(10)
        $0.distribution = .fillEqually
        
        return $0
    }(UIStackView())
    
    private lazy var contentView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIView())
    
    private lazy var scrollView: UIScrollView = {
        $0.alwaysBounceVertical = true
        $0.showsVerticalScrollIndicator = false

        return $0
    }(UIScrollView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
        
        setupUIElements()
        schedule = isSchedule ? manager.getWeekDay() : []
    }
}

extension CreateTrackerViewController {
    @objc
    private func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    @objc
    private func didTapCreateButton() {
        let oldCategories = manager.getCategories()
        let categories = createNewCategory(categories: oldCategories)
        delegate?.createTrackerViewController(vc: self, categories: categories)
        delegate?.createTrackerViewControllerDidCancel(self)
    }
    
    @objc
    private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else { return }
        if text.count > 38 {
            characterRestrictionsView.isHidden = false
            textField.text = nameTracker.firstUppercased
            return
        }
        nameTracker = text.firstUppercased
        checkingForEmptiness()
    }
    
    @objc
    private func hideKeyboard() {
        view.endEditing(true)
    }
    
    private func isActiveCreateButton(flag: Bool) {
        createButton.isEnabled = flag
        createButton.backgroundColor = flag ? .blackDay : .grayDay
    }
    
    private func joinedSchedule(schedule: [WeekDay]) -> String {
        var stringListDay: String
        if schedule.count == 7 {
            stringListDay = "Каждый день"
            return stringListDay
        }
        let listDay = schedule.map { $0.briefWordDay }
        stringListDay = listDay.joined(separator: ",")
        
        return stringListDay
    }
    
    private func createNewTracker() -> Tracker {
        let tracker = Tracker(name: nameTracker, color: .colorSelection12, emoji: "🍏", schedule: schedule)
        return tracker
    }
    
    private func createNewCategory(categories: [TrackerCategory]) -> [TrackerCategory] {
        var newCategories: [TrackerCategory] = []
        let tracker = createNewTracker()
        var trackers: [Tracker] = []
        categories.forEach { oldCategory in
            oldCategory.arrayTrackers.forEach { oldTracker in
                trackers.append(oldTracker)
            }
            trackers.append(tracker)
            let category = TrackerCategory(nameCategory: oldCategory.nameCategory, arrayTrackers: trackers)
            newCategories.append(category)
            
        }
        return newCategories
    }
    
    private func checkingForEmptiness() {
        let flag = !schedule.isEmpty && !nameTracker.isEmpty && !selectedColor.isEmpty ? true : false
        isActiveCreateButton(flag: flag)
    }
    
    func reverseIsSchedule() {
        isSchedule = isSchedule ? !isSchedule : isSchedule
    }
    
    func presentViewController(vc: UIViewController, modalStyle: UIModalPresentationStyle) {
        vc.modalPresentationStyle = modalStyle
        present(vc, animated: true)
    }

    func setupUIElements() {
        setupNewHabitLabel()
        setupButtonStack()
        setupScrollView()
        setupStackView()
    }
    
    func setupNewHabitLabel() {
        view.addSubview(newHabitLabel)
        newHabitLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newHabitLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newHabitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupButtonStack() {
        view.addSubview(buttonStack)
        [cancelButton, createButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            buttonStack.addArrangedSubview($0)
        }
        
        NSLayoutConstraint.activate([
            buttonStack.heightAnchor.constraint(equalToConstant: 60),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            buttonStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: newHabitLabel.bottomAnchor, constant: 24),
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            scrollView.bottomAnchor.constraint(equalTo: buttonStack.topAnchor)
        ])
    }
    
    func setupStackView() {
        scrollView.addSubview(contentStackView)
        [createNameTextField, characterRestrictionsView, selectionTableView, emojiCollectionView, colorCollectionView].forEach {
            contentStackView.addArrangedSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            createNameTextField.heightAnchor.constraint(equalToConstant: 75),
            emojiCollectionView.heightAnchor.constraint(equalToConstant: 222),
            colorCollectionView.heightAnchor.constraint(equalToConstant: 222),
            selectionTableView.heightAnchor.constraint(equalToConstant: isSchedule ? 75 : 150)
        ])
    }
}

extension CreateTrackerViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        listSettings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateTrackerTableViewCell.self)") as? CreateTrackerTableViewCell else { return UITableViewCell() }
        let secondarySchedulText = joinedSchedule(schedule: schedule)
        switch listSettings[indexPath.row] {
        case .category:
            cell.configure(withChoice: listSettings[indexPath.row])
            cell.configureSecondaryTextLabel(withSchedule: nameNewCategory)
        case .schedule:
            cell.configure(withChoice: listSettings[indexPath.row])
            cell.configureSecondaryTextLabel(withSchedule: secondarySchedulText)
        }
        return cell
    }
}

extension CreateTrackerViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(75)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? CreateTrackerTableViewCell else { return }
        switch listSettings[indexPath.row] {
        case .category:
            let createCategoriViewController = CreateCategoriesViewController()
            createCategoriViewController.delegate = self
            presentViewController(vc: createCategoriViewController, modalStyle: .formSheet)
        case .schedule:
            let scheduleViewController = ScheduleViewController()
            scheduleViewController.delegate = self
            presentViewController(vc: scheduleViewController, modalStyle: .formSheet)
        }
    }
}

extension CreateTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        createNameTextField.resignFirstResponder()
        return true
    }
}

extension CreateTrackerViewController: ScheduleViewControllerDelegate {
    func daysOfWeek(viewController: UIViewController, listDays: [WeekDay]) {
        guard let _ = viewController as? ScheduleViewController else { return }
        schedule = listDays
        selectionTableView.reloadData()
    }
}

extension CreateTrackerViewController: CreateCategoriesViewControllerDelegate {
    func createCategoriesViewController(vc: UIViewController, nameCategory: String) {
       
        nameNewCategory = nameCategory
    }
    
    func createCategoriesViewControllerDidCancel(vc: CreateCategoriesViewController) {
        vc.dismiss(animated: true)
    }
}

extension CreateTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int
        switch dataSection[section] {
        case .color:
            count = colors.count
        case .emoji:
            count = emojis.count
        }
        return count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        dataSection.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(EmojiColorCollectionViewCell.self)", for: indexPath) as? EmojiColorCollectionViewCell
        else { return UICollectionViewCell() }
        if collectionView == colorCollectionView {
            let color = colors[indexPath.row]
            cell.configure(withColor: color)
        }
        if collectionView == emojiCollectionView {
            let emoji = emojis[indexPath.row]
            cell.configure(withEmoji: emoji)
        }
        return cell
    }
}

extension CreateTrackerViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        if collectionView == colorCollectionView {
            let color = colors[indexPath.row]
            cell.selectColor(color: color, flag: true)
        }
        if collectionView == emojiCollectionView {
            cell.selectEmoji(withBackground: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? EmojiColorCollectionViewCell else { return }
        if collectionView == colorCollectionView {
            let color: UIColor = .clear
            cell.selectColor(color: color, flag: false)
        }
        if collectionView == emojiCollectionView {
            cell.selectEmoji(withBackground: false)
        }
    }
}

extension CreateTrackerViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - emojiCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(emojiCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height: CGFloat(54))

        return sizeCell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: emojiCollectionView.params.leftInset, bottom: 16, right: emojiCollectionView.params.rightInset)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        var systemLayoutSize: CGSize
        switch dataSection[section] {
        case .color:
            let indexPath = IndexPath(row: 1, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            systemLayoutSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        case .emoji:
            let indexPath = IndexPath(row: 0, section: section)
            let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
            systemLayoutSize = headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
        return systemLayoutSize
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            supplementary.label.text = dataSection[indexPath.section].name
            return supplementary
        default:
            return UICollectionReusableView()
        }
    }
}

