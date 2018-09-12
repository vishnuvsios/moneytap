//
//  ViewController.swift
//  moneyTap
//
//  Created by Vishnuvarthan Deivendiran on 11/09/18.
//  Copyright © 2018 Vishnuvarthan Deivendiran. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

class ViewController: BaseViewController,WikipediaCompleteDelegate,UISearchResultsUpdating {
    
    var viewModel = WikiViewModel()
    @IBOutlet weak var wikiTableview: UITableView!
    var tabledata = [String]()
    var filteredTableData = [String]()
    var resultSearchController = UISearchController()
    var leftMenuVc : LeftMenuViewController!
    var leftMenuView : UIView!

    override func viewDidLoad() {
        viewModel.delegate = self

        self.startActivity()
        
        self.wikiTableview.register(UINib(nibName: "CustomTableViewCell", bundle:nil), forCellReuseIdentifier: "CustomTableViewCell")

        self.resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.dimsBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.barStyle = UIBarStyle.black
            controller.searchBar.barTintColor = UIColor.white
            controller.searchBar.backgroundColor = UIColor.clear;            self.wikiTableview.tableHeaderView = controller.searchBar
            return controller
        })()

        wikiTableview.rowHeight = UITableViewAutomaticDimension
        wikiTableview.estimatedRowHeight = 100
        wikiTableview.separatorColor = UIColor.clear
        
        viewModel.getWikipediaDetailsAPI()

        self.createLeftMenu()

        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func createLeftMenu()  {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(ViewController.handleMenu),
            name: NSNotification.Name(rawValue: "MenuTapped"),
            object: nil)
        
    }
    @objc func handleMenu()  {
        if leftMenuVc == nil {
            addLeftMenu()
        }
        if leftMenuVc.view.isHidden {
            leftMenuVc.showAnimation()
            leftMenuView.alpha = 1
            leftMenuView.isHidden = false
        }else {
            leftMenuVc.hideAnimation(_view: leftMenuView)
        }
        
    }
    func addLeftMenu() {
        
        let myStockStoryboard = UIStoryboard(name: "Main", bundle: nil)
        leftMenuVc  = myStockStoryboard.instantiateViewController(withIdentifier: "LeftMenuViewController") as? LeftMenuViewController
        leftMenuVc!.view.frame = CGRect(x: 0, y: 20, width: self.view.bounds.width, height:  self.view.bounds.height - 20)
        leftMenuView = UIView.init(frame: leftMenuVc!.view.frame)
        leftMenuView.backgroundColor = UIColor(white: 0.0, alpha: 0.25)
        self.view.addSubview(leftMenuView)
        leftMenuVc!.willMove(toParentViewController: self)
        self.view.addSubview(leftMenuVc!.view)
        self.addChildViewController(leftMenuVc!)
        leftMenuVc!.didMove(toParentViewController: self)
        leftMenuVc.view.isHidden = true
        leftMenuView.isHidden = true
        self.view.layoutIfNeeded()
    }
    func completeAPICall(responce: String) {
        self.stopAnimating()
        if responce == "Success" {
            self.wikiTableview.delegate = self
            self.wikiTableview.dataSource = self

            self.wikiTableview.reloadData()
        } else {
            showAlertMessage(title: "", message: "Order API Response Failure")
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

    func updateSearchResults(for searchController: UISearchController) {
        self.navigationController?.isNavigationBarHidden = true

        filteredTableData.removeAll(keepingCapacity: false)
        let searchPredicate = NSPredicate(format: "SELF CONTAINS[c] %@", searchController.searchBar.text!)
        let array = (tabledata as NSArray).filtered(using: searchPredicate)
        filteredTableData = array as! [String]
        self.wikiTableview.reloadData()
    }
}




private typealias TableViewDataSourceMethods = ViewController
extension TableViewDataSourceMethods: UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive {
            return self.filteredTableData.count

        }else{
            return self.viewModel.getRowCount()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = wikiTableview.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        if self.resultSearchController.isActive {
            cell.articleTitle.text = filteredTableData[indexPath.row]
        }else {
            cell.articleImageview.sd_setImage(with: URL(string: viewModel.getImageUrl(index: indexPath.row)), placeholderImage: UIImage(named: "no-image"))
            cell.articleTitle.text = self.viewModel.getTitleName(index: indexPath.row)
            cell.articleDetails1.text = self.viewModel.getDescriptionName(index: indexPath.row)
            tabledata.append(cell.articleTitle.text!)
        }
        cell.selectionStyle = .none

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
   
    
}

