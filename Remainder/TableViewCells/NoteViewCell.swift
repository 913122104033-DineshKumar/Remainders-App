import UIKit

class NoteViewCell: UITableViewCell
{
    open lazy var finishButton: CheckBox = {
        let button = CheckBox()
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 10
        
        return button
    }()
    open lazy var editButton: UIButton = {
        let button = UIButton(type: .custom)
        let configuration = UIImage.SymbolConfiguration(font: .systemFont(ofSize: 22), scale: .medium)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "info.circle", withConfiguration: configuration), for: .normal)
        button.tintColor = .systemBlue
        
        return button
    }()
    open lazy var divider = ViewUtils.prepareDivider()
    open var titleField: UILabel?
    open var contentField: UILabel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(
        title: String,
        content: String
    )
    {
        self.titleField = ViewUtils.prepareTextLabelView(
            labelContent: title,
            fontSize: 14,
            color: .black,
            isBold: false,
            isFrame: false
        )
        
        self.contentField = ViewUtils.prepareTextLabelView(
            labelContent: content,
            fontSize: 13,
            color: .lightGray,
            isBold: false,
            isFrame: false
        )
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        guard let title = self.titleField,
              let content = self.contentField else { return }
        
        self.contentView.addSubview(self.finishButton)
        self.contentView.addSubview(title)
        self.contentView.addSubview(content)
        self.contentView.addSubview(self.divider)
        self.contentView.addSubview(self.editButton)
        
        self.finishButton.isChecked = false
        
        NSLayoutConstraint.activate([
        
            self.finishButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.finishButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            self.finishButton.widthAnchor.constraint(equalToConstant: 30),
            self.finishButton.heightAnchor.constraint(equalToConstant: 30),
            
            title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15),
            title.leadingAnchor.constraint(equalTo: self.finishButton.trailingAnchor, constant: 10),
            
            self.divider.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            self.divider.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 40),
            self.divider.widthAnchor.constraint(equalToConstant: 150),
            self.divider.heightAnchor.constraint(equalToConstant: 1),
            
            content.topAnchor.constraint(equalTo: self.divider.bottomAnchor, constant: 10),
            content.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 50),
            
            self.editButton.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            self.editButton.leadingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -60),
            self.editButton.widthAnchor.constraint(equalToConstant: 50),
            self.editButton.heightAnchor.constraint(equalToConstant: 50),
            
        ])
        
        
    }
    
}
