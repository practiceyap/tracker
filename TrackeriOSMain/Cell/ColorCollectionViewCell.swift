import UIKit

final class ColorCollectionViewCell: UICollectionViewCell {
   
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupColorView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ColorCollectionViewCell {
    private func setupColorView() {
       
    }
}
