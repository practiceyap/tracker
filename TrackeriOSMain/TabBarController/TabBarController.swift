import UIKit

final class TabBarController: UITabBarController {
    let trackerViewController = TrackersViewController()
    let statisticViewController = StatisticViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBarAppearance()
        
        let trackerNavigationController = UINavigationController(rootViewController: trackerViewController)
        let statisticNavigationController = UINavigationController(rootViewController: statisticViewController)
        
        viewControllers = [
            createTabViewController(vc: trackerNavigationController, imageName: "record.circle.fill", title: "Трекеры"),
            createTabViewController(vc: statisticNavigationController, imageName: "hare.fill", title: "Статистика")
        ]
    }
}

private extension TabBarController {
    func createTabViewController(vc: UIViewController, imageName: String, title: String) -> UIViewController {
        vc.tabBarItem.image = UIImage(systemName: imageName)
        vc.tabBarItem.title = title
        vc.tabBarItem.imageInsets = UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
        
        return vc
    }
    
    func configureTabBarAppearance() {
        tabBar.layer.borderWidth = 1
        tabBar.layer.borderColor = UIColor.grayDay.cgColor
        tabBar.clipsToBounds = true
    }
}
