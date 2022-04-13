//
//  WALELandingViewController.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import UIKit

protocol WALELandingDisplayable: AnyObject {
    func displayAPOD(withViewModel: WALELandingViewModel)
    func displayLoader()
    func hideLoader()
    func displayAlert(withString: String)
}

final class WALELandingViewController: UITableViewController {
    
    private var interactor: WALELandingInteractable!
    private var viewModel: WALELandingViewModel?
    private lazy var activityLoader: UIActivityIndicatorView = {
        
        let spinner = UIActivityIndicatorView(style: .large)
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        spinner.hidesWhenStopped = true
        return spinner
    }()
    
    init(withConfigurator configurator: WALELandingConfiguratorProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.interactor = configurator.setup(withController: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()
        tableViewSetup()
        interactor.processViewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return (viewModel != nil) ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let viewModel = viewModel {
            return (viewModel.apod.imageData != nil) ? 2 : 1
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WALELandingTableCell", for: indexPath) as! WALELandingTableCell
            cell.updateUI(withAPOD: viewModel!.apod)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "WALELandingImageTableCell", for: indexPath) as! WALELandingImageTableCell
            cell.setImage(withImageData: viewModel!.apod.imageData!)
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1, let imageData = viewModel?.apod.imageData {
            return UIImage(data: imageData)?.size.height ?? 0
        }
        return UITableView.automaticDimension
    }
}

//MARK: - WALELandingDisplayable -
extension WALELandingViewController: WALELandingDisplayable {
  
    func displayAPOD(withViewModel model: WALELandingViewModel) {
        viewModel = model
        reloadTable()
    }
    
    func displayLoader() {
        runOnMainThread {
            self.activityLoader.startAnimating()
        }
    }
    
    func hideLoader() {
        runOnMainThread {
            self.activityLoader.stopAnimating()
        }
    }
    
    func displayAlert(withString string: String) {
        runOnMainThread {
            let alertController = UIAlertController(title: "Alert", message: string, preferredStyle: UIAlertController.Style.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: - Private -
private extension WALELandingViewController {
    func registerCells() {
        let nib = UINib(nibName: "WALELandingTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WALELandingTableCell")
        let nibImage = UINib(nibName: "WALELandingImageTableCell", bundle: nil)
        tableView.register(nibImage, forCellReuseIdentifier: "WALELandingImageTableCell")
    }
    
    func tableViewSetup() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
    }
    
    func reloadTable() {
        
        runOnMainThread {
            self.tableView.reloadData()
        }
    }
}

