import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func daysOfWeek(viewController: UIViewController, listDays:[WeekDay])
}

final class ScheduleViewController: UIViewController {
    private let weekDays: [WeekDay] = [.monday, .tuesday, .wednesday, .thursday, .friday, .saturday, .sunday]
    weak var delegate: ScheduleViewControllerDelegate?
    private var selectedWeekDays: [WeekDay] = []
    
    private lazy var scheduleLabel: UILabel = {
        $0.text = "Расписание"
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textColor = .blackDay
        $0.backgroundColor = .clear
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    private lazy var weekDayTableView: UITableView = {
        $0.dataSource = self
        $0.delegate = self
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.separatorInset = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
        $0.register(WeekDayTableViewCell.self, forCellReuseIdentifier: "\(WeekDayTableViewCell.self)")
        
        return $0
    }(UITableView())
    
    private lazy var confirmScheduleButton: UIButton = {
        $0.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.masksToBounds = true
        $0.backgroundColor = .blackDay
        $0.setTitle("Готово", for: .normal)
        $0.titleLabel?.textColor = .whiteDay
        
        return $0
    }(UIButton())
    
    private var scheduleContentStackView: UIStackView = {
        $0.axis = .vertical
        $0.backgroundColor = .clear
        $0.translatesAutoresizingMaskIntoConstraints = false
        
        return $0
    }(UIStackView())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupContentSteck()
    }
}


private extension ScheduleViewController {
    @objc
    func didTapDoneButton() {
        guard let delegate else { return }

        delegate.daysOfWeek(viewController: self, listDays: selectedWeekDays)
        dismiss(animated: true)
    }
    

    func updateListWeekDay(flag: Bool, day: WeekDay) {
        if flag {
            var listDay: [WeekDay] = []
            listDay = selectedWeekDays
            listDay.append(day)
            selectedWeekDays = listDay
        } else {
            var listDay: [WeekDay] = []
            listDay = selectedWeekDays
            guard let index = listDay.firstIndex(of: day) else { return }
            listDay.remove(at: index)
            selectedWeekDays = listDay
        }
    }
    
    func setupContentSteck() {
        view.addSubview(scheduleContentStackView)
        [scheduleLabel, weekDayTableView, confirmScheduleButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            scheduleContentStackView.addArrangedSubview($0)
        }
        scheduleContentStackView.setCustomSpacing(38, after: scheduleLabel)
        
        NSLayoutConstraint.activate([
            scheduleContentStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            scheduleContentStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            scheduleContentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            scheduleContentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            confirmScheduleButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weekDays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(WeekDayTableViewCell.self)") as? WeekDayTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configure(withWeekDay: weekDays[indexPath.row])
        
        if weekDays[indexPath.row] == weekDays.first {
            cell.configureCornerRadius(cornerRadius: CGFloat(16),
                                   maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            
        }
        if weekDays[indexPath.row] == weekDays.last {
            cell.configureCornerRadius(cornerRadius: CGFloat(16),
                                   maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: .greatestFiniteMagnitude)
        }
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(75)
    }
}

extension ScheduleViewController: WeekDayTableViewCellDelegate {
    func addDayInListkDay(cell: UITableViewCell, flag: Bool) {
        guard let cell = cell as? WeekDayTableViewCell,
              let indexPath = weekDayTableView.indexPath(for: cell)
        else { return }
        let day = weekDays[indexPath.row]
        updateListWeekDay(flag: flag, day: day)
        
    }
}

