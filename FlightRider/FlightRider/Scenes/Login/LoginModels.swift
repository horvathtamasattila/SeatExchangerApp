//
//  LoginModels.swift
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

enum Login
{
  // MARK: Use cases
  
    enum LoginFields
    {
        struct Request
        {
        }
        struct Response
        {
            var email : String?
            var password : String?
            var switchedOn : Bool!
        }
        struct ViewModel
        {
            var email : String?
            var password : String?
            var switchedOn : Bool!
        }
    }
    
    enum SwitchData
    {
        struct Request
        {
            var email : String?
            var password : String?
            var switchedOn : Bool!
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
    
    enum LoginProcess
    {
        struct Request
        {
            var email : String?
            var password : String?
            var switchedOn : Bool!
        }
        struct Response
        {
            var email : String?
            var uid : String?
            var databaseWorker: DatabaseWorker?
            var success: Bool!
        }
        struct ViewModel
        {
        }
    }
    
    enum SignupProcess
    {
        struct Request
        {
            var email : String?
            var password : String?
        }
        struct Response
        {
            var email : String?
            var uid : String?
            var databaseWorker: DatabaseWorker?
            var success: Bool!
        }
        struct ViewModel
        {
        }
    }
}