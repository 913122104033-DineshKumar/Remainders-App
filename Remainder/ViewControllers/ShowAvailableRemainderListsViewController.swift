import UIKit
import CoreData

class ShowAvailableRemainderListsViewController: UIViewController
{
    
    weak var delegate: NoteDelegate?
    
    private lazy var availableListTableView: UITableView = {
       let tableView = UITableView()
        
        tableView.register(
            AvailableListViewCell.self,
            forCellReuseIdentifier: "AvailableListViewCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .clear
        tableView.rowHeight = 50
        
        return tableView
    }()
    private var availableListFetchController: NSFetchedResultsController<ListIem>?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "List"
        self.view.backgroundColor = .systemGray6
        
        self.configureFetchController()
        self.configureTableView()
        
        self.setUIs()
        
        CoreModelHandler.fetchAllData(fetchController: self.availableListFetchController)
        self.availableListTableView.reloadData()
        
    }
    
    private func setUIs()
    {
        self.view.addSubview(self.availableListTableView)
        
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            self.availableListTableView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.05),
            self.availableListTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            self.availableListTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.availableListTableView.trailingAnchor.constraint(equalTo: safeLayout.trailingAnchor, constant: -(width * 0.05)),
            self.availableListTableView.heightAnchor.constraint(equalTo: safeLayout.heightAnchor),
        
        ])
        
    }
    
    private func onCompletion(listItem: ListIem)
    {
        
        guard let listName = listItem.listName else { return }
        
        self.delegate?.receiveListData(listName, listItem)
        self.dismiss(animated: true)
    }
    
}

extension ShowAvailableRemainderListsViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        self.availableListFetchController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = AvailableListViewCell()
        
        guard let listName = self.availableListFetchController?.object(at: indexPath).listName else { return cell }
        
        cell.configure(listName: listName)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        
        guard let fetchedObjects = self.availableListFetchController?.fetchedObjects else { return }
        
        for (index, _) in fetchedObjects.enumerated()
        {
            if index != indexPath.row
            {
                let anotherIndex = IndexPath(row: index, section: 0)
                guard let cell = self.availableListTableView.cellForRow(at: anotherIndex) as? AvailableListViewCell else { return }
                
                cell.tickMark.isHidden = true
            }
        }
        
        guard let cell = self.availableListTableView.cellForRow(at: indexPath) as? AvailableListViewCell else { return }
        
        cell.tickMark.isHidden = false
        
        self.availableListTableView.deselectRow(at: indexPath, animated: true)
        
        self.onCompletion(listItem: fetchedObjects[indexPath.row])
    }
    
    private func configureTableView()
    {
        self.availableListTableView.delegate = self
        self.availableListTableView.dataSource = self
    }
    
}

extension ShowAvailableRemainderListsViewController: NSFetchedResultsControllerDelegate
{
    private func configureFetchController()
    {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else { return }
        
        let request = ListIem.fetchRequest()
        let sort = NSSortDescriptor(key: "listID", ascending: true)
        request.sortDescriptors = [sort]
        request.fetchBatchSize = 10
        
        self.availableListFetchController = NSFetchedResultsController(
            fetchRequest: request,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }
}
