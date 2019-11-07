//
//  ListFlightsModels.swift
//  FlightRider
//
//  Created by Tomi on 2019. 10. 31..
//  Copyright (c) 2019. Tomi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit
import CloudKit

enum ListFlights
{
    enum CannotCheckinData
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
            var iataNumber : String
            var departureDate : Date
            var imageToLoad: UIImage?
        }
    }
    
    enum CheckSeatsData
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct DataStore
        {
            let flight : ManagedFlight
            let user : ManagedUser
            let justSelectedSeat : Bool
        }
    }
    
    enum DataStore
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct Results
        {
        }
        struct ViewModel
        {
            var flights : [ManagedFlight]!
            var departureDates: [String]!
        }
        struct DataStore
        {
            var uid: String!
            var email: String!
            var user : ManagedUser?
            var cloudUser : CloudUser!
            var flights : [ManagedFlight]!
        }
    }
    
    enum SelectSeatsData
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
            let flight : ManagedFlight
            let user : ManagedUser
            let userRecord : CKRecord
            let image : UIImage?
            let databaseWorker : DatabaseWorker
        }
    }
    
    enum UserData
    {
        struct EmptyRequest
        {
        }
        struct Request
        {
            var userUid : String!
            var userEmail : String!
            
        }
        struct Response
        {
            var localUser : ManagedUser?
            var cloudUser : CloudUser?
        }
        struct ViewModel
        {
        }
    }
    
    enum StoredUserFlights
    {
        struct Request
        {
        }
        struct Response
        {
            var flights : [String]
        }
        struct ViewModel
        {
        }
    }
    
    enum UIUpdate
    {
        struct Request
        {
        }
        struct Response
        {
        }
        struct ViewModel
        {
        }
    }
    
    enum FligthsToDisplay
    {
        struct DataModel
        {
            var flights: [ManagedFlight]
        }
        struct ViewModel
        {
            var flights: [ManagedFlight]
            var departureDates: [String]
        }
    }
    
    enum FlightAddition
    {
        struct DatabaseRequest
        {
            let iataNumber : String
            let departureDate : String
            let flights: [ManagedFlight]
            let startDate : NSDate
            let finishDate : NSDate
        }
        struct Request
        {
            let iataNumber : String
            let departureDate : Date
            var flights: [ManagedFlight]! = nil
        }
        struct Response
        {
            let errorMessage: String?
        }
        struct ViewModel
        {
        }
        struct PushFlightToDataStore
        {
            let flight: ManagedFlight
        }
        struct CloudUserSaveRequest
        {
            let user: CloudUser
        }
        struct LocalUserChangeTag
        {
            let changeTag: String
        }
        
    }
    enum LocalDatabase
    {
        struct SaveRequest
        {
        }
    }
}
