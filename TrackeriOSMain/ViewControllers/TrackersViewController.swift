import UIKit

final class TrackersViewController: UIViewController {
    private let manager: ManagerProtocol = ManagerStub.shared

    private var isStubEnabled: Bool = false
    private var trackerCategories: [TrackerCategory] = []
    private var completedTrackers: Set<TrackerRecord> = []
    private var selectedDate: Date { datePicker.date }
    private var displayedCategories: [TrackerCategory] = []
    
    private let date = Date()
    
    private lazy var horizontalStackView: UIStackView = {
        $0.axis = .horizontal
        $0.alignment = .center
        
        return $0
    }(UIStackView())
    
    private lazy var averageVerticalStackView: UIStackView = {
        $0.backgroundColor = .clear
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    private lazy var mainVerticalStackView: UIStackView = {
        $0.axis = .vertical
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    private lazy var datePicker: UIDatePicker = {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
        $0.locale = Locale(identifier: "ru_Ru")
        $0.calendar.firstWeekday = 2
        $0.layer.cornerRadius = CGFloat(8)
        $0.layer.masksToBounds = true
        $0.addTarget(self, action: #selector(actionForTapDatePicker), for: .valueChanged)
        
        return $0
    }(UIDatePicker())
    
    private lazy var headerLabel: UILabel = {
        $0.text = "Трекеры"
        $0.font = UIFont.boldSystemFont(ofSize: 34)
        $0.textColor = .blackDay
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        
        return $0
    }(UILabel())
    
    lazy var trackerCollectionView: TrackerCollectionView = {
        let trackerCollectionView = createTrackerCollectionView()
        trackerCollectionView.backgroundColor = .clear
        trackerCollectionView.showsVerticalScrollIndicator = false
        registerCellAndHeader(collectionView: trackerCollectionView)
        
        return trackerCollectionView
    }()
    
    private lazy var placeholderImageView: UIImageView = {
        $0.isHidden = true
        
        return $0
    }(UIImageView())
    
    private lazy var placeholderLabel: UILabel = {
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.isHidden = true
        
        return $0
    }(UILabel())
    
    private lazy var contentView: UIView = {
        $0.backgroundColor = .clear
        
        return $0
    }(UIView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUIElements()
        trackerCategories = manager.getCategories()
        showListTrackersForDay(trackerCategory: trackerCategories)
    }
}

extension TrackersViewController {
    @objc
    private func actionForTapDatePicker(sender: UIDatePicker) {
        changeStub(text: "Что будем отслеживать?", nameImage: "star")
        showListTrackersForDay(trackerCategory: trackerCategories)
    }
    
    @objc
    private func didTapLeftNavBarItem() {
        let createVC = EventSelectionViewController()
        createVC.delegate = self
        createVC.modalPresentationStyle = .formSheet
        present(createVC, animated: true)
    }
    
    private func showListTrackersForDay(trackerCategory: [TrackerCategory]) {
        let listCategories = filterListTrackersWeekDay(trackerCategory: trackerCategory, date: selectedDate)
        updateTrackerCollectionView(trackerCategory: listCategories)
    }
    
    private func updateTrackerCollectionView(trackerCategory: [TrackerCategory]) {
        displayedCategories = trackerCategory
        showStabView(flag: !trackerCategory.isEmpty)
        trackerCollectionView.reloadData()
    }
    
    private func changeStub(text: String, nameImage: String) {
    placeholderLabel.text = text
        placeholderImageView.image = UIImage(named: nameImage)
    }
    
    private func comparisonWeekDays(date: Date, day: WeekDay) -> Bool {
        FormatDate.shared.createWeekDayInt(date: date) == day.rawValue
    }
    
    private func filterListTrackersWeekDay(trackerCategory: [TrackerCategory], date: Date) -> [TrackerCategory] {
        var listCategories: [TrackerCategory] = []
        for cat in 0..<trackerCategory.count {
            let currentCategory = trackerCategory[cat]
            var trackers: [Tracker] = []
            for tracker in 0..<trackerCategory[cat].arrayTrackers.count {
                let listWeekDay = trackerCategory[cat].arrayTrackers[tracker].schedule
                for day in 0..<listWeekDay.count {
                    if comparisonWeekDays(date: date, day: listWeekDay[day]) {
                        let tracker = trackerCategory[cat].arrayTrackers[tracker]
                        trackers.append(tracker)
                        break
                    }
                }
            }
            if !trackers.isEmpty {
                let trackerCat = TrackerCategory(nameCategory: currentCategory.nameCategory, arrayTrackers: trackers)
                listCategories.append(trackerCat)
            }
        }
        return listCategories
    }
    
    private func filterListTrackersName(trackerCategory: [TrackerCategory], word: String) -> [TrackerCategory] {
        let listCategories: [TrackerCategory] = trackerCategory
        var newCategories: [TrackerCategory] = []
        let searchString = word.lowercased()
        listCategories.forEach { category in
            var newTrackers: [Tracker] = []
            category.arrayTrackers.forEach { tracker in
                if tracker.name.lowercased().hasPrefix(searchString) {
                    newTrackers.append(tracker)
                }}
            if !newTrackers.isEmpty {
                let newCategory = TrackerCategory(nameCategory: category.nameCategory, arrayTrackers: newTrackers)
                newCategories.append(newCategory)
            }
        }
        return newCategories
    }
    
    func dateComparison(date: Date, currentDate: Date) -> Bool {
        let result = Calendar.current.compare(date, to: currentDate, toGranularity: .day)
        var flag: Bool
        switch result {
        case .orderedAscending:
            flag = false
        case .orderedSame:
            flag = true
        case .orderedDescending:
            flag = true
        }
        return flag
    }
    
    private func showStabView(flag: Bool) {
        [placeholderImageView, placeholderLabel].forEach { $0.isHidden = flag }
    }

    private func createTrackerCollectionView() -> TrackerCollectionView {
        let params = GeometricParams(cellCount: 2, leftInset: 0, rightInset: 0, cellSpacing: 12)
        let layout = UICollectionViewFlowLayout()
        let trackerCollectionView = TrackerCollectionView(frame: .zero,
                                                          collectionViewLayout: layout,
                                                          params: params)
        return trackerCollectionView
    }
    
    private func registerCellAndHeader(collectionView: TrackerCollectionView) {
        collectionView.register(TrackersCollectionViewCell.self,
                                forCellWithReuseIdentifier: "\(TrackersCollectionViewCell.self)")
        collectionView.register(HeaderReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: "\(HeaderReusableView.self)")
    }
    
    private func setupUIElements() {
        setupVerticalStack()
        setupContentView()
        setupStubView()
        setupNavBarItem()
    }
    
    private func setupNavBarItem() {
        guard let navBar = navigationController?.navigationBar,
              let topItem = navBar.topItem
        else { return }
        topItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "add"),
                                                    style: .plain, target: self,
                                                    action: #selector(didTapLeftNavBarItem))
        
        topItem.rightBarButtonItem = UIBarButtonItem(customView: datePicker)
        topItem.leftBarButtonItem?.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        topItem.leftBarButtonItem?.tintColor = .blackDay
        navBar.backgroundColor = .clear
        
        navigationItem.title = "Трекеры"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let searcheController = UISearchController(searchResultsController: nil)
        searcheController.searchResultsUpdater = self
        searcheController.obscuresBackgroundDuringPresentation = false
        searcheController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searcheController
        searcheController.searchBar.placeholder = "Поиск"
        searcheController.searchBar.resignFirstResponder()
        searcheController.searchBar.returnKeyType = .search
        searcheController.searchBar.setValue("Отменить", forKey: "cancelButtonText")
        
    }
    
    private func setupContentView() {
        trackerCollectionView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(trackerCollectionView)
        
        NSLayoutConstraint.activate([
            trackerCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
            trackerCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            trackerCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            trackerCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        trackerCollectionView.delegate = self
        trackerCollectionView.dataSource = self
    }
    
    private func setupVerticalStack() {
        view.addSubview(mainVerticalStackView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.backgroundColor = .clear
        mainVerticalStackView.addArrangedSubview(contentView)
        
        NSLayoutConstraint.activate([
            mainVerticalStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mainVerticalStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mainVerticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainVerticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private func setupStubView() {
        [placeholderImageView, placeholderLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            placeholderImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            placeholderImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            placeholderLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            placeholderLabel.topAnchor.constraint(equalTo: placeholderImageView.bottomAnchor, constant: 10)
        ])
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return displayedCategories[section].arrayTrackers.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return displayedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "\(TrackersCollectionViewCell.self)",
                                                            for: indexPath) as? TrackersCollectionViewCell
        else { return UICollectionViewCell() }
        cell.delegate = self
        let tracker = displayedCategories[indexPath.section].arrayTrackers[indexPath.row]
        let dateComparison = Calendar.current.compare(Date(), to: selectedDate, toGranularity: .day)
        switch dateComparison {
        case .orderedAscending:
            cell.isEnableAddButton(flag: false)
            cell.updateBackgraundAddButton(isHidden: false)
        case .orderedSame:
            cell.isEnableAddButton(flag: true)
            cell.updateBackgraundAddButton(isHidden: true)
        case .orderedDescending:
            cell.isEnableAddButton(flag: true)
            cell.updateBackgraundAddButton(isHidden: true)
        }
        
        let count = getCountIdForCompletedTrackers(id: tracker.id)
        let isComplited = completedTrackers.contains (where: { $0.id == tracker.id && equalityDates(lDate: selectedDate, rDate: $0.date) })
        cell.config(tracker: tracker, count: count, isComplited: isComplited)
        
        return cell
    }
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = collectionView.frame.width - trackerCollectionView.params.paddingWidth
        let cellWidth = availableWidth / CGFloat(trackerCollectionView.params.cellCount)
        let sizeCell = CGSize(width: cellWidth, height:CGFloat(148))
        
        return sizeCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 10, left: trackerCollectionView.params.leftInset,
                     bottom: 16, right: trackerCollectionView.params.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: displayedCategories.count, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let supplementary = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "\(HeaderReusableView.self)", for: indexPath) as? HeaderReusableView else { return UICollectionReusableView() }
            supplementary.label.text = displayedCategories[indexPath.section].nameCategory
            return supplementary
        default:
            return UICollectionReusableView()
        }
    }
}

extension TrackersViewController: TrackersCollectionViewCellDelegate {
    func didTrackerCompleted(_ cell: UICollectionViewCell) {
        guard let trackerCell = cell as? TrackersCollectionViewCell,
              let indexPath = trackerCollectionView.indexPath(for: trackerCell)
        else { return }
 
        let tracker = displayedCategories[indexPath.section].arrayTrackers[indexPath.row]
        let recordTracker = completedTrackers.first(where: { $0.id == tracker.id && equalityDates(lDate: selectedDate, rDate: $0.date) })
        updateCompleted(recordTracker: recordTracker, cell: trackerCell, flag: recordTracker != nil, tracker: tracker)
    }
    
    private func updateCompleted(recordTracker: TrackerRecord?,
                                 cell: TrackersCollectionViewCell,
                                 flag: Bool,
                                 tracker: Tracker) {
        if let recordTracker {
            completedTrackers.remove(recordTracker)
            let newCount = getCountIdForCompletedTrackers(id: tracker.id)
            cell.updateLableCountAndImageAddButton(count: newCount, flag: !flag)
            return
        }
        let newTracker = TrackerRecord(id: tracker.id, date: selectedDate)
        completedTrackers.insert(newTracker)
        let newCount = getCountIdForCompletedTrackers(id: tracker.id)
        cell.updateLableCountAndImageAddButton(count: newCount, flag: !flag)
    }
    
    private func getCountIdForCompletedTrackers(id: UUID) -> Int {
        let countTrackerRecord = completedTrackers.filter { $0.id == id }
        let count = countTrackerRecord.count
        
        return count
    }
    
    func equalityDates(lDate: Date, rDate: Date?) -> Bool {
        guard let dateY = lDate.ignoringTime, let rDate ,let current = rDate.ignoringTime
        else { return false }
        let dateComparison = Calendar.current.compare(dateY , to: current, toGranularity: .day)
        if case .orderedSame = dateComparison {
            return true
        }
        return false
    }
}

extension TrackersViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let word = searchController.searchBar.text else { return }
        if !word.isEmpty {
            let newCategories = filterListTrackersName(trackerCategory: trackerCategories, word: word)
            updateTrackerCollectionView(trackerCategory: newCategories)
        }
        changeStub(text: "Ничего не найдено", nameImage: "nothing")
        
        if !searchController.isActive {
            showListTrackersForDay(trackerCategory: trackerCategories)
        }
    }
}

extension TrackersViewController: EventSelectionViewControllerDelegate {
    func eventSelectionViewController(vc: UIViewController, categories: [TrackerCategory]) {
        self.trackerCategories = categories
        manager.updateCategories(newCategories: categories)
        showListTrackersForDay(trackerCategory: self.trackerCategories)
    }
    
    func eventSelectionViewControllerDidCancel(_ vc: EventSelectionViewController) {
        vc.dismiss(animated: false)
    }
}
