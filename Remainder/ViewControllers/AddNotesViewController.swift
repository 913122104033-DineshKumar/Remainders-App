import UIKit

class AddNotesViewController: UIViewController, UIGestureRecognizerDelegate
{
    weak var delegate: NoteDelegate?
    private var notes: Notes?
    private var listItem: ListIem?
    private var listID: String?
    private var listName: String?
    private var notesIDs: [String]?
    
    private lazy var notesCreationView: UIView = UIView()
    private lazy var listSelectionView: UIView = UIView()

    private lazy var noteTitleField: UITextField = UITextField()
    private lazy var viewSeparator: UIView = ViewUtils.prepareDivider()
    private lazy var noteContentView: UITextView = UITextView()
    
    private lazy var listImage: UIImageView = UIImageView()
    private lazy var listLabel: UILabel = UILabel()
    private lazy var listNameLabel: UILabel = UILabel()
    private lazy var rightArrowImage: UIImageView = UIImageView()
    
    init(notes: Notes?)
    {
        self.notes = notes
        self.listID = nil
        self.listName = nil
        self.notesIDs = nil
        super.init(nibName: nil, bundle: nil)
    }
    
    init(notes: Notes?, listID: String, listName: String, notesIDs: [String])
    {
        self.notes = notes
        self.listID = listID
        self.listName = listName
        self.notesIDs = notesIDs
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder)
    {
        fatalError()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.navBarSetup()
        
        self.setUI()
    }
    
    private func navBarSetup()
    {
        self.title = "New Remainder"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Add",
            style: .plain,
            target: self,
            action: #selector(addRemainderAction)
        )
        self.navigationItem.rightBarButtonItem?.isEnabled = false
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Cancel",
            style: .plain,
            target: self,
            action: #selector(cancelAction)
        )
    }
    
    private func setUI()
    {
        self.notesCreationView = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        self.view.addSubview(self.notesCreationView)
        
        self.noteTitleField = ViewUtils.prepareTextFieldView(
            placeHolder: "Title",
            textColor: .lightGray,
            font: 16,
            isRounded: false,
            cornerRadius: nil,
            isFrame: false
        )
        self.noteTitleField.delegate = self
        self.noteTitleField.becomeFirstResponder()
        self.notesCreationView.addSubview(self.noteTitleField)
        
        self.notesCreationView.addSubview(self.viewSeparator)
        
        self.noteContentView = ViewUtils.prepareTextView(
            placeHolder: "Notes",
            textColor: .lightGray,
            font: 16,
            cornerRadius: nil,
            isFrame: false
        )
        self.noteContentView.delegate = self
        self.notesCreationView.addSubview(self.noteContentView)
        
        self.listSelectionView = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        self.view.addSubview(self.listSelectionView)
        
        self.listImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "list.bullet.circle.fill"),
            cornerRadius: 10,
            color: .systemYellow,
            isFrame: false
        )
        self.listSelectionView.addSubview(self.listImage)
        
        self.listLabel = ViewUtils.prepareTextLabelView(
            labelContent: "List",
            fontSize: 16,
            color: .black,
            isBold: true,
            isFrame: false
        )
        self.listSelectionView.addSubview(self.listLabel)
        
        self.listNameLabel = ViewUtils.prepareTextLabelView(
            labelContent: listName ?? "Remainders",
            fontSize: 16,
            color: .lightGray,
            isBold: true,
            isFrame: false
        )
        self.listNameLabel.numberOfLines = 2
        self.listSelectionView.addSubview(self.listNameLabel)
        
        self.rightArrowImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "greaterthan"),
            cornerRadius: 8,
            color: .lightGray,
            isFrame: false
        )
        self.listSelectionView.addSubview(self.rightArrowImage)
        
        self.listSelectionView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showListAction)))
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(goToAvailableListPage))
        self.listSelectionView.addGestureRecognizer(tapGesture)
        
        self.setConstraints()
        
        self.setDataIfEditing()
        
    }
    
    private func setConstraints()
    {
        
        let leadingSpace = self.view.bounds.width * 0.05
        let topGap = self.view.bounds.height * 0.05
        let height = self.view.bounds.height
        let width = self.view.bounds.width * 0.9
        
        NSLayoutConstraint.activate([
            
            self.notesCreationView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpace),
            self.notesCreationView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: topGap),
            self.notesCreationView.widthAnchor.constraint(equalToConstant: width),
            self.notesCreationView.heightAnchor.constraint(equalToConstant: height * 0.20),
            
            self.noteTitleField.leadingAnchor.constraint(equalTo: self.notesCreationView.leadingAnchor, constant: leadingSpace),
            self.noteTitleField.topAnchor.constraint(equalTo: self.notesCreationView.topAnchor, constant: 10),
            self.noteTitleField.widthAnchor.constraint(equalToConstant: width * 0.92),
            self.noteTitleField.heightAnchor.constraint(equalToConstant: 40),
            
            self.viewSeparator.leadingAnchor.constraint(equalTo: self.notesCreationView.leadingAnchor, constant: leadingSpace),
            self.viewSeparator.topAnchor.constraint(equalTo: self.noteTitleField.bottomAnchor, constant: 2),
            self.viewSeparator.widthAnchor.constraint(equalToConstant: width * 0.92),
            self.viewSeparator.heightAnchor.constraint(equalToConstant: 1),

            self.noteContentView.leadingAnchor.constraint(equalTo: self.notesCreationView.leadingAnchor, constant: leadingSpace),
            self.noteContentView.topAnchor.constraint(equalTo: self.viewSeparator.bottomAnchor, constant: 2),
            self.noteContentView.widthAnchor.constraint(equalToConstant: width * 0.92),
            self.noteContentView.heightAnchor.constraint(equalToConstant: 110),
            
            self.listSelectionView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: leadingSpace),
            self.listSelectionView.topAnchor.constraint(equalTo: self.notesCreationView.bottomAnchor, constant: height * 0.03),
            self.listSelectionView.widthAnchor.constraint(equalToConstant: width),
            self.listSelectionView.heightAnchor.constraint(equalToConstant: height * 0.06),
            
            self.listImage.leadingAnchor.constraint(equalTo: self.listSelectionView.leadingAnchor, constant: leadingSpace),
            self.listImage.topAnchor.constraint(equalTo: self.listSelectionView.topAnchor, constant: 5),
            self.listImage.heightAnchor.constraint(equalToConstant: 40),
            self.listImage.widthAnchor.constraint(equalToConstant: 40),
            
            self.listLabel.leadingAnchor.constraint(equalTo: self.listImage.trailingAnchor, constant: leadingSpace),
            self.listLabel.topAnchor.constraint(equalTo: self.listSelectionView.topAnchor, constant: 16),
            
            self.listNameLabel.leadingAnchor.constraint(equalTo: self.listSelectionView.trailingAnchor, constant: -120),
            self.listNameLabel.topAnchor.constraint(equalTo: self.listSelectionView.topAnchor, constant: 16),
            
            self.rightArrowImage.leadingAnchor.constraint(equalTo: self.listNameLabel.trailingAnchor, constant: 6),
            self.rightArrowImage.topAnchor.constraint(equalTo: self.listSelectionView.topAnchor, constant: 16),
            self.rightArrowImage.heightAnchor.constraint(equalToConstant: 20),
            
        ])
    }
    
}

