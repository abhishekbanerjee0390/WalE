//
//  WALELandingViewController.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//

import UIKit

protocol WALELandingDisplayable: AnyObject {
    func displayAPOD(withViewModel: WALELandingViewModel)
}

final class WALELandingViewController: UITableViewController {
    
    private var interactor: WALELandingInteractable!
    private var viewModel: WALELandingViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        tableViewSetup()
        assert(interactor != nil, "interactor should not be nil")
        interactor.processViewDidLoad()
        registerCell()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        let sections = (viewModel != nil) ? 1 : 0
        print("sections", sections)
        return sections
       // return (viewModel != nil) ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let rows = (viewModel != nil) ? 1 : 0
        print("rows", rows)
        return rows

        //return (viewModel != nil) ? 1 : 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WALELandingTableCell", for: indexPath) as! WALELandingTableCell
        cell.updateUI(withAPOD: viewModel!.apod)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return UIView()
//    }
}

//MARK: - WALELandingDisplayable -
extension WALELandingViewController: WALELandingDisplayable {
    func displayAPOD(withViewModel model: WALELandingViewModel) {
        self.viewModel = model
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Private -
private extension WALELandingViewController {
    //WALELandingTableCell.swift
    func registerCell() {
        let nib = UINib(nibName: "WALELandingTableCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "WALELandingTableCell")
    }
    
    func tableViewSetup() {
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        tableView.bounces = false
    }
    
    func initialSetup() {
        
        let presenter = WALELandingPresenter(withViewController: self)
        let interactor = WALELandingInteractor(withPresenter: presenter)
        self.interactor = interactor
    }
}
