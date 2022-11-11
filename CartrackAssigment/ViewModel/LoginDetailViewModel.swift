//
//  LoginDetailViewModel.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 09/11/22.
//

import Foundation

struct LoginViewModel {
    let db = DBManager()
    let passwordLengthRange = (6, 14) // (minimum length, maximum length)
    let usernameEmptyMessage = "Please Enter Username"
    let passwordEmptyMessage = "Please Enter Password"
    let passwordErrorMessage = "Password length must be in range 6-10 characters."
    
    // MARK: - Validation

    func validateInput(_ username: String?, password: String?, completion: (Bool, String?) -> Void) {
        if let username = username {
            if username.isEmpty {
                completion(false, usernameEmptyMessage)
                return
            }
        } else {
            completion(false, usernameEmptyMessage)
            return
        }
        if let password = password {
            if password.isEmpty {
                completion(false, passwordEmptyMessage)
                return
            } else if !validateTextLength(password, range: passwordLengthRange) {
                completion(false, passwordErrorMessage)
                return
            }
        } else {
            completion(false, passwordEmptyMessage)
            return
        }
        // Validated successfully.
        completion(true, nil)
    }

    
    private func validateTextLength(_ text: String, range: (Int, Int)) -> Bool {
        return (text.count >= range.0) && (text.count <= range.1)
    }

    // MARK: - Login

    func login(_ requestModel: LoginRequestModel, completion: @escaping (LoginResponseModel) -> Void) {
        
        let loginUserDetail = db.read()
        var responseModel = LoginResponseModel()
        
        if loginUserDetail?.username == requestModel.username && loginUserDetail?.password == requestModel.password {
            
            responseModel.success = true
            responseModel.successMessage = "User logged in successfully."
            completion(responseModel)
            
        } else {
            responseModel.success = false
            responseModel.errorMessage = "User Name or Password Incorrect."
            completion(responseModel)
        }
 
    }
}

struct LoginRequestModel {
    var username: String
    var password: String

    init(username: String, password: String) {
        self.username = username
        self.password = password
    }
}

struct LoginResponseModel {
    var success = false
    var errorMessage: String?
    var successMessage: String?
    var data: Any?
}
