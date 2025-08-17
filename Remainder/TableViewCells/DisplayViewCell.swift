import UIKit

class CheckBox: UIButton
{
    let checkedImage = UIImage(systemName: "checkmark.circle.fill")
    let uncheckedImage = UIImage(systemName: "button.horizontal")
    
    var isChecked: Bool = false {
        didSet{
            if isChecked == true
            {
                self.setImage(checkedImage, for: .normal)
            } else {
                self.setImage(uncheckedImage, for: .normal)
            }
        }
    }
    
    override func awakeFromNib()
    {
        self.addTarget(self, action: #selector(buttonClicked(_ :)), for: .touchUpInside)
        self.isChecked = false
    }
    
    @objc func buttonClicked(_ sender: UIButton)
    {
        if sender == self
        {
            isChecked = !isChecked
        }
    }
}

class DisplayViewCell: UITableViewCell
{
    
    open lazy var checkBox: CheckBox = {
        let checkBox = CheckBox()
        
        checkBox.translatesAutoresizingMaskIntoConstraints = false
        checkBox.layer.cornerRadius = 8
    
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
    
    private func setConstraints()
    {
        guard let image = displayImage,
              let label = displayLabel else { return }
        
        NSLayoutConstraint.activate([
        
            self.checkBox.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.checkBox.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 20),
            
            image.leadingAnchor.constraint(equalTo: self.checkBox.trailingAnchor, constant: 20),
            image.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            image.widthAnchor.constraint(equalToConstant: 30),
            image.heightAnchor.constraint(equalToConstant: 30),
            
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 20),
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            
            self.reorderImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 20),
            self.reorderImage.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 30),
            self.reorderImage.widthAnchor.constraint(equalToConstant: 30),
            self.reorderImage.heightAnchor.constraint(equalToConstant: 30),
            
            
        ])
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
    }
}
