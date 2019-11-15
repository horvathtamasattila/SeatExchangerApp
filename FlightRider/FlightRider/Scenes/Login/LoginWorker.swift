//
//  LoginWorker.swift
//  FlightRider
//
//  Created by Tomi on 2019. 10. 29..
//  Copyright (c) 2019. Tomi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CloudKit
import Firebase

protocol LoginWorkerProtocol {
    var interactor: LoginBusinessLogic? { get set }
    
    func requestLoginData(request: Login.LoginFields.Request)
    func requestLoginAuthentication(request: Login.LoginProcess.Request)
    func requestSignupAuthentication(request: Login.SignupProcess.Request)
    func pushSwitchOffRememberMe()
    func pushSwitchOnRememberMe(request: Login.SwitchData.Request)
    func pushLoginDataUpdate(request: Login.LoginProcess.Request)
    func saveRecords(records : [CKRecord])
}

class LoginWorker : LoginWorkerProtocol
{
  weak var interactor: LoginBusinessLogic?
    
    // MARK: - Request functions
    
    func requestLoginData(request: Login.LoginFields.Request){
        var response = Login.LoginFields.Response()
        
        let defaults: UserDefaults? = UserDefaults.standard
        
        if (defaults?.bool(forKey: "ISRemember")) ?? false{
            response.email = defaults?.value(forKey: "SavedUserName") as? String ?? ""
            if let retrievedString = KeychainWrapper.standard.string(forKey: "SavedPassword"){
                response.password = retrievedString
            }
            response.switchedOn = true
        }
        else {
            response.switchedOn = false
        }
        interactor?.fetchLoginData(response: response)
    }
    
    func requestLoginAuthentication(request: Login.LoginProcess.Request){
        Auth.auth().signIn(withEmail: request.email!, password: request.password!) { [unowned self] authResult, error in
            var response = Login.LoginProcess.Response()
            if error != nil {
                response.success = false
            }
            else{
                response.uid = authResult?.user.uid
                response.email = authResult?.user.email
                response.success = true
            }
            self.interactor?.fetchLoginProcessResults(response: response)
        }
    }
    
    func requestSignupAuthentication(request: Login.SignupProcess.Request){
        Auth.auth().createUser(withEmail: request.email!, password: request.password!) { authResult, error in
            var response = Login.SignupProcess.Response()
            if error != nil{
                response.success = false
            }
            else{
                response.email = request.email
                response.uid = authResult?.user.uid
                response.success = true
            }
            self.interactor?.fetchSignupAuthenticationResults(response: response)
            
        }
    }
    
    // MARK: - Push functions
    
    func pushSwitchOffRememberMe(){
        let defaults: UserDefaults? = UserDefaults.standard
        defaults?.set(false, forKey: "ISRemember")
    }
    
    func pushSwitchOnRememberMe(request: Login.SwitchData.Request){
        let defaults: UserDefaults? = UserDefaults.standard
        defaults?.set(true, forKey: "ISRemember")
        defaults?.set(request.email, forKey: "SavedUserName")
        let saveResult = KeychainWrapper.standard.set(request.password!, forKey: "SavedPassword")
        if !saveResult{
            print("Password save to keychain was unsuccessful")
        }
    }
    
    func pushLoginDataUpdate(request: Login.LoginProcess.Request){
        let defaults: UserDefaults? = UserDefaults.standard
        let savedName = defaults?.string(forKey: "SavedUserName")
        let savedPass = KeychainWrapper.standard.string(forKey: "SavedPassword")
        
        if (savedName != request.email){
            defaults?.set(request.email, forKey: "SavedUserName")
        }
        if (savedPass != request.password){
            let saveResult = KeychainWrapper.standard.set(request.password!, forKey: "SavedPassword")
            if !saveResult{
                print("Password save to keychain was unsuccessful")
            }
        }
    }
    
    // MARK: - Local functions
    
    func saveRecords(records : [CKRecord]){
        let operation = CKModifyRecordsOperation(recordsToSave: records, recordIDsToDelete: nil)
        operation.savePolicy = .ifServerRecordUnchanged
        CKContainer.default().publicCloudDatabase.add(operation)
    }
}