import UIKit
import CoreData

class EditPreferenceViewController: UIViewController
{
    private lazy var remainderSearchController: UISearchController = UISearchController()
    private var remainderFetchController: NSFetchedResultsController<Notes>?
    private lazy var myListsLabel: UILabel = UILabel()
    private lazy var bottomButtonView: UIView = UIView()
    private lazy var addGroupButton: UIButton = UIButton()
    private lazy var addListButton: UIButton = UIButton()
    
    private lazy var displayItemsTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            DisplayViewCell.self,
            forCellReuseIdentifier: "DisplayViewCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        
        return tableView
    }()
    private lazy var remainderListTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.register(
            ListCellView.self,
            forCellReuseIdentifier: "ListCell"
        )
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 50
        
        return tableView
    }()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.configureSearchBar()
        self.setNavBar()
        self.setUIs()
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
    }
    
    private func setUIs()
    {
        self.view.addSubview(self.displayItemsTableView)
        
        self.myListsLabel = ViewUtils.prepareTextLabelView(
            labelContent: "My Lists",
            fontSize: 22,
            color: .black,
            isBold: true,
            isFrame: false
        )
        self.view.addSubview(self.myListsLabel)
        
        self.view.addSubview(self.remainderListTableView)
        
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
            buttonTitle: "Add Remainder",
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
            
            self.displayItemsTableView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.02),
            self.displayItemsTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.02),
            self.displayItemsTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            
            self.myListsLabel.topAnchor.constraint(equalTo: self.displayItemsTableView.bottomAnchor, constant: height * 0.01),
            self.myListsLabel.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.03),
            
            self.remainderListTableView.topAnchor.constraint(equalTo: self.myListsLabel.bottomAnchor, constant: height * 0.01),
            self.remainderListTableView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.02),
            self.remainderListTableView.widthAnchor.constraint(equalToConstant: width * 0.9),
            
            self.bottomButtonView.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -60),
            self.bottomButtonView.heightAnchor.constraint(equalToConstant: 70),
            self.bottomButtonView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.bottomButtonView.widthAnchor.constraint(equalToConstant: width),
            
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
        
    }
    
    @objc private func doneAction()
    {
        
    }
}

extension EditPreferenceViewController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        return UITableViewCell()
    }
    
    private func configureTableView()
    {
        self.displayItemsTableView.delegate = self
        self.displayItemsTableView.dataSource = self
        self.remainderListTableView.delegate = self
        self.remainderListTableView.dataSource = self
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
        
    }
}

extension EditPreferenceViewController: NSFetchedResultsControllerDelegate
{
    
}
