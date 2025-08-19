import UIKit

class AvailableListViewCell: UITableViewCell
{
    open var icon: UIImageView = {
        let imageView = ViewUtils.prepareImageView(
            image: UIImage(systemName: "list.bullet.circle.fill"),
            cornerRadius: 8,
            color: .systemBlue,
            isFrame: false
        )
        
        return imageView
    }()
    open var title: UILabel?
    open var tickMark: UIImageView = {
        let imageView = ViewUtils.prepareImageView(
            image: UIImage(systemName: "checkmark"),
            cornerRadius: 8,
            color: .systemBlue,
            isFrame: false
        )
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    public func configure(listName title: String)
    {
        
        self.title = ViewUtils.prepareTextLabelView(
            labelContent: title,
            fontSize: 16,
            color: .black,
            isBold: true,
            isFrame: false
        )
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        guard let title = self.title else { return }
        
        self.contentView.addSubview(title)
        self.contentView.addSubview(self.icon)
        self.contentView.addSubview(self.tickMark)
        
        self.tickMark.isHidden = true
        
        NSLayoutConstraint.activate([
        
            self.icon.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.icon.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 8),
            self.icon.widthAnchor.constraint(equalToConstant: 30),
            self.icon.heightAnchor.constraint(equalToConstant: 30),
            
            title.leadingAnchor.constraint(equalTo: self.icon.trailingAnchor, constant: 10),
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 11),
            
            self.tickMark.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -35),
            self.tickMark.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.tickMark.widthAnchor.constraint(equalToConstant: 20),
            self.tickMark.heightAnchor.constraint(equalToConstant: 20),
        
        ])
        
    }
}
