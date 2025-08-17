import UIKit

class AddListViewController: UIViewController
{
    
    open var delegate: NoteDelegate?
    
    private lazy var creationView: UIView = UIView()
    private lazy var showListImageView: UIImageView = UIImageView()
    private lazy var listNameField: UITextField = UITextField()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.navBarSetup()
        
        self.setUIs()
    }
    
    private func navBarSetup()
    {
        self.title = "New List"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneAction)
        )
        
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelAction)
        )
    }
    
    private func setUIs()
    {
        self.creationView = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        self.view.addSubview(creationView)
        
        self.showListImageView = ViewUtils.prepareImageView(
            image: UIImage(systemName: "list.bullet.circle.fill"),
            cornerRadius: 10,
            color: .systemBlue,
            isFrame: false
        )
        self.creationView.addSubview(self.showListImageView)
        
        self.listNameField = ViewUtils.prepareTextFieldView(
            placeHolder: "List Name",
            textColor: .systemBlue,
            font: 20,
            isRounded: true,
            cornerRadius: 12,
            isFrame: false
        )
        self.listNameField.textAlignment = .center
        self.listNameField.backgroundColor = .systemGray4
        self.listNameField.delegate = self
        self.listNameField.becomeFirstResponder()
        self.creationView.addSubview(self.listNameField)
        
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        
        NSLayoutConstraint.activate([
            
            self.creationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: height * 0.01),
            self.creationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: width * 0.05),
            self.creationView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.creationView.heightAnchor.constraint(equalToConstant: height * 0.2),
            
            self.showListImageView.leadingAnchor.constraint(equalTo: self.creationView.leadingAnchor, constant: width * 0.3),
            self.showListImageView.widthAnchor.constraint(equalToConstant: 100),
            self.showListImageView.heightAnchor.constraint(equalToConstant: 100),
            
            self.listNameField.topAnchor.constraint(equalTo: self.showListImageView.bottomAnchor, constant: height * 0.01),
            self.listNameField.leadingAnchor.constraint(equalTo: self.creationView.leadingAnchor, constant: width * 0.05),
            self.listNameField.widthAnchor.constraint(equalToConstant: width * 0.78),
            self.listNameField.heightAnchor.constraint(equalToConstant: height * 0.05)
            
        ])
    }
    
}

extension AddListViewController
{
    @objc private func doneAction()
    {
        guard let title = self.listNameField.text else { return }
        
        if !DataUtils.notMatches(pattern: "[a-zA-Z0-9/s]+", text: title)
        {
            self.delegate?.receiveListData(title)
            self.dismiss(animated: true)
        }
    }
    
    @objc private func cancelAction()
    {
        if self.listNameField.text?.isEmpty == true
        {
            self.dismiss(animated: true)
            return
        }
        
        let stackView = ConfirmationViewController.stackView
        
        let discardChangesButton = ConfirmationViewController.discardChangesButton
        discardChangesButton.addAction(
            UIAction { action in
                stackView.removeFromSuperview()
                self.dismiss(animated: true)
            },
            for: .touchUpInside
        )
        
        let cancelButton = ConfirmationViewController.cancelButton
        cancelButton.addAction(
            UIAction { action in
                stackView.removeFromSuperview()
            },
            for: .touchUpInside
        )

        stackView.addArrangedSubview(discardChangesButton)
        stackView.addArrangedSubview(cancelButton)
        
        self.view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            stackView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: self.view.bounds.width * 0.02),
            stackView.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.95),
            stackView.heightAnchor.constraint(equalToConstant: 110),
            
            discardChangesButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            discardChangesButton.heightAnchor.constraint(equalToConstant: 50),
            
            cancelButton.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            
        ])
    }
}

extension AddListViewController: UITextFieldDelegate
{
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        if self.listNameField.text?.isEmpty == false
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
        } else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
}

