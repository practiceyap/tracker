import UIKit

class NewCategoryViewController: UIViewController {
    private var categoryName: String = ""
    
    private lazy var newCategoryLabel: UILabel = {
        $0.text = "Новая категория"
        $0.textColor = .blackDay
        $0.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        $0.textAlignment = .center
        $0.backgroundColor = .clear
        
        return $0
    }(UILabel())
    
    private lazy var createCategoryButton: UIButton = {
        let button = createButton(text: "Новая категория", font: UIFont.systemFont(ofSize: 16, weight: .medium), cornerRadius: CGFloat(16))
        button.addTarget(self, action: #selector(didTapNewСategoryButton), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var createNameTextField: UITextField = {
        $0.placeholder = "Введите название категории"
        $0.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        $0.indent(size: CGFloat(12))
        $0.backgroundColor = .backgroundNight
        $0.layer.cornerRadius = CGFloat(16)
        $0.layer.masksToBounds = true
        $0.clearButtonMode = .whileEditing
        $0.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        return $0
    }(UITextField())
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

private extension NewCategoryViewController {
    
    @objc
    func didTapNewСategoryButton() {
        //TODO: -
    }
    
    @objc
    func textFieldDidChange() {
        //TODO: -
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
    
    func setupCreateCategoryButton() {
        view.addSubview(createCategoryButton)
        
        NSLayoutConstraint.activate([
            createCategoryButton.heightAnchor.constraint(equalToConstant: 60),
            createCategoryButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            createCategoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            createCategoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    
    func setupCategoryLabel() {
        view.addSubview(newCategoryLabel)
        newCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            newCategoryLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            newCategoryLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
