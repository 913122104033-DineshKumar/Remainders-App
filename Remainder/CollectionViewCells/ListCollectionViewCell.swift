import UIKit

class ListCollectionViewCell: UICollectionViewCell
{
    open var listView: UIView?
    open lazy var listImage: UIImageView? = UIImageView()
    open lazy var listName: UILabel? = UILabel()
    open lazy var countLabel: UILabel? = UILabel()
    open lazy var rightArrowView: UIImageView = {
        let rightArrowImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "chevron.right"),
            cornerRadius: 10,
            color: .lightGray,
            isFrame: false
        )
        
        return rightArrowImage
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func configure(
        title: String,
        noOfTasks: String?
    )
    {
        self.listView = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        
        self.listImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "list.bullet.circle.fill"),
            cornerRadius: 10,
            color: .systemBlue,
            isFrame: false
        )
        self.listName = ViewUtils.prepareTextLabelView(
            labelContent: title,
            fontSize: 16,
            color: .black,
            isBold: true,
            isFrame: false
        )
        if let count = noOfTasks
        {
            self.countLabel = ViewUtils.prepareTextLabelView(
                labelContent: count,
                fontSize: 20,
                color: .systemGray4,
                isBold: true,
                isFrame: false
            )
        }
        
        guard let image = self.listImage,
              let title = self.listName,
              let count = self.countLabel else { return }
        
        self.listView?.addSubview(image)
        self.listView?.addSubview(title)
        self.listView?.addSubview(count)
        self.listView?.addSubview(self.rightArrowView)
    }
    
    public func setListPageUI()
    {
        guard let image = self.listImage,
              let label = self.listName,
              let count = self.countLabel,
              let view = self.listView
        else { return }
        
        self.contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
        
            view.widthAnchor.constraint(equalTo: self.contentView.widthAnchor),
            view.heightAnchor.constraint(equalTo: self.contentView.heightAnchor),
            view.topAnchor.constraint(equalTo: self.contentView.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor),
            
            image.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            image.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            image.heightAnchor.constraint(equalToConstant: 30),
            image.widthAnchor.constraint(equalToConstant: 30),
            
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: image.trailingAnchor, constant: 15),
            
            count.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            count.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            
            self.rightArrowView.topAnchor.constraint(equalTo: view.topAnchor, constant: 14),
            self.rightArrowView.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            self.rightArrowView.heightAnchor.constraint(equalToConstant: 15),
            self.rightArrowView.widthAnchor.constraint(equalToConstant: 15),
            
        ])
        
    }
    
    override func prepareForReuse()
    {
        super.prepareForReuse()
        
    }
}

