import UIKit

class ViewUtils
{
    public static func prepareTextLabelView(
        labelContent text: String,
        fontSize: CGFloat,
        color: UIColor,
        isBold: Bool,
        isFrame constraintPreference: Bool
    ) -> UILabel
    {
        let label = UILabel()
        
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: isBold ? .bold : .medium)
        label.textColor = color
        label.translatesAutoresizingMaskIntoConstraints = constraintPreference
        
        return label
    }
    
    public static func prepareTextFieldView(
        placeHolder: String?,
        textColor: UIColor?,
        font: CGFloat?,
        isRounded borderPreference: Bool,
        cornerRadius: CGFloat?,
        isFrame constraintPreference: Bool
    ) -> UITextField
    {
        let textField = UITextField()
        
        textField.borderStyle = borderPreference ? .roundedRect : .none
        textField.layer.cornerRadius = cornerRadius ?? 0
        textField.translatesAutoresizingMaskIntoConstraints = constraintPreference
        textField.textColor = textColor ?? .white
        textField.placeholder = placeHolder ?? ""
        textField.textAlignment = .left
        textField.font = .systemFont(ofSize: font ?? 12)
        
        return textField
    }
    
    public static func prepareTextView(
        placeHolder: String?,
        textColor: UIColor?,
        font: CGFloat?,
        cornerRadius: CGFloat?,
        isFrame constraintPreference: Bool
    ) -> UITextView
    {
        let textView = UITextView()
        
        textView.layer.cornerRadius = cornerRadius ?? 0
        textView.translatesAutoresizingMaskIntoConstraints = constraintPreference
        textView.textColor = textColor ?? .white
        textView.textAlignment = .left
        textView.text = placeHolder ?? ""
        textView.font = .systemFont(ofSize: font ?? 12)
        
        return textView
    }
    
    public static func prepareButtonView(
        buttonTitle title: String,
        backgroundColor bgColor: UIColor,
        textColor: UIColor,
        fontSize: CGFloat?,
        cornerRadius: CGFloat?,
        isBold: Bool,
        isCustomButton: Bool,
        isFrame constraintPreference: Bool
    ) -> UIButton
    {
        let button = UIButton(type: isCustomButton ? .custom : .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(textColor, for: .normal)
        button.layer.cornerRadius = cornerRadius ?? 12
        button.backgroundColor = bgColor
        button.titleLabel?.font = .systemFont(ofSize: fontSize ?? 12, weight: isBold ? .bold : .medium)
        button.translatesAutoresizingMaskIntoConstraints = constraintPreference
        
        return button
    }
    
    public static func prepareDivider() -> UIView
    {
        let separator = UIView()
        separator.backgroundColor = .systemGray5
        separator.translatesAutoresizingMaskIntoConstraints = false
        
        return separator
    }
    
    public static func prepareStackView(
        isVertical axisPreference: Bool,
        spacing space: CGFloat,
        isFrame constraintPreference: Bool,
        backgroundColor bgColor: UIColor,
        cornerRadius: CGFloat?
    ) -> UIStackView
    {
        let stackView = UIStackView()
        
        stackView.axis = axisPreference ? .vertical : .horizontal
        stackView.spacing = space
        stackView.translatesAutoresizingMaskIntoConstraints = constraintPreference
        stackView.backgroundColor = bgColor
        stackView.distribution = .fillEqually
        stackView.layer.cornerRadius = cornerRadius ?? 0
        
        return stackView
    }
    
    public static func prepareView(
        cornerRadius: CGFloat?,
        backgroundColor bgColor: UIColor,
        isFrame constraintPreference: Bool
    ) -> UIView
    {
        let view = UIView()
        
        view.translatesAutoresizingMaskIntoConstraints = constraintPreference
        view.layer.cornerRadius = cornerRadius ?? 0
        view.backgroundColor = bgColor
        view.clipsToBounds = false
        
        return view
    }
    
    public static func prepareImageView(
        image: UIImage?,
        cornerRadius: CGFloat,
        color: UIColor?,
        isFrame constraintPreference: Bool
    ) -> UIImageView
    {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.layer.cornerRadius = cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = constraintPreference
        imageView.setImageColor(color: color ?? .systemBlue)
        
        return imageView
    }
    
    public static func prepareScrollView(
        edgeInsets: UIEdgeInsets,
        isFrame contentPreference: Bool
    ) -> UIScrollView
    {
        let scrollView = UIScrollView()
        
        scrollView.contentInset = edgeInsets
        scrollView.translatesAutoresizingMaskIntoConstraints = contentPreference
        
        return scrollView
    }
}

extension UIImageView
{
    func setImageColor(color: UIColor)
    {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
