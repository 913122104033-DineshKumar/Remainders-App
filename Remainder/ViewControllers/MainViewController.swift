import UIKit
import CoreData

class MainViewController: UIViewController
{
    private var context: NSManagedObjectContext?
    
    private var noteID: Int = 0
    private var listID: Int = 1
    
    private lazy var mainStackView: UIStackView = UIStackView()
    private lazy var tasksCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.register(
            MenuViewCell.self,
            forCellWithReuseIdentifier: "MenuCell"
        )
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var remainderSearchBarController: UISearchController = UISearchController()
    private var remainderFetchController: NSFetchedResultsController<ListIem>?
    
    private lazy var firstRowStackView: UIStackView = UIStackView()
    private lazy var secondRowStackView: UIStackView = UIStackView()
    private lazy var thirdRowStackView: UIStackView = UIStackView()
    
    private lazy var myListsStackView: UIStackView = UIStackView()
    
    private lazy var myListsLabel: UILabel = UILabel()
    
    private var remainderTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            ListCellView.self,
            forCellReuseIdentifier: "ListCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        tableView.layer.cornerRadius = 10
        
        return tableView
    }()
    
    private lazy var bottomButtonView: UIView = UIView()
    private lazy var addRemainderButton: UIButton = UIButton()
    private lazy var addListButton: UIButton = UIButton()
    
    init()
    {
        super.init(nibName: nil, bundle: nil)
        
        guard let delegate = (UIApplication.shared.delegate as? AppDelegate) else { return }
        self.context = delegate.persistentContainer.viewContext
    }
    
    required init?(coder: NSCoder)
    {
        fatalError()
    }

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.setNavBarButton()
        self.configureFetchController()
        self.configureSearchBar()
        self.configureCollectionView()
        self.configureListTableView()
        self.setUIs()
        
        self.setRemainderList()
        
        CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        self.remainderTableView.reloadData()
        
        DataUtils.taskCategories["All"]?.noOfTasks = self.getCountForAllTasks
        self.tasksCollectionView.reloadData()
    }
    
    private func setNavBarButton()
    {
        let image = UIImage(systemName: "ellipsis.circle")
        image?.withTintColor(.systemBlue, renderingMode: .alwaysTemplate)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(goToEditPage)
        )
    }
    
    private func setUIs()
    {
        self.navigationItem.searchController = self.remainderSearchBarController
        
        self.view.addSubview(self.tasksCollectionView)
        
        self.myListsLabel = ViewUtils.prepareTextLabelView(
            labelContent: "My Lists",
            fontSize: 22,
            color: .black,
            isBold: true,
            isFrame: false
        )
        
        self.view.addSubview(myListsLabel)
        
        self.view.addSubview(self.remainderTableView)
        
        self.bottomButtonView = ViewUtils.prepareView(
            cornerRadius: nil,
            backgroundColor: .clear,
            isFrame: false
        )
        self.view.addSubview(self.bottomButtonView)
        
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
        
        self.bottomButtonView.addSubview(self.addRemainderButton)
        
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
        
        self.setConstraints()
        
    }
    
    private func setConstraints()
    {
        
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
            
            self.tasksCollectionView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.02),
            self.tasksCollectionView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            self.tasksCollectionView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.tasksCollectionView.heightAnchor.constraint(equalToConstant: height * 0.32),
            
            self.myListsLabel.topAnchor.constraint(equalTo: self.tasksCollectionView.bottomAnchor, constant: height * 0.02),
            self.myListsLabel.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            
            self.bottomButtonView.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -60),
            self.bottomButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.bottomButtonView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.bottomButtonView.widthAnchor.constraint(equalToConstant: width),
            
            self.remainderTableView.topAnchor.constraint(equalTo: self.myListsLabel.bottomAnchor, constant: height * 0.02),
            self.remainderTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            self.remainderTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.remainderTableView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -(width * 0.02)),
            self.remainderTableView.bottomAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: -10),
            
            self.addRemainderButton.leadingAnchor.constraint(equalTo: self.bottomButtonView.leadingAnchor, constant: width * 0.03),
            self.addRemainderButton.topAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: height * 0.02),
            
            self.addListButton.leadingAnchor.constraint(equalTo: self.bottomButtonView.trailingAnchor, constant: -(width * 0.2)),
            self.addListButton.topAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: height * 0.02),
            
        ])
    }
    
    private func setRemainderList()
    {
        
        if UserDefaults.standard.bool(forKey: "HasRemainderSet")
        {
            return
        }
        
        guard let context = self.context else { return }
        
        CoreModelHandler.saveChanges(context: context){
            let remainderList = ListIem(context: context)
            remainderList.listID = "LISTS1"
            remainderList.listName = "Remainders"
            remainderList.notesIDs = []
        }
        
        CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        
        UserDefaults.standard.set(true, forKey: "HasRemainderSet")
    }
    
}

extension MainViewController
{
    
    private func generateNoteID() -> String
    {
        self.noteID += 1
        return "NOTES" + String(self.noteID)
    }
    
    private func generateListID() -> String
    {
        self.listID += 1
        return "LISTS" + String(self.listID)
    }
    
    @objc private func goToEditPage()
    {
        self.navigationController?.pushViewController(EditPreferenceViewController(), animated: true)
    }
    
    @objc private func addRemainderAction()
    {
        let addNotesViewController = AddNotesViewController()
        addNotesViewController.delegate = self
        let navController = UINavigationController(rootViewController: addNotesViewController)
        
        self.present(navController, animated: true)
    }
    
