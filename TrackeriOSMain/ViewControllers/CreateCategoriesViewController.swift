import UIKit

protocol CreateCategoriesViewControllerDelegate: AnyObject {
    func createCategoriesViewController(vc: UIViewController, nameCategory: String)
    func createCategoriesViewControllerDidCancel(vc: CreateCategoriesViewController)
}

final class CreateCategoriesViewController: UIViewController {
    weak var delegate: CreateCategoriesViewControllerDelegate?
    
    private var categories: [String] = ["Важное"]
    private var selectedCategoryName: String = ""
    
    
    private lazy var categoryLabel: UILabel = {
        $0.text = "Категория"
        $0.textColor = .blackDay
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        
        return $0
    }(UILabel())
    
    private lazy var imageViewPlaceholder: UIImageView = {
        return $0
    }(UIImageView(image: UIImage(named: "star")))
    
    private lazy var labelTextPlaceholder: UILabel = {
        $0.text = "Привычки и события можно объединить по смыслу"
        $0.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        $0.numberOfLines = 2
        $0.textAlignment = .center
        
        return $0
    }(UILabel())
    
    private lazy var containerPlaceholderView: UIView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .clear
        $0.isHidden = false
        
        return $0
    }(UIView())
    
    private lazy var categorySelectionTableView: UITableView = {
        $0.dataSource = self
        $0.allowsSelection = false
        $0.backgroundColor = .clear
        $0.isScrollEnabled = false
        $0.separatorStyle = .none
        $0.register(CreateCategoriesTableViewCell.self, forCellReuseIdentifier: "\(CreateCategoriesTableViewCell.self)")
        
        return $0
    }(UITableView())
    
    private lazy var createCategoryButton: UIButton = {
        let button = createButton(text: "Добавить категорию", font: UIFont.systemFont(ofSize: 16, weight: .medium), cornerRadius: CGFloat(16))
        button.addTarget(self, action: #selector(didTapCategoryButton), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .whiteDay
        setupUIElements()
        showStubView(flag: !categories.isEmpty)
        categorySelectionTableView.rowHeight = 75
    }
}

private extension CreateCategoriesViewController {
    @objc
    func didTapCategoryButton() {
        delegate?.createCategoriesViewController(vc: self, nameCategory: selectedCategoryName)

    }
    
    func showStubView(flag: Bool) {
        containerPlaceholderView.isHidden = flag
    }
    
    func setupUIElements() {
        setupCategoryButton()
        setupCategoryLabel()
        setupTableView()
        setupPlaceholderView()
    }
    
    func createButton(text: String, font: UIFont, cornerRadius: CGFloat? = nil) -> UIButton {
        let button = UIButton()
        button.setTitle(text, for: .normal)
        button.titleLabel?.textColor = UIColor.whiteDay
        button.backgroundColor = UIColor.blackDay
        button.titleLabel?.font = font
        button.layer.cornerRadius = cornerRadius ?? CGFloat(0)
        button.layer.masksToBounds = cornerRadius == nil ? false : true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        return button
    }
    
    func setupCategoryButton() {
        view.addSubview(createCategoryButton)
        
        NSLayoutConstraint.activate([
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCategoryLabel() {
        view.addSubview(categoryLabel)
        categoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            categoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    func setupTableView() {
        view.addSubview(categorySelectionTableView)
        categorySelectionTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categorySelectionTableView.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor, constant: 24),
            categorySelectionTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            categorySelectionTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -16),
            categorySelectionTableView.bottomAnchor.constraint(equalTo: createCategoryButton.topAnchor)
        ])
    }
    
    func setupPlaceholderView() {
        view.addSubview(containerPlaceholderView)
        [imageViewPlaceholder, labelTextPlaceholder].forEach {
            containerPlaceholderView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.backgroundColor = .clear
        }
        
        NSLayoutConstraint.activate([
            containerPlaceholderView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            containerPlaceholderView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            imageViewPlaceholder.centerYAnchor.constraint(equalTo: containerPlaceholderView.centerYAnchor),
            imageViewPlaceholder.centerXAnchor.constraint(equalTo: containerPlaceholderView.centerXAnchor),
            
            labelTextPlaceholder.widthAnchor.constraint(equalToConstant: 200),
            labelTextPlaceholder.centerXAnchor.constraint(equalTo: containerPlaceholderView.centerXAnchor),
            labelTextPlaceholder.topAnchor.constraint(equalTo: imageViewPlaceholder.bottomAnchor, constant: 10)
        ])
    }
}

extension CreateCategoriesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "\(CreateCategoriesTableViewCell.self)") as? CreateCategoriesTableViewCell else { return UITableViewCell() }
        let text = categories[indexPath.row]
        cell.configure(text: text)
        
        return cell
    }
}
