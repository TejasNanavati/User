//
//  UserDataModel.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import Foundation

import Alamofire

protocol UserDataModelDelegate:AnyObject {
    func didReceiveDataUpdate(users: [User])
    func didFailDataUpdateWithError(error: Error)
}

extension UserDataModelDelegate  {
    func didReceiveDataForMap(user:User){
        
    }
}

class UserDataModel {
    
    weak var delegate: UserDataModelDelegate?
    
    // MARK: - APi Request

    func requestData(url: String) {
        Alamofire.request(url).responseJSON { response in
            
            guard response.result.isSuccess else {
                if let error = response.result.error {
                    print("Error while fetching data: \(error)")
                    self.delegate?.didFailDataUpdateWithError(error: error)
                }
                return
            }
            
            guard let responseJSON = response.result.value as? [[String: Any]] else {
                print("Invalid data received from the service")
                return
            }
            
            self.setDataWithResponse(response: responseJSON)
        }
    }
    
    // MARK: - APi Responce

    private func setDataWithResponse(response:[[String: Any]]) {
        
        print("downloaded data: \(response)")
        
        var usersArray = [User]()
        
        for data in response {
            if let user = User(json: data) {
                usersArray.append(user)
            }
        }
        
        delegate?.didReceiveDataUpdate(users: usersArray)
    }
}