    @objc private func addListAction()
    {
        let addListViewController = AddListViewController()
        addListViewController.delegate = self
        let navController = UINavigationController(rootViewController: addListViewController)
        
        self.present(navController, animated: true)
    }
    
    private func generateDisplayView(
        viewName text: String,
        count countText: String,
        imageColor imgColor: UIColor?,
        systemImageName imageName: String
    ) -> UIView
    {
        let view = ViewUtils.prepareView(
            cornerRadius: 10,
            backgroundColor: .white,
            isFrame: false
        )
        
        let imageView = ViewUtils.prepareImageView(
            image: UIImage(systemName: imageName),
            cornerRadius: 8,
            color: imgColor,
            isFrame: false
        )
        
        let countLabel = ViewUtils.prepareTextLabelView(
            labelContent: countText,
            fontSize: 20,
            color: .black,
            isBold: true,
            isFrame: false
        )
        
        let viewLabel = ViewUtils.prepareTextLabelView(
            labelContent: text,
            fontSize: 16,
            color: .systemGray4,
            isBold: false,
            isFrame: false
        )
        
        view.addSubview(imageView)
        view.addSubview(countLabel)
        view.addSubview(viewLabel)
        
        NSLayoutConstraint.activate([
            
            imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalToConstant: 30),
            imageView.heightAnchor.constraint(equalToConstant: 30),
            
            countLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            countLabel.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            viewLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            viewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            
        ])
        
        return view
    }
    
    private func addNotesToList(notesID: String, listID: String)
    {
        if let items = remainderFetchController?.fetchedObjects
        {
            for item in items
            {
                if item.listID == listID
                {
                    item.notesIDs?.append(notesID)
                }
                return
            }
        }
    }
    
    private func getCountForAllTasks() -> Int
    {
        var count = 0
        if let items = self.remainderFetchController?.fetchedObjects
        {
            for item in items
            {
                count += item.notesIDs?.count ?? 0
            }
        }
        return count
    }
}

extension MainViewController: UISearchControllerDelegate, UISearchResultsUpdating
{
    
    private func configureSearchBar()
    {
        self.remainderSearchBarController = UISearchController(searchResultsController: nil)
        self.remainderSearchBarController.searchResultsUpdater = self
        self.remainderSearchBarController.delegate = self
        self.remainderSearchBarController.searchBar.placeholder = "Search"
        self.remainderSearchBarController.searchBar.sizeToFit()
        self.remainderSearchBarController.searchBar.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func updateSearchResults(for searchController: UISearchController)
    {
        
    }
}

extension MainViewController: NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String)
    {
        guard let context = self.context else { return }
        
        CoreModelHandler.saveChanges(context: context) {
            let notes = Notes(context: context)
            let noteID = self.generateNoteID()
            notes.notesID = noteID
            notes.noteTitle = noteTitle
            notes.notes = noteContent
            notes.listID = listID
            self.addNotesToList(notesID: noteID, listID: listID)
        }
        
        CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        
        self.remainderTableView.reloadData()
        self.tasksCollectionView.reloadData()
    }
    
    func receiveListData(_ listName: String)
    {
        guard let context = self.context else { return }
        
        CoreModelHandler.saveChanges(context: context) {
            let listItem = ListIem(context: context)
            listItem.listID = self.generateListID()
            listItem.listName = listName
            listItem.notesIDs = []
        }
        CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        
        self.remainderTableView.reloadData()
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.remainderFetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = ListCellView()
        
        cell.listImage = ViewUtils.prepareImageView(
            image: UIImage(systemName: "list.bullet.circle.fill"),
            cornerRadius: 10,
            color: .systemBlue,
            isFrame: false
        )
        
        if let listName = self.remainderFetchController?.object(at: indexPath).listName
        {
            cell.listName = ViewUtils.prepareTextLabelView(
                labelContent: listName,
                fontSize: 16,
                color: .black,
                isBold: true,
                isFrame: false
            )
        }
        
        if let count = self.remainderFetchController?.object(at: indexPath).notesIDs?.count
        {
            cell.countLabel = ViewUtils.prepareTextLabelView(
                labelContent: String(count),
                fontSize: 20,
                color: .systemGray4,
                isBold: true,
                isFrame: false
            )
            
        }
        
        cell.setListPageUI()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        
        self.remainderTableView.deselectRow(at: indexPath, animated: true)
        
        return false
    }
    
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem]
    {
        let dragItem = UIDragItem(itemProvider: NSItemProvider())
        dragItem.localObject = self.remainderFetchController?.object(at: indexPath)
        
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath)
    {
        
    }
    
    private func configureListTableView()
    {
        self.remainderTableView.delegate = self
        self.remainderTableView.dataSource = self
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate
{
    private func configureFetchController()
    {
        guard let context = self.context else { return }
        
        let request = ListIem.fetchRequest()
        let sort = NSSortDescriptor(key: "listID", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        self.remainderFetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        
    }
}

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return DataUtils.taskCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuViewCell else { return UICollectionViewCell() }
        
        let keys = Array(DataUtils.taskCategories.keys)
        let key = keys[indexPath.row]
        
        guard let category = DataUtils.taskCategories[key] else { return cell }
        
        let noOfTasks = category.noOfTasks?() ?? 0
        
        cell.configure(
            title: category.title,
            noOfTasks: String(noOfTasks),
            iconName: category.iconName,
            iconColor: category.iconColor
        )
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        return CGSize(width: 160, height: 80)
    }
    
    private func configureCollectionView()
    {
        self.tasksCollectionView.dataSource = self
        self.tasksCollectionView.delegate = self
    }
    
}

