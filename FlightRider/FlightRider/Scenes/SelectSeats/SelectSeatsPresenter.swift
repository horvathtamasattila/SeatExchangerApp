//
//  SelectSeatsPresenter.swift
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

protocol SelectSeatsPresentationLogic
{
    func requestPickerInitialization(request: SelectSeats.PickerDataSource.Request)
    func fetchCheckSeatsData(dataModel: SelectSeats.StoredData.CheckSeatsModel)
    func fetchDisplayData(response: SelectSeats.DisplayData.Response)
    func fetchPickerDataModel(response: SelectSeats.PickerDataModel.Response)
    func fetchUpdateSeatResult(response: SelectSeats.UpdateSeat.Response)
}

class SelectSeatsPresenter: SelectSeatsPresentationLogic
{

  weak var viewController: SelectSeatsDisplayLogic?
  
    //MARK: Request functions
    func requestPickerInitialization(request: SelectSeats.PickerDataSource.Request) {
        
    }
    
    //MARK: - Fetch functions
    
    func fetchCheckSeatsData(dataModel: SelectSeats.StoredData.CheckSeatsModel) {
        viewController?.routeToCheckSeats(dataModel: dataModel)
    }
    
    func fetchDisplayData(response: SelectSeats.DisplayData.Response) {
        let viewModel = SelectSeats.DisplayData.ViewModel(image: response.image, flightNumber: response.flightNumber)
        viewController?.displayData(viewModel: viewModel)
    }
    
    func fetchPickerDataModel(response: SelectSeats.PickerDataModel.Response) {
        var dataModel = SelectSeats.PickerDataModel.ViewModel()
        dataModel.pickerDataNumbers = [String]()
        dataModel.pickerData = [[String]]()
        for i in 1...response.airplaneModel.numberOfSeats{
            dataModel.pickerDataNumbers.append((String(format: "%02d", i)))
        }
        
        let charArr : [Character] = Array(response.airplaneModel.columns)
        var strArr = [String]()
        for char in charArr{
            strArr.append(String(char))
        }
        dataModel.pickerData = [dataModel.pickerDataNumbers, strArr]
        viewController?.displayPickerView(viewModel: dataModel)
    }
    
    func fetchUpdateSeatResult(response: SelectSeats.UpdateSeat.Response) {
        if response.result == true{
            viewController?.displaySuccessfulSeatUpdate(response: response)
        }
        else{
            viewController?.displayUnsuccessfulSeatUpdate(response: response)
        }
    }
    
  

}
