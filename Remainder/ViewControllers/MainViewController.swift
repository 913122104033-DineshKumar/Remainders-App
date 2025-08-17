import UIKit
import CoreData

class MainViewController: UIViewController
{
    private lazy var mainStackView: UIStackView = UIStackView()
    
    private lazy var remainderSearchBarController: UISearchController = UISearchController()
    private var remainderFetchController: NSFetchedResultsController<Lists>?
    
    private lazy var firstRowStackView: UIStackView = UIStackView()
    private lazy var secondRowStackView: UIStackView = UIStackView()
    private lazy var thirdRowStackView: UIStackView = UIStackView()
    
    private lazy var myListsStackView: UIStackView = UIStackView()
    
    private lazy var myListsLabel: UILabel = UILabel()
    
    private lazy var remainderListScrollView: UIScrollView = UIScrollView()
    private lazy var remainderListStackView: UIStackView = UIStackView()
    
    private lazy var bottomBottomView: UIView = UIView()
    private lazy var addRemainderButton: UIButton = UIButton()
    private lazy var addListButton: UIButton = UIButton()

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray6
        
        self.setNavBarButton()
        self.configureSearchBar()
        self.setUIs()
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
        
        self.mainStackView = ViewUtils.prepareStackView(
            isVertical: true,
            spacing: 10,
            isFrame: false,
            backgroundColor: .clear,
            cornerRadius: nil
        )
        self.view.addSubview(self.mainStackView)
        self.mainStackView.distribution = .fillEqually
        
        self.firstRowStackView = ViewUtils.prepareStackView(
            isVertical: false,
            spacing: 10,
            isFrame: false,
            backgroundColor: .clear,
            cornerRadius: nil
        )
        
        let firstView = self.generateDisplayView(
            viewName: "Today",
            count: "0",
            imageColor: .systemBlue,
            systemImageName: "calendar.badge.plus"
        )
        let secondView = self.generateDisplayView(
            viewName: "Scheduled",
            count: "0",
            imageColor: .systemRed,
            systemImageName: "calendar.circle.fill"
        )
        
        self.firstRowStackView.addArrangedSubview(firstView)
        self.firstRowStackView.addArrangedSubview(secondView)
        
        self.mainStackView.addArrangedSubview(self.firstRowStackView)
        
        self.secondRowStackView = ViewUtils.prepareStackView(
            isVertical: false,
            spacing: 10,
            isFrame: false,
            backgroundColor: .clear,
            cornerRadius: nil
        )
        
        let thirdView = self.generateDisplayView(
            viewName: "All",
            count: "0",
            imageColor: nil,
            systemImageName: "tray.circle.fill"
        )
        let fourthView = self.generateDisplayView(
            viewName: "Flagged",
            count: "0",
            imageColor: .systemYellow,
            systemImageName: "flag.circle.fill"
        )
        self.secondRowStackView.addArrangedSubview(thirdView)
        self.secondRowStackView.addArrangedSubview(fourthView)
        
        self.mainStackView.addArrangedSubview(self.secondRowStackView)
        
        self.thirdRowStackView = ViewUtils.prepareStackView(
            isVertical: false,
            spacing: 10,
            isFrame: false,
            backgroundColor: .clear,
            cornerRadius: nil
        )
        
        let fifthView = self.generateDisplayView(
            viewName: "Completed",
            count: "0",
            imageColor: .systemGreen,
            systemImageName: "checkmark.circle.fill"
        )
        self.thirdRowStackView.addArrangedSubview(fifthView)
        
        self.mainStackView.addArrangedSubview(self.thirdRowStackView)
        
        self.myListsLabel = ViewUtils.prepareTextLabelView(
            labelContent: "My Lists",
            fontSize: 22,
            color: .black,
            isBold: true,
            isFrame: false
        )
        
        self.view.addSubview(myListsLabel)
        
        self.remainderListScrollView = ViewUtils.prepareScrollView(
            edgeInsets: UIEdgeInsets(
                top: 10,
                left: 10,
                bottom: 10,
                right: 10
            ),
            isFrame: false
        )
        self.view.addSubview(self.remainderListScrollView)
        
        self.bottomBottomView = ViewUtils.prepareView(
            cornerRadius: nil,
            backgroundColor: .clear,
            isFrame: false
        )
        self.view.addSubview(self.bottomBottomView)
        
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
        
        self.bottomBottomView.addSubview(self.addRemainderButton)
        
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
        
        self.bottomBottomView.addSubview(self.addListButton)
        
        self.setConstraints()
        
    }
    
    private func setConstraints()
    {
        
        let height = self.view.bounds.height
        let width = self.view.bounds.width
        
        let safeLayout = self.view.safeAreaLayoutGuide
        
        NSLayoutConstraint.activate([
        
            self.mainStackView.topAnchor.constraint(equalTo: safeLayout.topAnchor, constant: height * 0.02),
            self.mainStackView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
            self.mainStackView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.mainStackView.heightAnchor.constraint(equalToConstant: height * 0.28),
            
            self.myListsLabel.topAnchor.constraint(equalTo: self.mainStackView.bottomAnchor, constant: height * 0.02),
            self.myListsLabel.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor, constant: width * 0.05),
        
            self.remainderListScrollView.topAnchor.constraint(equalTo: self.myListsLabel.bottomAnchor, constant: height * 0.02),
            self.remainderListScrollView.widthAnchor.constraint(equalToConstant: width * 0.9),
            self.remainderListScrollView.bottomAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -70),
            
            self.bottomBottomView.topAnchor.constraint(equalTo: safeLayout.bottomAnchor, constant: -60),
            self.bottomBottomView.heightAnchor.constraint(equalToConstant: 70),
            self.bottomBottomView.leadingAnchor.constraint(equalTo: safeLayout.leadingAnchor),
            self.bottomBottomView.widthAnchor.constraint(equalToConstant: width),
            
            self.addRemainderButton.leadingAnchor.constraint(equalTo: self.bottomBottomView.leadingAnchor, constant: width * 0.03),
            self.addRemainderButton.topAnchor.constraint(equalTo: self.bottomBottomView.topAnchor, constant: height * 0.02),
            
            self.addListButton.leadingAnchor.constraint(equalTo: self.bottomBottomView.trailingAnchor, constant: -(width * 0.2)),
            self.addListButton.topAnchor.constraint(equalTo: self.bottomBottomView.topAnchor, constant: height * 0.02),
            
        ])
    }
    
}

extension MainViewController
{
    
    private func generateNoteID() -> String
    {
        return ""
    }
    
    private func generateListID() -> String
    {
        return ""
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
        
    }
    
    func receiveListData(_ listName: String)
    {
        
    }
}

extension MainViewController: NSFetchedResultsControllerDelegate
{
    
}

