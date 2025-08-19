import UIKit
import CoreData

class ShowNotesOfListViewController: UIViewController
{
    weak var delegate: NoteDelegate?
    
    private var listID: String
    private var listName: String
    private var notesIDs: [String]
    
    private var notesFetchController: NSFetchedResultsController<Notes>?
    private lazy var notesTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            NoteViewCell.self,
            forCellReuseIdentifier: "NotesCell"
        )
        tableView.rowHeight = 80
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        return tableView
    }()
    
    private lazy var addRemainderButton: UIButton = UIButton()
    
    init(listID: String, listName: String, notesIDs: [String])
    {
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
        self.title = listName
        
        self.updateFetchController()
        self.configureTableView()
        self.setNavBar()
        self.setUIs()
        self.notesTableView.reloadData()
    }
    
    private func setNavBar()
    {
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setUIs()
    {
        self.view.addSubview(self.notesTableView)
        
        self.addRemainderButton = ViewUtils.prepareButtonView(
            buttonTitle: "Add Remainder",
            backgroundColor: .clear,
            textColor: .systemBlue,
            fontSize: 16,
            cornerRadius: nil,
            isBold: true,
            isCustomButton: true,
            isFrame: false
        )
        let configurations = UIImage.SymbolConfiguration(pointSize: 22, weight: .bold, scale: .large)
        let addButtonImage = UIImage(systemName: "plus.circle.fill", withConfiguration: configurations)
        self.addRemainderButton.setImage(addButtonImage, for: .normal)
        self.addRemainderButton.addTarget(self, action: #selector(addRemainderAction), for: .touchUpInside)
        
        self.view.addSubview(self.addRemainderButton)
        
        self.setConstraints()
    }
    
    private func setConstraints()
    {
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            self.notesTableView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.01),
            self.notesTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.03),
            self.notesTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.notesTableView.heightAnchor.constraint(equalTo: safeLayout.heightAnchor),
            
            self.addRemainderButton.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -(height * 0.06)),
            self.addRemainderButton.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
        
        ])
    }
    
    @objc private func addRemainderAction()
    {
        let addNotesViewController = AddNotesViewController(notes: nil, listID: listID, listName: listName, notesIDs: notesIDs)
        addNotesViewController.delegate = self
        let navController = UINavigationController(rootViewController: addNotesViewController)
        
        self.present(navController, animated: true)
    }
}

extension ShowNotesOfListViewController: UITableViewDelegate,
UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.notesFetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = NoteViewCell()
        
        guard let title = self.notesFetchController?.object(at: indexPath).notesTitle else { return cell }
        
        cell.configure(
            title: title,
            content: self.notesFetchController?.object(at: indexPath).notes ?? ""
        )
        
        cell.finishButton.addAction(UIAction{ _ in
            cell.finishButton.isChecked = !cell.finishButton.isChecked
            
            if cell.finishButton.isChecked
            {
                cell.finishButton.tintColor = .systemGreen
            }
            
        }, for: .touchUpInside)
        
        cell.editButton.addAction(UIAction{_ in
            let addRemainderViewController = AddNotesViewController(notes: self.notesFetchController?.object(at: indexPath))
            addRemainderViewController.delegate = self
            let navController = UINavigationController(rootViewController: addRemainderViewController)
            
            self.present(navController, animated: true)
            
        }, for: .touchUpInside)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.notesTableView.deselectRow(at: indexPath, animated: true)
    }
    
    private func configureTableView()
    {
        self.notesTableView.delegate = self
        self.notesTableView.dataSource = self
    }
}

extension ShowNotesOfListViewController: NSFetchedResultsControllerDelegate
{
    private func updateFetchController()
    {
        
        guard let content = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        if self.notesFetchController == nil
        {
            let request = Notes.fetchRequest()
            let sort = NSSortDescriptor(key: "notesID", ascending: true)
            request.sortDescriptors = [sort]
            self.notesFetchController = NSFetchedResultsController(
                fetchRequest: request,
                managedObjectContext: content, sectionNameKeyPath: nil,
                cacheName: nil
            )
        }
        
        let filteredDataPredicate = NSPredicate(format: "listID == %@", listID)
        self.notesFetchController?.fetchRequest.predicate = filteredDataPredicate
        CoreModelHandler.fetchAllData(fetchController: self.notesFetchController)
        self.notesTableView.reloadData()
    }
    
    private func handleNotesChange(oldListID: String, currentListID: String, notesID: String)
    {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        let request = ListIem.fetchRequest()
        let sort = NSSortDescriptor(key: "listID", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        let fetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
        CoreModelHandler.fetchAllData(fetchController: fetchController)
        
        guard let objects = fetchController.fetchedObjects
        else {
            return
        }
        
        for list in objects
        {
            if list.listID == oldListID
            {
                
                guard let index = list.notesIDs?.firstIndex(where: { $0 == notesID }) else { return }
                list.notesIDs?.remove(at: index)
                
                print()
            } else if list.listID == currentListID
            {
                list.notesIDs?.append(notesID)
            }
        }
        
        CoreModelHandler.saveChanges(context: context){}
        
    }
}

extension ShowNotesOfListViewController: NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String, _ notes: Notes?)
    {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        if notes != nil{
            CoreModelHandler.saveChanges(context: context) {
                
                guard let notes = notes,
                      let notesID = notes.notesID,
                      let previousListID = notes.listID
                else { return }
                
                if listID != previousListID
                {
                    self.handleNotesChange(
                        oldListID: previousListID,
                        currentListID: listID,
                        notesID: notesID
                    )
                }
                
                notes.notesTitle = noteTitle
                notes.notes = noteContent
                notes.listID = listID
            }
        } else
        {
            CoreModelHandler.saveChanges(context: context) {
                let notes = Notes(context: context)
                let noteID = DataUtils.generateNoteID()
                notes.notesID = noteID
                notes.notesTitle = noteTitle
                notes.notes = noteContent
                notes.listID = listID
                let fetchController = CoreModelHandler.configureFetchController(
                    request: ListIem.fetchRequest(),
                    context: context
                )
                CoreModelHandler.addNotesToList(notesID: noteID, listID: listID, fetchController: fetchController)
            }
        }
        
        self.delegate?.saveChanges?()
        self.updateFetchController()
    }
    
    func receiveListData(_ listName: String, _ listObject: ListIem?) {
        
    }
    
    
}
