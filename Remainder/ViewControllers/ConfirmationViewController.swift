import UIKit

class ConfirmationViewController
{
    public static var stackView = ViewUtils.prepareStackView(
        isVertical: true,
        spacing: 5,
        isFrame: false,
        backgroundColor: .clear,
        cornerRadius: nil
    )
    
    public static var discardChangesButton = ViewUtils.prepareButtonView(
        buttonTitle: "Discard Changes",
        backgroundColor: .systemGray5,
        textColor: .systemRed,
        fontSize: 18,
        cornerRadius: 16,
        isBold: false,
        isCustomButton: false,
        isFrame: false
    )
    
    public static var cancelButton = ViewUtils.prepareButtonView(
        buttonTitle: "Cancel",
        backgroundColor: .white,
        textColor: .systemBlue,
        fontSize: 18,
        cornerRadius: 16,
        isBold: false,
        isCustomButton: false,
        isFrame: false
    )
    
}
