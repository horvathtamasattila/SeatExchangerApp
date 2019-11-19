//
//  LoginViewController.swift
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

protocol LoginDisplayLogic: class {
    func requestLoginData()
    func displayLoginData(viewModel: Login.LoginFields.ViewModel)
    func pushRememberMeSwitchChanged()
    func setLoginError()
    func setRememberMeOn()
    func setRememberMeOff()
    func setRemoveSpinner()
    func routeToFlightList(response: Login.LoginProcess.Response)
}

class LoginViewController: UIViewController, LoginDisplayLogic {

    @IBOutlet weak var rememberMeSwitch: UISwitch!
    @IBOutlet weak var PasswordField: UITextField!
    @IBOutlet weak var EmailFiled: UITextField!
    @IBOutlet weak var loginButton: CustomButton!
    var spinnerView: UIView!
    var ai: UIActivityIndicatorView!
    let backgroundImageView = UIImageView()

  var interactor: LoginBusinessLogic?
  var router: (NSObjectProtocol & LoginRoutingLogic & LoginDataPassing)?

  // MARK: Object lifecycle

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  // MARK: Setup

  private func setup() {
    let viewController = self
    let interactor = LoginInteractor()
    let presenter = LoginPresenter()
    let router = LoginRouter()
    viewController.interactor = interactor
    viewController.router = router
    interactor.presenter = presenter
    presenter.viewController = viewController
    router.viewController = viewController
    router.dataStore = interactor
  }

  // MARK: Routing

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let scene = segue.identifier {
      let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
      if let router = router, router.responds(to: selector) {
        router.perform(selector, with: segue)
      }
    }
  }

  // MARK: View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setGestureRecognizer()
    setSpinnerView()
    requestLoginData()
    setRememberMeSwitch()
    setBackground()
  }

    override func viewDidLayoutSubviews() {
        loginButton.setupButton()
    }

    // MARK: - Request functions

    func requestLoginData() {
        let request = Login.LoginFields.Request()
        interactor?.requestLoginData(request: request)
    }

    // MARK: - Push functions

    @objc func pushRememberMeSwitchChanged() {
        let request = Login.SwitchData.Request(email: EmailFiled.text, password: PasswordField.text, switchedOn: rememberMeSwitch.isOn)
        interactor?.pushRememberMeSwitchChanged(request: request)
    }

    // MARK: - Set functions

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func setLoginError() {
        self.removeSpinner(spinnerView: self.spinnerView, ai: self.ai)
        let ac = UIAlertController(title: "Error", message: "Could not log in or sign up", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

    func setRememberMeSwitch() {
        rememberMeSwitch.addTarget(self, action: #selector(self.pushRememberMeSwitchChanged), for: .valueChanged)
    }

    func setRememberMeOn() {
        rememberMeSwitch.setOn(true, animated: false)
    }

    func setRememberMeOff() {
        rememberMeSwitch.setOn(false, animated: false)
    }

    func setRemoveSpinner() {
        self.removeSpinner(spinnerView: spinnerView, ai: ai)
    }

    // MARK: - Display functions

    func displayLoginData(viewModel: Login.LoginFields.ViewModel) {
        EmailFiled.text = viewModel.email
        PasswordField.text = viewModel.password
    }

    // MARK: - Local functions

    @IBAction func LoginButtonPressed(_ sender: Any) {
        let request = Login.LoginProcess.Request(email: EmailFiled.text, password: PasswordField.text, switchedOn: rememberMeSwitch.isOn)
        interactor?.requestLoginDataUpdate(request: request)
        showSpinner(view: self.view, spinnerView: spinnerView, ai: ai)
        interactor?.requestLoginAuthentication(request: request)
    }

    @IBAction func SignupButtonPressed(_ sender: Any) {
        let request = Login.SignupProcess.Request(email: EmailFiled.text, password: PasswordField.text)
        interactor?.requestSignupAuthentication(request: request)
        showSpinner(view: self.view, spinnerView: spinnerView, ai: ai)

    }

    private func setGestureRecognizer() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }

    private func setAnchors() {
        view.addSubview(backgroundImageView)
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }

    private func setBackground() {
        setAnchors()
        setGradientBackground()
        setCloudImage()
        setNavigationBar()
    }

    private func setCloudImage() {
        let imageLayer = CALayer()
        assert(UIImage(named: "clouds_all") != nil)
        let cloudsBackground = UIImage(named: "clouds_all")!.cgImage
        imageLayer.contents = cloudsBackground
        imageLayer.frame = view.bounds
        backgroundImageView.layer.addSublayer(imageLayer)
        view.sendSubviewToBack(backgroundImageView)
    }

    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [(#colorLiteral(red: 0.4068969488, green: 0.5874248147, blue: 0.8163669705, alpha: 1)).cgColor, (#colorLiteral(red: 0.8379636407, green: 0.8866117001, blue: 0.9216472507, alpha: 1)).cgColor]
        gradientLayer.masksToBounds = false
        backgroundImageView.layer.addSublayer(gradientLayer)
    }

    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }

    private func setSpinnerView() {
        spinnerView = UIView.init(frame: self.view.bounds)
        ai = UIActivityIndicatorView.init(style: .whiteLarge)
    }

    // MARK: - Temporary routing

    func routeToFlightList(response: Login.LoginProcess.Response) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "FlightList") as? ListFlightsViewController {
            vc.uid = response.uid
            vc.email = response.email
            vc.databaseWorker = response.databaseWorker
            self.removeSpinner(spinnerView: self.spinnerView, ai: self.ai)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
