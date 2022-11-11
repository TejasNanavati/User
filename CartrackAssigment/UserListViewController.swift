//
//  ViewController.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import UIKit

class UserListViewController: UIViewController, UserDataModelDelegate {

    @IBOutlet var tableView: UITableView!
    
    internal var usersArray = [User](){
        didSet {
            tableView?.reloadData()
        }
    }
    private let dataSource = UserDataModel()
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Users"
        setupTableView()
        dataSource.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showLoadingView()
        downloadUsers()
    }

    func setupTableView() {
        
        tableView.dataSource = self
        tableView.delegate = self
        
       // tableView.separatorColor = .clear
    }
    
    // MARK: - DataModel
    @objc private func downloadUsers() {
        dataSource.requestData(url: "https://jsonplaceholder.typicode.com/users")
    }
    
    // MARK: - UserDataModelDelegate
    func didReceiveDataUpdate(users: [User]) {
        usersArray = users
        hideLoadingView(tableView: tableView)
    }
    
    func didFailDataUpdateWithError(error: Error) {
        hideLoadingView(tableView: tableView)
    }
    
    // MARK: - Loading
    func showLoadingView() {
        let loadingView = UIView(frame: self.view.bounds)
        loadingView.tag = 42
        loadingView.backgroundColor = .black
        loadingView.alpha = 0.7
        
        let loadingIndicator = UIActivityIndicatorView(style: .medium)
        loadingIndicator.center = loadingView.center
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
        
        loadingView.addSubview(loadingIndicator)
        
        self.view.addSubview(loadingView)
    }
    
    func hideLoadingView(tableView: UITableView) {
        tableView.refreshControl?.endRefreshing()
        self.view.viewWithTag(42)?.removeFromSuperview()
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier) as? UserCell {
            cell.config(user: usersArray[indexPath.row])
            return cell
        }
        
        return UITableViewCell()
    }
}



extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let user = usersArray[indexPath.row]
        tableView.deselectRow(at: indexPath, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
         let vc = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
        let mapAnnotation = MapAnnotationModel(name: user.name,email: user.email, latitude: user.address.geo?.lat ?? 0.0, longitude: user.address.geo?.lng ?? 0.0)
        vc.mapAnnotation = mapAnnotation
         self.navigationController?.pushViewController(vc, animated: true)

    }
}

