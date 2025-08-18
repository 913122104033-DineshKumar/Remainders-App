import UIKit

class MenuViewCell: UICollectionViewCell
{
    open var menuView: UIView?
    open var menuImage: UIImageView?
    open var menuName: UILabel?
    open var menuNotesCountLabel: UILabel?
    
    
    public func configure(
        title: String,
        noOfTasks: String,
        iconName: String,
        iconColor: UIColor?
    )
    {
        self.menuView = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        
        self.menuImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: iconName),
            cornerRadius: 8,
            color: iconColor,
            isFrame: false
        )
        
        self.menuNotesCountLabel = ViewUtils.prepareTextLabelView(
            labelContent: noOfTasks,
            fontSize: 20,
            color: .black,
            isBold: true,
            isFrame: false
        )
        
        self.menuName = ViewUtils.prepareTextLabelView(
            labelContent: title,
            fontSize: 16,
            color: .systemGray4,
            isBold: false,
            isFrame: false
        )
        
        guard let image = self.menuImage,
              let title = self.menuName,
              let count = self.menuNotesCountLabel else { return }
        
        self.menuView?.addSubview(image)
        self.menuView?.addSubview(title)
        self.menuView?.addSubview(count)
        
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        guard let image = menuImage,
              let name = menuName,
              let count = menuNotesCountLabel,
              let view = menuView
        else { return }
    
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            
            view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: 20),
            image.heightAnchor.constraint(equalToConstant: 20),
            
            name.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 10),
            name.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
        
            count.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            count.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
        ])
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
    
}
