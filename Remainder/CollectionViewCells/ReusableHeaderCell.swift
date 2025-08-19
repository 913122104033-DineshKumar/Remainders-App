import UIKit

class ReusableHeaderCell: UICollectionReusableView
{
    
    let label: UILabel = {
        let label = ViewUtils.prepareTextLabelView(
            labelContent: "My Lists",
            fontSize: 20,
            color: .black,
            isBold: true,
            isFrame: false
        )
        
        return label
    }()
    
    public func configure()
    {
        backgroundColor = .clear
        addSubview(label)
        setConstraints()
    }
    
    private func setConstraints()
    {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ])
    }
    
}
