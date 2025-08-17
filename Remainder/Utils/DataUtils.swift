import Foundation
import UIKit

class DataUtils
{
    public static func notMatches(
        pattern: String,
        text: String
    ) -> Bool
    {
        do
        {
            let regex = try NSRegularExpression(pattern: pattern)
            let range = NSRange(location: 0, length: text.utf16.count)
            return regex.firstMatch(in: text, range: range) == nil
        } catch
        {
            return true
        }
    }
    
    public static func showToast(
        message: String,
        view: UIView
    )
    {
        let label = UILabel()
        label.text = message
        label.clipsToBounds = true
        label.backgroundColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.textAlignment = .center
        
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            label.widthAnchor.constraint(equalToConstant: 300),
            label.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        UIView.animate(withDuration: 2, delay: 0, animations: {
            label.layer.cornerRadius = 16
            label.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        })
        { isCompleted in
            label.removeFromSuperview()
        }
        
    }
    
}

