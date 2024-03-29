//
//  CheckSeatsPresenter.swift
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

protocol CheckSeatsPresentationLogic {
    func fetchAirplaneModel(response: CheckSeats.GetAirplaneModel.Response)
    func fetchJustSelectedSeatFlag(response: CheckSeats.JustSelecetedSeatStatus.Response)
}

class CheckSeatsPresenter: CheckSeatsPresentationLogic {
  weak var viewController: CheckSeatsDisplayLogic?

    // MARK: - Fetch functions

    func fetchAirplaneModel(response: CheckSeats.GetAirplaneModel.Response) {
        viewController?.displayUserInterface(response: response)
    }

    func fetchJustSelectedSeatFlag(response: CheckSeats.JustSelecetedSeatStatus.Response) {
        viewController?.fetchJustSelectedSeatFlag(response: response)
    }

}
