//
//  SelectSeatsModels.swift
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

enum SelectSeats
{
  // MARK: Use cases
  
  enum StoredData
  {
    struct Request
    {
    }
    struct Response
    {
        var flight : ManagedFlight?
        var user : ManagedUser?
        var userRecord : CKRecord?
        var image : UIImage?
    }
    struct ViewModel
    {
        var flight : ManagedFlight?
        var user : ManagedUser?
        var userRecord : CKRecord?
        var image : UIImage?
        var justSelectedSeat : Bool = false
    }
    struct CheckSeatsModel
    {
        var flight : ManagedFlight!
        var user : ManagedUser!
        var justSelectedSeat : Bool!
    }
  }
    enum DisplayData
    {
        struct Request
        {
        }
        struct Response
        {
            var image: UIImage?
            var flightNumber : String?
        }
        struct ViewModel
        {
            var image: UIImage?
            var flightNumber : String?
        }
    }
    
    enum PickerDataSource
    {
        struct Request
        {
        }
        struct Response
        {
            let dataSource : [JSON]
        }
        struct ViewModel
        {
        }
    }
    
    enum PickerDataModel
    {
        struct Request
        {
        }
        struct Response
        {
            let airplaneModel : AirplaneModel
        }
        struct ViewModel
        {
            var pickerData: [[String]]!
            var pickerDataNumbers : [String]!
            let maxElements = 10000
            let numberOfComponents = 2
            var selectedSeatNumber : String!
            let rowHeightConstant : CGFloat = 0.1562
            let widthForComponentConstant: CGFloat = 0.1875
        }
    }
    
    enum UpdateSeat
    {
        struct Request
        {
            var selectedSeatNumber: String?
            var email : String?
            var flight : ManagedFlight?
            
            func doesAllFieldsHaveValue() -> Bool {
                let optionals: [Any?] = [selectedSeatNumber, email, flight]
                if (optionals.contains{ $0 == nil }) {return false}
                return true
            }
        }
        
        struct Response
        {
            var result: Bool
            var selectedSeatNumber: String?
            var errorMessage: String?
        }
        struct ViewModel
        {
        }
    }
}
