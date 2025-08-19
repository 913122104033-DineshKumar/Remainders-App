import UIKit

class CheckBox: UIButton
{
    let checkedImage = UIImage(systemName: "checkmark.circle.fill")
    let uncheckedImage = UIImage(named: "unchecked_image")
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true
            {
                self.setImage(checkedImage, for: .normal)
                self.layer.cornerRadius = 20
            } else {
                self.setImage(uncheckedImage, for: .normal)
                self.tintColor = .lightGray
                self.layer.cornerRadius = 20
            }
        }
    }
}

class DisplayViewCell: UITableViewCell
{
    
    open lazy var checkBox: CheckBox = {
        let checkBox = CheckBox()
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.layer.cornerRadius = 16
    
        return checkBox
    }()
    open lazy var displayImage: UIImageView? = UIImageView()
    open lazy var displayLabel: UILabel? = UILabel()
    open lazy var reorderImage: UIImageView = {
        let image = UIImageView()
        
        let configurations = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
        image.image = UIImage(systemName: "line.3.horizontal", withConfiguration: configurations)
        image.setImageColor(color: .systemGray5)
        image.translatesAutoresizingMaskIntoConstraints = false
        
        return image
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(
        iconName: String,
        iconColor: UIColor?,
        title: String
    )
    {
        self.displayImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: iconName),
            cornerRadius: 8,
            color: iconColor,
            isFrame: false
        )
        
        self.displayLabel = ViewUtils.prepareTextLabelView(
            labelContent: title,
            fontSize: 16,
            color: .lightGray,
            isBold: false,
            isFrame: false
        )
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        guard let image = displayImage,
              let label = displayLabel else { return }
        
        self.checkBox.isChecked = true
        self.contentView.addSubview(self.checkBox)
        self.contentView.addSubview(image)
        self.contentView.addSubview(label)
        self.contentView.addSubview(self.reorderImage)
        
        NSLayoutConstraint.activate([
        
            self.checkBox.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.checkBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            self.checkBox.widthAnchor.constraint(equalToConstant: 25),
            self.checkBox.heightAnchor.constraint(equalToConstant: 25),
            
            image.leadingAnchor.constraint(equalTo: self.checkBox.trailingAnchor, constant: 20),
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30),
            
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            self.reorderImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.reorderImage.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -30),
            self.reorderImage.widthAnchor.constraint(equalToConstant: 25),
            self.reorderImage.heightAnchor.constraint(equalToConstant: 25),
            
            
        ])
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
}
