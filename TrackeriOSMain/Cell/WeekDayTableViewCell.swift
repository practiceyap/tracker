import UIKit

protocol WeekDayTableViewCellDelegate: AnyObject {
    func addDayInListkDay(cell: UITableViewCell, flag: Bool)
}

final class WeekDayTableViewCell: UITableViewCell {
    weak var delegate: WeekDayTableViewCellDelegate?
    
    private lazy var dayLabel: UILabel = {
        $0.font =  UIFont.systemFont(ofSize: 17, weight: .regular)
        
        return $0
    }(UILabel())
    
    private lazy var daySelectionSwitch: UISwitch = {
        $0.onTintColor = .blueDay
        $0.addTarget(self, action: #selector(daySwitchToggled), for: .touchUpInside)
        
        return $0
    }(UISwitch())
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .backgroundDay
        layer.masksToBounds = true
        contentView.backgroundColor = .clear
        setupUIElements()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension WeekDayTableViewCell {
    @objc
    func daySwitchToggled(_ sender: UISwitch) {
        guard let delegate else { return }
        delegate.addDayInListkDay(cell: self, flag: daySelectionSwitch.isOn)
    }

    func configureCornerRadius(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = maskedCorners
    }
    
    func configure(withWeekDay nameDay: WeekDay) {
        dayLabel.text = nameDay.day
    }
    
    private func setupUIElements() {
        [dayLabel, daySelectionSwitch].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            daySelectionSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            daySelectionSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
}
