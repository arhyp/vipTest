//
//  ShowGIPHYViewController.swift
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
import SDWebImage

protocol ShowGIPHYDisplayLogic: class
{
  func displaySomething(viewModel: ShowGIPHY.Something.ViewModel)
}

class ShowGIPHYViewController: UIViewController, ShowGIPHYDisplayLogic
{
  var interactor: ShowGIPHYBusinessLogic?
  var router: (NSObjectProtocol & ShowGIPHYRoutingLogic & ShowGIPHYDataPassing)?

    @IBOutlet weak var giphyLabel: UILabel!
    @IBOutlet weak var giphyImageView: FLAnimatedImageView!
    
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
    let interactor = ShowGIPHYInteractor()
    let presenter = ShowGIPHYPresenter()
    let router = ShowGIPHYRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
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
    doSomething()
  }
  
  // MARK: Do something
  
  //@IBOutlet weak var nameTextField: UITextField!
  
  func doSomething()
  {
    let request = ShowGIPHY.Something.Request()
    interactor?.doSomething(request: request)
  }
  
  func displaySomething(viewModel: ShowGIPHY.Something.ViewModel)
  {
    self.giphyLabel.text = viewModel.displayedGIPHY.title
    self.giphyImageView.sd_setShowActivityIndicatorView(true)
    giphyImageView.sd_setIndicatorStyle(.white)
    self.giphyImageView.sd_setImage(with: NSURL(string: viewModel.displayedGIPHY.url)! as URL, placeholderImage: nil, options: [])
  }
}
