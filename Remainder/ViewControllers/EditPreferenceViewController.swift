import UIKit
import CoreData

class EditPreferenceViewController: UIViewController
{
    weak var delegate: NoteDelegate?
    
    private lazy var remainderSearchController: UISearchController = UISearchController()
    private var remainderListFetchController: NSFetchedResultsController<ListIem>?
    private lazy var bottomButtonView: UIView = UIView()
    private lazy var addGroupButton: UIButton = UIButton()
    private lazy var addListButton: UIButton = UIButton()
    
    private lazy var editItemTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            DisplayViewCell.self,
            forCellReuseIdentifier: "DisplayCell"
        )
        tableView.register(
            ListCellView.self,
            forCellReuseIdentifier: "ListCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.layer.cornerRadius = 10
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.configureFetchController()
        self.configureSearchBar()
        self.configureTableView()
        self.setUIs()
        self.setNavBar()
        
        CoreModelHandler.fetchAllData(fetchController: self.remainderListFetchController)
        self.editItemTableView.reloadData()
    }
    
    private func setNavBar()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Done",
            style: .plain,
            target: self,
            action: #selector(doneAction)
        )
        self.navigationItem.searchController = self.remainderSearchController
        self.navigationItem.hidesBackButton = true
    }
    
    private func setUIs()
    {
        self.view.addSubview(self.editItemTableView)
        
        self.setBottonView()
        
        self.setConstraints()
    }
    
    private func setBottonView()
    {
        self.bottomButtonView = ViewUtils.prepareView(
            cornerRadius: nil,
            backgroundColor: .clear,
            isFrame: false
        )
        
        self.view.addSubview(self.bottomButtonView)
        
        self.addGroupButton = ViewUtils.prepareButtonView(
            buttonTitle: "Add Group",
            backgroundColor: .clear,
            textColor: .systemBlue,
            fontSize: 16,
            cornerRadius: nil,
            isBold: true,
            isCustomButton: true,
            isFrame: false
        )
        self.addGroupButton.addTarget(self, action: #selector(addGroupAction), for: .touchUpInside)
        
        self.bottomButtonView.addSubview(self.addGroupButton)
        
        self.addListButton = ViewUtils.prepareButtonView(
            buttonTitle: "Add List",
            backgroundColor: .clear,
            textColor: .systemBlue,
            fontSize: 16,
            cornerRadius: nil,
            isBold: false,
            isCustomButton: false,
            isFrame: false
        )
        self.addListButton.addTarget(self, action: #selector(addListAction), for: .touchUpInside)
        
        self.bottomButtonView.addSubview(self.addListButton)
    }
    
    private func setConstraints()
    {
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            self.bottomButtonView.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -60),
            self.bottomButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.bottomButtonView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.bottomButtonView.widthAnchor.constraint(equalToConstant: width),
            
            self.editItemTableView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.001),
            self.editItemTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            self.editItemTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.editItemTableView.bottomAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: -(height * 0.02)),
            
            self.addGroupButton.leadingAnchor.constraint(equalTo: self.bottomButtonView.leadingAnchor, constant: width * 0.03),
            self.addGroupButton.topAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: height * 0.02),
            
            self.addListButton.leadingAnchor.constraint(equalTo: self.bottomButtonView.trailingAnchor, constant: -(width * 0.2)),
            self.addListButton.topAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: height * 0.02),
            
        ])
        
    }
    
}

extension EditPreferenceViewController
{
    
    @objc private func addGroupAction()
    {
        
    }
    
    @objc private func addListAction()
    {
        let addListViewController = AddListViewController(listItem: nil)
        addListViewController.delegate = self
        let navController = UINavigationController(rootViewController: addListViewController)
        
        self.present(navController, animated: true)
    }
    
    @objc private func doneAction()
    {
        self.delegate?.saveChanges?()
        self.navigationController?.popViewController(animated: true)
    }
}

