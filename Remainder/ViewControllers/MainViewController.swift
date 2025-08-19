import UIKit
import CoreData

// Main Class
class MainViewController: UIViewController
{
    private var context: NSManagedObjectContext?
    
    private lazy var combinedCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(
            MenuViewCell.self,
            forCellWithReuseIdentifier: "MenuCell"
        )
        collectionView.register(
            ListCollectionViewCell.self,
            forCellWithReuseIdentifier: "ListCell"
        )
        collectionView.register(
            ReusableHeaderCell.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: "ReusableHeaderCell")
        collectionView.backgroundColor = .clear
        collectionView.alwaysBounceVertical = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        return collectionView
    }()
    
    private lazy var remainderSearchBarController: UISearchController = UISearchController()
    private var remainderFetchController: NSFetchedResultsController<ListIem>?
    
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
        self.setUIs()
        
        self.setRemainderList()
        
        DataUtils.taskCategories["All"]?.noOfTasks = self.getCountForAllTasks
        self.saveChanges()
        self.combinedCollectionView.resignFirstResponder()
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
        self.navigationItem.searchController = self.remainderSearchBarController
    }
    
    private func setUIs()
    {
        
        self.view.addSubview(self.combinedCollectionView)
        
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
            
            self.bottomButtonView.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -60),
            self.bottomButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.bottomButtonView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.bottomButtonView.widthAnchor.constraint(equalToConstant: width),
            
            self.combinedCollectionView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.0001),
            self.combinedCollectionView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.02),
            self.combinedCollectionView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -(width * 0.03)),
            self.combinedCollectionView.bottomAnchor.constraint(equalTo: self.bottomButtonView.topAnchor, constant: -(height * 0.001)),
            self.combinedCollectionView.widthAnchor.constraint(equalToConstant: width * 0.9),
            
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
            remainderList.listID = "LISTS0"
            remainderList.listName = "Remainders"
            remainderList.notesIDs = []
        }
        
        self.saveChanges()
        
        UserDefaults.standard.set(true, forKey: "HasRemainderSet")
    }
    
}
// Methods for MainViewController
extension MainViewController
{
    @objc private func goToEditPage()
    {
        let editViewController = EditPreferenceViewController()
        editViewController.delegate = self
        self.navigationController?.pushViewController(editViewController, animated: true)
    }
    
    @objc private func addRemainderAction()
    {
        let addNotesViewController = AddNotesViewController(notes: nil)
        addNotesViewController.delegate = self
        let navController = UINavigationController(rootViewController: addNotesViewController)
        
        self.present(navController, animated: true)
    }
    
    @objc private func addListAction()
    {
        let addListViewController = AddListViewController(listItem: nil)
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
                    return
                }
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
// Search Handling
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
        guard let searchQuery = self.remainderSearchBarController.searchBar.text else { return }
        
        if searchQuery.isEmpty
        {
            self.remainderFetchController?.fetchRequest.predicate = nil
            CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        } else
        {
            let searchPredicate = NSPredicate(format: "listName CONTAINS[cd] %@", searchQuery)
            self.remainderFetchController?.fetchRequest.predicate = searchPredicate
            CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        }
        self.combinedCollectionView.reloadData()
    
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
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return SectionType.allCases.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        guard let currentSection = SectionType(rawValue: section) else { return 0 }
        
        switch(currentSection)
        {
            case .taskSection:
                return DataUtils.taskCategories.filter{ key, value in value.canShow }.count
            case .remainderListSection:
                guard let sections = self.remainderFetchController?.sections else { return 0 }
                return sections[0].numberOfObjects
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
         guard let currentSection = SectionType(rawValue: indexPath.section) else { return UICollectionViewCell() }
         switch(currentSection)
         {
              case .taskSection:
             return self.getTaskViewCell(indexPath: indexPath)
              case .remainderListSection:
             return self.getRemainderViewCell(indexPath: indexPath)
         }    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        guard let currentSection = SectionType(rawValue: indexPath.section) else { return CGSize.zero }
         switch(currentSection)
         {
              case .taskSection:
                  return CGSize(width: 170, height: 80)
              case .remainderListSection:
                  return CGSize(width: self.view.bounds.width * 0.9, height: 50)
         }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.combinedCollectionView.deselectItem(at: indexPath, animated: true)
        
        guard let currentSection = SectionType(rawValue: indexPath.section) else { return }
        switch(currentSection)
        {
        case .remainderListSection:
            guard let list = self.remainderFetchController?.fetchedObjects?[indexPath.row],
                  let name = list.listName,
                  let ID = list.listID,
                  let notesIDs = list.notesIDs
            else { return }
            
            let showListViewController = ShowNotesOfListViewController(
                listID: ID,
                listName: name,
                notesIDs: notesIDs
            )
            showListViewController.delegate = self
            self.navigationController?.pushViewController(showListViewController, animated: true)
            
        case .taskSection:
            break
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        guard let currentSection = SectionType(rawValue: section) else { return 0 }
        
        switch(currentSection)
        {
        case .taskSection:
            return 10
        case .remainderListSection:
            return 10
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView
    {
        guard let header = self.combinedCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ReusableHeaderCell", for: indexPath) as? ReusableHeaderCell else { return UICollectionReusableView() }
        
        header.configure()
        
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        guard let section = SectionType(rawValue: section) else { return CGSize.zero }
        
        switch(section)
        {
        case .taskSection:
            return CGSize.zero
        case .remainderListSection:
            return CGSize(width: 30, height: 20)
        }
    }
    
    private func getTaskViewCell(indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = self.combinedCollectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: indexPath) as? MenuViewCell else { return UICollectionViewCell() }
        
        let keys = Array(DataUtils.taskCategories.filter{ key, value in value.canShow }.keys)
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
    
    private func getRemainderViewCell(indexPath: IndexPath) -> UICollectionViewCell
    {
        guard let cell = self.combinedCollectionView.dequeueReusableCell(withReuseIdentifier: "ListCell", for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell() }
        
        guard let list = self.remainderFetchController?.fetchedObjects?[indexPath.row],
              let name = list.listName
            else { return cell }
        
        let noOfTaks = list.notesIDs?.count ?? 0
        
        cell.configure(title: name, noOfTasks: String(noOfTaks))
        
        cell.setListPageUI()
        
        return cell
    }
    
    private func configureCollectionView()
    {
        self.combinedCollectionView.delegate = self
        self.combinedCollectionView.dataSource = self
    }
    
}

// Delegate Handling
extension MainViewController: NoteDelegate
{
    func receiveNotesData(_ noteTitle: String, _ noteContent: String, _ listID: String, _ notes: Notes?)
    {
        guard let context = self.context else { return }
        
        CoreModelHandler.saveChanges(context: context) {
            let notes = Notes(context: context)
            let noteID = DataUtils.generateNoteID()
            notes.notesID = noteID
            notes.notesTitle = noteTitle
            notes.notes = noteContent
            notes.listID = listID
            self.addNotesToList(notesID: noteID, listID: listID)
        }
        
        self.saveChanges()
    }
    
    func receiveListData(_ listName: String, _ listObject: ListIem?)
    {
        guard let context = self.context else { return }
        
        CoreModelHandler.saveChanges(context: context) {
            let listItem = ListIem(context: context)
            listItem.listID = DataUtils.generateListID()
            listItem.listName = listName
            listItem.notesIDs = []
        }
        
        self.saveChanges()
    }
    
    func saveChanges()
    {
        CoreModelHandler.fetchAllData(fetchController: self.remainderFetchController)
        self.combinedCollectionView.reloadData()
    }
}

