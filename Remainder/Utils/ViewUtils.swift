import UIKit

class ViewUtils
{
    public static func prepareTextLabelView(
        labelContent text: String,
        fontSize: CGFloat,
        color: UIColor,
        isFrame constraintPreference: Bool
    ) -> UILabel
    {
        let label = UILabel()
        
        label.text = text
        label.font = .systemFont(ofSize: fontSize, weight: .bold)
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
        isFrame constraintPreference: Bool,
        backgroundColor bgColor: UIColor
    ) -> UIButton
    {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 10
        button.backgroundColor = bgColor
        button.titleLabel?.textColor = .white
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
        
        return view
    }
    
    public static func prepareImageView(
        image: UIImage?,
        cornerRadius: CGFloat,
        color: UIColor,
        isFrame constraintPreference: Bool
    ) -> UIImageView
    {
        let imageView = UIImageView()
        
        imageView.image = image
        imageView.layer.cornerRadius = cornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = constraintPreference
        imageView.setImageColor(color: color)
        
        return imageView
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
