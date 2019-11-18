//
//  CheckSeatsRouter.swift
//  FlightRider
//
//  Created by Tomi on 2019. 11. 04..
//  Copyright (c) 2019. Tomi. All rights reserved.
//
//  This file was generated by the Clean Swift Xcode Templates so
//  you can apply clean architecture to your iOS and Mac projects,
//  see http://clean-swift.com
//

import UIKit

@objc protocol CheckSeatsRoutingLogic {
  //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol CheckSeatsDataPassing {
  var dataStore: CheckSeatsDataStore? { get }
}

class CheckSeatsRouter: NSObject, CheckSeatsRoutingLogic, CheckSeatsDataPassing {
  weak var viewController: CheckSeatsViewController?
  var dataStore: CheckSeatsDataStore?

  // MARK: Routing

  //func routeToSomewhere(segue: UIStoryboardSegue?)
  //{
  //  if let segue = segue {
  //    let destinationVC = segue.destination as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //  } else {
  //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
  //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
  //    var destinationDS = destinationVC.router!.dataStore!
  //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
  //    navigateToSomewhere(source: viewController!, destination: destinationVC)
  //  }
  //}

  // MARK: Navigation

  //func navigateToSomewhere(source: CheckSeatsViewController, destination: SomewhereViewController)
  //{
  //  source.show(destination, sender: nil)
  //}

  // MARK: Passing data

  //func passDataToSomewhere(source: CheckSeatsDataStore, destination: inout SomewhereDataStore)
  //{
  //  destination.name = source.name
  //}
}
