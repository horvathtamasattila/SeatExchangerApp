//
//  CheckSeatsInteractor.swift
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

protocol CheckSeatsBusinessLogic: class
{
    func requestAirplaneModel(request: inout CheckSeats.GetAirplaneModel.Request)
    func requestJustSelectedSeatFlag(request: CheckSeats.JustSelecetedSeatStatus.Request)
    func fetchAirplaneModel(response: CheckSeats.GetAirplaneModel.Response)
    func pushDataFromPreviousViewController(viewModel: SelectSeats.StoredData.CheckSeatsModel)
    func pushDataFromPreviousViewController(viewModel: ListFlights.CheckSeatsData.DataStore)
    func getSeatStatus(row: Int, column: Int, model: AirplaneModel) -> Set<ManagedSeat>
    func getUserEmail() -> String
}

protocol CheckSeatsDataStore
{
    var dataStore: CheckSeats.DataStore.DataStore  { get set }
}

class CheckSeatsInteractor: CheckSeatsBusinessLogic, CheckSeatsDataStore
{
    var dataStore = CheckSeats.DataStore.DataStore()
    
    var presenter: CheckSeatsPresentationLogic?
    var worker: CheckSeatsWorkerProtocol?
    
    //MARK: - Request functions
    
    func requestAirplaneModel(request: inout CheckSeats.GetAirplaneModel.Request) {
        request.airplaneType = dataStore.flight.airplaneType
        worker = CheckSeatsWorker()
        worker?.interactor = self
        worker?.requestAirplaneModel(request: request)
    }
    
    func requestJustSelectedSeatFlag(request: CheckSeats.JustSelecetedSeatStatus.Request) {
        let response = CheckSeats.JustSelecetedSeatStatus.Response(justSelectedSeat: dataStore.justSelectedSeat)
        presenter?.fetchJustSelectedSeatFlag(response: response)
    }
    
    //MARK: - Fetch functions
    
    func fetchAirplaneModel(response: CheckSeats.GetAirplaneModel.Response) {
        presenter?.fetchAirplaneModel(response:response)
    }
  
    // MARK: Push functions
    
    func pushDataFromPreviousViewController(viewModel: SelectSeats.StoredData.CheckSeatsModel) {
        dataStore.flight = viewModel.flight
        dataStore.justSelectedSeat = viewModel.justSelectedSeat
        dataStore.user = viewModel.user
    }
    
    func pushDataFromPreviousViewController(viewModel: ListFlights.CheckSeatsData.DataStore) {
        dataStore.flight = viewModel.flight
        dataStore.justSelectedSeat = viewModel.justSelectedSeat
        dataStore.user = viewModel.user
    }
    
    func getSeatStatus(row: Int, column: Int, model: AirplaneModel) -> Set<ManagedSeat> {
        return dataStore.flight.seats.filter{ $0.number == "\(String(format: "%02d", row))\(Array(model.columns)[column])" }
    }
    
    func getUserEmail() -> String {
        return dataStore.user.email
    }
  
}
