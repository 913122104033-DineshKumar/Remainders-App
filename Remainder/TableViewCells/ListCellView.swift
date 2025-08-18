import UIKit

class ListCellView: UITableViewCell
{
    let configurations = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
    
    open lazy var deleteIcon: UIButton = {
        let delete = UIButton()
        
        delete.setImage(UIImage(systemName: "minus.circle.fill", withConfiguration: configurations), for: .normal)
        delete.tintColor = .systemRed
        
        return delete
    }()
    open lazy var listImage: UIImageView? = UIImageView()
    open lazy var listName: UILabel? = UILabel()
    open lazy var countLabel: UILabel? = UILabel()
    open lazy var rightArrowView: UIImageView = {
        let rightArrowImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "greaterthan"),
            cornerRadius: 8,
            color: .lightGray,
            isFrame: false
        )
        
        return rightArrowImage
    }()
    open lazy var verticalCrossBar: UIView = {
        let bar = UIView()
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .systemGray5
        
        return bar
    }()
    open lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle"), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    open lazy var reorderImage: UIImageView = {
        let image = UIImageView()
        
        image.image = UIImage(systemName: "line.3.horizontal", withConfiguration: configurations)
        image.setImageColor(color: .systemGray5)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    open lazy var deleteButton: UIButton = {
        let button = ViewUtils.prepareButtonView(
            buttonTitle: "Delete",
            backgroundColor: .systemRed,
            textColor: .white,
            fontSize: 16,
            cornerRadius: nil,
            isBold: false,
            isCustomButton: false,
            isFrame: false
        )
        
        button.titleLabel?.textAlignment = .center
        
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setListPageUI()
    {
        guard let image = self.listImage,
              let label = self.listName,
              let count = self.countLabel else { return }
        
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
        self.contentView.addSubview(count)
        self.contentView.addSubview(self.rightArrowView)
        
        NSLayoutConstraint.activate([
        
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 30),
            image.widthAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30),
            
            count.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            count.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -50),
            
            self.rightArrowView.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 13),
            self.rightArrowView.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            self.rightArrowView.heightAnchor.constraint(equalToConstant: 16),
            self.rightArrowView.widthAnchor.constraint(equalToConstant: 16),
            
        ])
        
    }
    
    public func setEditPageUI()
    {
        
        guard let image = self.listImage,
              let label = self.listName,
              let _ = self.countLabel else { return }
        
        self.contentView.addSubview(self.deleteIcon)
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
        self.contentView.addSubview(self.editButton)
        self.contentView.addSubview(self.verticalCrossBar)
        self.contentView.addSubview(self.reorderImage)
        self.contentView.addSubview(self.deleteButton)
        
        NSLayoutConstraint.activate([
        
            self.deleteIcon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.deleteIcon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.deleteIcon.widthAnchor.constraint(equalToConstant: 30),
            self.deleteIcon.heightAnchor.constraint(equalToConstant: 30),
            
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            image.leadingAnchor.constraint(equalTo: self.deleteIcon.trailingAnchor, constant: 20),
            image.heightAnchor.constraint(equalToConstant: 30),
            image.widthAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 30),
            
            self.editButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.editButton.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -150),
            self.editButton.heightAnchor.constraint(equalToConstant: 30),
            self.editButton.widthAnchor.constraint(equalToConstant: 30),
            
            self.verticalCrossBar.leadingAnchor.constraint(equalTo: self.editButton.trailingAnchor, constant: 10),
            self.verticalCrossBar.widthAnchor.constraint(equalToConstant: 1),
            self.verticalCrossBar.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            
            self.reorderImage.leadingAnchor.constraint(equalTo: self.verticalCrossBar.trailingAnchor, constant: 10),
            self.reorderImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.reorderImage.widthAnchor.constraint(equalToConstant: 30),
            self.reorderImage.heightAnchor.constraint(equalToConstant: 30),
            
            self.deleteButton.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 1),
            self.deleteButton.widthAnchor.constraint(equalToConstant: 40),
            self.deleteButton.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
        
        ])
    }
}