extension EditPreferenceViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return SectionType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard let currentSection = SectionType(rawValue: section) else { return 0 }
        switch(currentSection)
        {
        case .taskSection:
            return DataUtils.taskCategories.filter{ key, value in value.canShow }.count
        case .remainderListSection:
            
            guard let sections = self.remainderListFetchController?.sections else {
                return 0
            }
            
            let sectionInfo = sections[0]
            return sectionInfo.numberOfObjects
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let currentSection = SectionType(rawValue: indexPath.section) else { return UITableViewCell() }
        switch(currentSection)
        {
        case .taskSection:
            return self.createDisplayCell(indexPath: indexPath)
        case .remainderListSection:
            return self.createListCell(indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let currentSection = SectionType(rawValue: section) else { return nil }
        
        switch(currentSection)
        {
        case .taskSection:
            return nil
        case .remainderListSection:
            return "My Lists"
        }
        
    }
    
    private func configureTableView()
    {
        self.editItemTableView.delegate = self
        self.editItemTableView.dataSource = self
    }
    
    private func createListCell(indexPath: IndexPath) -> UITableViewCell
    {
        let cell = ListCellView()
        
        guard let list = self.remainderListFetchController?.fetchedObjects?[indexPath.row]
        else { return cell }
        
        guard let name = list.listName else { return cell }
        
        let noOfTaks = list.notesIDs?.count ?? 0
        
        cell.configure(title: name, noOfTasks: String(noOfTaks))
        
        cell.deleteIcon.addAction(UIAction { _ in
            guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
            else { return }
            
            CoreModelHandler.saveChanges(context: context) {
                list.notesIDs?.removeAll()
                context.delete(list)
            }
            self.saveChanges()
            
            self.delegate?.saveChanges?()
            
        }, for: .touchUpInside)
        
        cell.editButton.addAction(
            UIAction { _ in
                let addListviewController = AddListViewController(
                    listItem: list
                )
                addListviewController.delegate = self
                let navController = UINavigationController(rootViewController: addListviewController)
                self.present(navController, animated: true)
            },
            for: .touchUpInside)
        
        cell.setEditPageUI()
        
        return cell
    }
    
    private func createDisplayCell(indexPath: IndexPath) -> UITableViewCell
    {
        let cell = DisplayViewCell()
        
        let keys = Array(DataUtils.taskCategories.keys)
        let key = keys[indexPath.row]
        
        guard let category = DataUtils.taskCategories[key] else { return cell }
        
        cell.configure(
            iconName: category.iconName,
            iconColor: category.iconColor,
            title: category.title
        )
        
        cell.checkBox.isChecked = category.canShow
        
        cell.checkBox.addAction(UIAction{_ in
            cell.checkBox.isChecked = !cell.checkBox.isChecked
            
            if cell.checkBox.isChecked
            {
                DataUtils.taskCategories[key]?.canShow = true
                cell.checkBox.tintColor = .systemBlue
            } else
            {
                DataUtils.taskCategories[key]?.canShow = false
            }
            
        }, for: .touchUpInside)
        
        return cell
    }
    
}

extension EditPreferenceViewController: UISearchControllerDelegate, UISearchResultsUpdating
{
    
    private func configureSearchBar()
    {
        self.remainderSearchController = UISearchController(searchResultsController: nil)
        self.remainderSearchController.searchResultsUpdater = self
        self.remainderSearchController.delegate = self
        self.remainderSearchController.searchBar.placeholder = "Search"
        self.remainderSearchController.searchBar.sizeToFit()
        self.remainderSearchController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        guard let searchQuery = self.remainderSearchController.searchBar.text else { return }
        
        if searchQuery.isEmpty
        {
            self.remainderListFetchController?.fetchRequest.predicate = nil
            CoreModelHandler.fetchAllData(fetchController: self.remainderListFetchController)
        } else {
            let searchPredicate = NSPredicate(format: "listName CONTAINS[cd] %@", searchQuery)
            self.remainderListFetchController?.fetchRequest.predicate = searchPredicate
            CoreModelHandler.fetchAllData(fetchController: self.remainderListFetchController)
        }
        self.editItemTableView.reloadData()
        
    }
}

extension EditPreferenceViewController: NSFetchedResultsControllerDelegate
{
    private func configureFetchController()
    {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        let request = ListIem.fetchRequest()
        let sort = NSSortDescriptor(key: "listID", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        self.remainderListFetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}

extension EditPreferenceViewController: NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String, _ notes: Notes?)
    {
        
    }
    
    func receiveListData(_ listName: String, _ listObject: ListIem?)
    {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        if listObject == nil
        {
            self.delegate?.receiveListData(listName, listObject)
        } else
        {
            CoreModelHandler.saveChanges(context: context) {
                listObject?.listName = listName
            }
        }
        
        self.saveChanges()
        
    }
    
    func saveChanges()
    {
        CoreModelHandler.fetchAllData(fetchController: self.remainderListFetchController)
        self.editItemTableView.reloadData()
        
        self.delegate?.saveChanges?()
    }
    
    
}
