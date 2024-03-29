//
//  LoginPresenter.swift
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

protocol LoginPresentationLogic {
    func fetchLoginData(response: Login.LoginFields.Response)
    func fetchLoginProcessResults(response: Login.LoginProcess.Response)
    func fetchSignupAuthenticationResults(response: Login.SignupProcess.Response)
    func setLoginError()
}

class LoginPresenter: LoginPresentationLogic {

  weak var viewController: LoginDisplayLogic?

    // MARK: - Fetch functions

    func fetchLoginData(response: Login.LoginFields.Response) {
        if(response.switchedOn) {
            viewController?.setRememberMeOn()
        } else {
            viewController?.setRememberMeOff()
        }
        let viewModel = Login.LoginFields.ViewModel(email: response.email, password: response.password, switchedOn: response.switchedOn)
        viewController?.displayLoginData(viewModel: viewModel)
    }

    func fetchLoginProcessResults(response: Login.LoginProcess.Response) {
        if(!response.success) {
            setLoginError()
        } else {
            viewController?.routeToFlightList(response: response)
        }
    }

    func fetchSignupAuthenticationResults(response: Login.SignupProcess.Response) {
        if(!response.success) {
            setLoginError()
        } else {
            let loginResponse = Login.LoginProcess.Response(email: response.email, uid: response.uid, databaseWorker: response.databaseWorker, success: response.success)
            viewController?.routeToFlightList(response: loginResponse)
        }
    }

    // MARK: - Set functions
    func setLoginError() {
        viewController?.setRemoveSpinner()
        viewController?.setLoginError()
    }
}
