//
//  ViewControllerExtension.swift
//  FlightRider
//
//  Created by Tomi on 2019. 08. 29..
//  Copyright © 2019. Tomi. All rights reserved.
//

import Foundation
import CloudKit
import CoreData

extension ViewController {
    
    func saveUserDataToBothDb(params: [String]){
        let userRecord = CKRecord(recordType: "AppUsers")
        userRecord["uid"] = self.uid as CKRecordValue
        userRecord["email"] = self.email as CKRecordValue
        userRecord["flights"] = [String]() as CKRecordValue
        self.saveRecords(records: [userRecord])
        
        self.user = User(context: self.container.viewContext)
        self.user.uid = params[0]
        self.user.email = params[1]
        self.user.flights = [String]()
        self.user.changetag = ""
        self.saveContext()
        
    }
    
    func fetchUserFromCloud(results : [CKRecord]){
        self.user = User(context: self.container.viewContext)
        self.user.uid = results.first!["uid"]!
        self.user.email = results.first!["email"]!
        self.user.flights = results.first!["flights"]!
        self.user.changetag = results.first!.recordChangeTag!
        self.saveContext()
    }
    
    func compareUserChangeTag(localResults : [NSManagedObject],  cloudResults : [CKRecord]){
        self.user = localResults.first! as! User
        if(self.user.changetag != cloudResults.first!.recordChangeTag){
            fetchUserFromCloud(results : cloudResults)
        }
    }
    
    func decideIfUpdateCloudOrDeleteUser(){
        //this should never happen in case of users
    }
    

}
