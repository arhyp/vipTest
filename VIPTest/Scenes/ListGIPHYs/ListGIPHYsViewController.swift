//
//  ListGIPHYsViewController.swift
//  VIPTest
//
//  Created by Архип on 10/22/17.
//  Copyright (c) 2017 KoshelGROUP. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

protocol ListGIPHYsDisplayLogic: class
{
  func displaySomething(viewModel: ListGIPHYs.FetchList.ViewModel)
}

class ListGIPHYsViewController: UICollectionViewController, ListGIPHYsDisplayLogic, UISearchBarDelegate
{
  var interactor: ListGIPHYsBusinessLogic?
  var router: (NSObjectProtocol & ListGIPHYsRoutingLogic & ListGIPHYsDataPassing)?
  var listGIPHIES: [ListGIPHYs.FetchList.ViewModel.DisplayedGIPHY] = []
  
  //search bar
    var searchBar: UISearchBar?
    var refreshControl:UIRefreshControl?
    var searchBarActive: Bool = false;
    // MARK: Object lifecycle
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
  {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }
  
  required init?(coder aDecoder: NSCoder)
  {
    super.init(coder: aDecoder)
    setup()
  }
  
  // MARK: Setup
  
  private func setup()
  {
    let viewController = self
    let interactor = ListGIPHYsInteractor()
    let presenter = ListGIPHYsPresenter()
    let router = ListGIPHYsRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }
    // MARK: Search
    func setupSearchBar()
    {
        if (self.searchBar == nil) {
            let searchBarBoundsY = (self.navigationController?.navigationBar.frame.size.height)! + UIApplication.shared.statusBarFrame.size.height
            self.searchBar = UISearchBar(frame: CGRect(x: 0, y: searchBarBoundsY, width: UIScreen.main.bounds.size.width, height: 44))
            self.searchBar?.searchBarStyle       = .minimal
            self.searchBar?.tintColor            = UIColor.lightGray
            self.searchBar?.barTintColor         = UIColor.white
            self.searchBar?.delegate             = self
            self.searchBar?.placeholder          = "search here"
            self.searchBar?.backgroundColor      = UIColor.white
        }
        
        if (self.searchBar?.isDescendant(of: self.view) == false) {
            self.view.addSubview(self.searchBar!)
            self.collectionView?.contentInset = UIEdgeInsetsMake(searchBar?.frame.size.height ?? 0, 0, 0, 0);
        }
    }
    // MARK: refreshControll
    func setupRefreshControll()
    {
        if (self.refreshControl == nil) {
            self.refreshControl = UIRefreshControl()
            self.refreshControl!.tintColor = UIColor.gray
            self.refreshControl!.addTarget(self, action: #selector(ListGIPHYsViewController.updateData), for: UIControlEvents.valueChanged)
        }
        if (self.refreshControl?.isDescendant(of: self.collectionView!) == false){
            self.collectionView?.addSubview(self.refreshControl!)
        }

    }
    func startRefreshControl(){
        if (!(self.refreshControl?.isRefreshing)!) {
            self.refreshControl?.beginRefreshing()
        }
    }
    func stopRefreshControl(){
        if (self.refreshControl!.isRefreshing) {
            self.refreshControl?.endRefreshing()
        }
    }
    
    //MARK: collection view
    func setupCollectionView(){
        let screenWidth = UIScreen.main.bounds.size.width
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenWidth/2, height: screenWidth/2)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView!.collectionViewLayout = layout
    }
  // MARK: Routing
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?)
  {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }
  
  // MARK: View lifecycle
  
  override func viewDidLoad()
  {
    super.viewDidLoad()
    fetchGIPHY()
  }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        setupSearchBar()
        setupRefreshControll()
        setupCollectionView()
    }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func fetchGIPHY()
  {
    let request = ListGIPHYs.FetchList.Request()
    interactor?.fetchGIPHY(request: request)
  }
  
  func displaySomething(viewModel: ListGIPHYs.FetchList.ViewModel)
  {
    //nameTextField.text = viewModel.name
    
    self.listGIPHIES = viewModel.displayesGiphies ?? []
    print ("list count \(self.listGIPHIES.count)")
    self.collectionView?.reloadData()
    stopRefreshControl()
  }
   
    
    
    // MARK: - Collection view data source
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.listGIPHIES.count;
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GIPHYCollectionViewCell.reuseIdentifier, for: indexPath) as! GIPHYCollectionViewCell;
        
        cell.displayedGiphy = self.listGIPHIES[indexPath.row]
        
        return cell;
    }
    
    
    // MARK: search delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        var searchText = searchBar.text ?? ""
        if (searchText.characters.count > 0) {
            makeSearch()
        }else{
            canceledSearch()
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        canceledSearch()
        self.view.endEditing(true)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        makeSearch()
        self.view.endEditing(true)
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(true, animated: true)
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.searchBar?.setShowsCancelButton(false, animated: true)
    }
    func canceledSearch(){
        self.searchBarActive = false;
        self.searchBar?.text = nil
        updateData()
    }
    func makeSearch(){
        updateData()
    }
    @objc func updateData(){
        var request = ListGIPHYs.FetchList.Request()
        request.searchString = self.searchBar?.text
        interactor?.fetchGIPHY(request: request)
        self.startRefreshControl()
    }

}