// Actions done on Tap.
extension AddNotesViewController
{
    
    @objc private func goToAvailableListPage()
    {
        let availableListViewController = ShowAvailableRemainderListsViewController()
        availableListViewController.delegate = self
        let navController = UINavigationController(rootViewController: availableListViewController)
        self.present(navController, animated: true)
    }
    
    private func setDataIfEditing()
    {
        guard let title = notes?.notesTitle,
              let content = notes?.notes else { return }
        
        self.noteTitleField.text = title
        self.noteContentView.text = content
    }
    
    @objc private func addRemainderAction()
    {
        guard let noteTitle = self.noteTitleField.text else { return }
        
        let content: String = self.noteContentView.text == "Notes" ? "" : self.noteContentView.text
        
        if let listID = self.listID
        {
            self.listLabel.text = self.listItem?.listName
            self.delegate?.receiveNotesData(noteTitle, content, listID, notes)
        } else
        {
            self.delegate?.receiveNotesData(noteTitle, content, "LISTS1", notes)
        }
        self.dismiss(animated: true)
        
    }
    
    @objc private func cancelAction()
    {
        if self.noteTitleField.text?.isEmpty == true && self.noteContentView.text == "Notes"
        {
            self.dismiss(animated: true)
            return
        }
        
        let stackView = ConfirmationViewController.stackView
        
        let discardChangesButton = ConfirmationViewController.discardChangesButton
        discardChangesButton.addAction(
            UIAction { action in
                UIView.animate(withDuration: 0.2, animations: {
                    stackView.removeFromSuperview()
                }) { _ in
                    self.dismiss(animated: true)
                }
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
    
    @objc private func showListAction()
    {
        UIView.animate(withDuration: 0.5, animations: {
            self.listSelectionView.backgroundColor = .systemGray5
            
        }) 
    }
    
}

extension AddNotesViewController: UITextFieldDelegate
{
    func textFieldDidChangeSelection(_ textField: UITextField)
    {
        if self.noteTitleField.text?.isEmpty == false
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = true
            self.noteTitleField.textColor = .black
        } else
        {
            self.navigationItem.rightBarButtonItem?.isEnabled = false
            self.noteTitleField.textColor = .black
        }
    }
}

extension AddNotesViewController: UITextViewDelegate
{
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if self.noteContentView.text == ""
        {
            self.noteContentView.text = "Notes"
            self.noteContentView.textColor = .lightGray
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if self.noteContentView.textColor == UIColor.lightGray
        {
            self.noteContentView.text = ""
            self.noteContentView.textColor = .black
        }
    }
}

extension AddNotesViewController: NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String, _ notes: Notes?) {
        
    }
    
    func receiveListData(_ listName: String, _ listObject: ListIem?) {
        self.listItem = listObject
        self.listNameLabel.text = listName
    }
    
}
