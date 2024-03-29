//
//  CheckSeatsViewController.swift
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

protocol CheckSeatsDisplayLogic: class {
    func fetchDataFromPreviousViewController(viewModel: SelectSeats.StoredData.CheckSeatsModel)
    func fetchDataFromPreviousViewController(viewModel: ListFlights.CheckSeatsData.DataStore)
    func fetchJustSelectedSeatFlag(response: CheckSeats.JustSelecetedSeatStatus.Response)

    func displayUserInterface(response: CheckSeats.GetAirplaneModel.Response)
}

class CheckSeatsViewController: UIViewController, CheckSeatsDisplayLogic {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!

    var constants: CheckSeats.GetConstants.ViewModel!

    var interactor: CheckSeatsBusinessLogic?
    var router: (NSObjectProtocol & CheckSeatsRoutingLogic & CheckSeatsDataPassing)?

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
    let interactor = CheckSeatsInteractor()
    let presenter = CheckSeatsPresenter()
    let router = CheckSeatsRouter()
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
        customizeBackButton()
        let request = CheckSeats.GetConstants.Request(height: self.view.frame.height, width: self.view.frame.width)
        constants = CheckSeats.GetConstants.ViewModel(request: request)
        var airplaneModelRequest = CheckSeats.GetAirplaneModel.Request()
        interactor?.requestAirplaneModel(request: &airplaneModelRequest)
    }

  // MARK: - Fetch functions

    func fetchDataFromPreviousViewController(viewModel: SelectSeats.StoredData.CheckSeatsModel) {
        interactor?.pushDataFromPreviousViewController(viewModel: viewModel)
    }

    func fetchDataFromPreviousViewController(viewModel: ListFlights.CheckSeatsData.DataStore) {
        interactor?.pushDataFromPreviousViewController(viewModel: viewModel)
    }

    func fetchJustSelectedSeatFlag(response: CheckSeats.JustSelecetedSeatStatus.Response) {
        if(response.justSelectedSeat == true) {
            let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - 3], animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Display functions

    func displayUserInterface(response: CheckSeats.GetAirplaneModel.Response) {
        let leftLetters = instantiateStackView(axis: .horizontal, spacing: constants.lettersSpacing)
        let rightLetters = instantiateStackView(axis: .horizontal, spacing: constants.lettersSpacing)
        fillTopStackViews(leftLetters: leftLetters, rightLetters: rightLetters, response: response)
        let seatNumbers = instantiateStackView(axis: .vertical, spacing: constants.lettersSpacing)
        fillLeadingStackView(seatNumbers: seatNumbers)
        instantiateRows(model: response.airplaneModel, seatNumbers: seatNumbers, leftLetters: leftLetters, rightLetters: rightLetters)
        setBackground()
    }

    // MARK: - Local functions

    @objc func customBackAction() {
        let request = CheckSeats.JustSelecetedSeatStatus.Request()
        interactor?.requestJustSelectedSeatFlag(request: request)
    }

    func customizeBackButton() {
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "< Back", style: .plain, target: self, action: #selector(customBackAction))
        self.navigationItem.leftBarButtonItem = newBackButton
    }

    func fillLeadingStackView(seatNumbers: UIStackView) {
        contentView.addSubview(seatNumbers)
        NSLayoutConstraint(item: seatNumbers, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constants.seatnumbersViewWidth).isActive = true
        NSLayoutConstraint(item: seatNumbers, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1, constant: constants.seatnumbersViewLeading).isActive = true
        NSLayoutConstraint(item: seatNumbers, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: constants.seatnumbersViewTop).isActive = true
        NSLayoutConstraint(item: seatNumbers, attribute: .bottom, relatedBy: .equal, toItem: contentView, attribute: .bottom, multiplier: 1, constant: -constants.seatnumbersViewBottom).isActive = true
    }

    func fillTopStackViews(leftLetters: UIStackView, rightLetters: UIStackView, response: CheckSeats.GetAirplaneModel.Response) {
        for i in 0...Array(response.airplaneModel.columns).count - 1 {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            lbl.textColor = .white
            lbl.text = String(Array(response.airplaneModel.columns)[i])
            lbl.font = UIFont(name: "OpenSans-Regular", size: constants.fontSize)
            if(i <= 2) {
                leftLetters.addArrangedSubview(lbl)
            } else {
                rightLetters.addArrangedSubview(lbl)
            }
        }
        contentView.addSubview(leftLetters)
        contentView.addSubview(rightLetters)
        NSLayoutConstraint(item: leftLetters, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: constants.distanceFromTop).isActive = true
        NSLayoutConstraint(item: leftLetters, attribute: .leading, relatedBy: .equal, toItem: contentView, attribute: .leading, multiplier: 1.0, constant: constants.distanceFromLeading).isActive = true
        NSLayoutConstraint(item: rightLetters, attribute: .top, relatedBy: .equal, toItem: contentView, attribute: .top, multiplier: 1, constant: constants.distanceFromTop).isActive = true
        NSLayoutConstraint(item: rightLetters, attribute: .trailing, relatedBy: .equal, toItem: contentView, attribute: .trailing, multiplier: 1.0, constant: -constants.distanceFromTrailing).isActive = true
    }

    func fillRows(row: Int, column: Int, model: AirplaneModel, stackViewABC: UIStackView, stackViewDEF: UIStackView) {
        let seatview = UIView(frame: CGRect(x: 0, y: 0, width: constants.viewSize, height: constants.viewSize))
        let result = interactor?.getSeatStatus(row: row, column: column, model: model)
        let userEmail = interactor?.getUserEmail()
        if result!.isEmpty {
            seatview.backgroundColor = .blue
        } else if(result?.first!.occupiedBy == userEmail) {
            seatview.backgroundColor = .green
        } else {
            seatview.backgroundColor = .red
            Tap.on(view: seatview) {
                self.viewTapped(view: seatview, email: (result?.first!.occupiedBy)!)
            }
        }

        seatview.layer.cornerRadius = constants.cornerRadius
        seatview.translatesAutoresizingMaskIntoConstraints = false
        seatview.accessibilityIdentifier = "\(row)\(Array(model.columns)[column])"
        if(column <= 2) {
            stackViewABC.addArrangedSubview(seatview)
        } else {
            stackViewDEF.addArrangedSubview(seatview)
        }

        NSLayoutConstraint(item: seatview, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constants.viewSize).isActive = true
        NSLayoutConstraint(item: seatview, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constants.viewSize).isActive = true
    }

    func instantiateRows(model: AirplaneModel, seatNumbers: UIStackView, leftLetters: UIStackView, rightLetters: UIStackView) {
        for row in 1...model.numberOfSeats {
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            lbl.textColor = .white
            lbl.text = String(row)
            lbl.font = UIFont(name: "OpenSans-Regular", size: constants.fontSize)
            seatNumbers.addArrangedSubview(lbl)
            let stackViewABC = instantiateStackView(axis: .horizontal, spacing: constants.viewSpacing)
            let stackViewDEF = instantiateStackView(axis: .horizontal, spacing: constants.viewSpacing)
            for column in 0...Array(model.columns).count - 1 {
                fillRows(row: row, column: column, model: model, stackViewABC: stackViewABC, stackViewDEF: stackViewDEF)
            }
            setConstraintForContainerStackViews(seatNumbers: seatNumbers, stackViewABC: stackViewABC, stackViewDEF: stackViewDEF, leftLetters: leftLetters, rightLetters: rightLetters, lbl: lbl)
        }
    }

    func instantiateStackView(axis: NSLayoutConstraint.Axis, spacing: CGFloat) -> UIStackView {
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        stackView.axis = axis
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = spacing
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }

    private func setBackground() {
        contentView.backgroundColor = #colorLiteral(red: 0.4068969488, green: 0.5874248147, blue: 0.8163669705, alpha: 1)
        view.backgroundColor = #colorLiteral(red: 0.4068969488, green: 0.5874248147, blue: 0.8163669705, alpha: 1)
        scrollView.backgroundColor =  #colorLiteral(red: 0.4068969488, green: 0.5874248147, blue: 0.8163669705, alpha: 1)

    }

    func setConstraintForContainerStackViews(seatNumbers: UIStackView, stackViewABC: UIStackView, stackViewDEF: UIStackView, leftLetters: UIStackView, rightLetters: UIStackView, lbl: UILabel) {
        contentView.addSubview(stackViewABC)
        NSLayoutConstraint(item: stackViewABC, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: constants.viewSize).isActive = true
        NSLayoutConstraint(item: stackViewABC, attribute: .centerX, relatedBy: .equal, toItem: leftLetters, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackViewABC, attribute: .centerY, relatedBy: .equal, toItem: lbl, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true

        contentView.addSubview(stackViewDEF)
        NSLayoutConstraint(item: stackViewDEF, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: constants.viewSize).isActive = true
        NSLayoutConstraint(item: stackViewDEF, attribute: .centerX, relatedBy: .equal, toItem: rightLetters, attribute: .centerX, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: stackViewDEF, attribute: .centerY, relatedBy: .equal, toItem: lbl, attribute: .centerY, multiplier: 1.0, constant: 0.0).isActive = true
    }

    func viewTapped(view: UIView, email: String) {
        let ac = UIAlertController(title: "This seat is reserved by \(email)", message: nil, preferredStyle: .alert)
        ac.message = "Feel free to start a conversation with this user"

        let contactAction = UIAlertAction(title: "Contact", style: .default) {_ in
            print("Not implemented yet. This will open the chat")
        }
        let exchangeAggreementAction = UIAlertAction(title: "Exchange Agreement", style: .default) {_ in
            print("Not implemented yet. This will open the Exchange Agreement tab")
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        ac.addAction(contactAction)
        ac.addAction(exchangeAggreementAction)
        ac.addAction(cancelAction)
        present(ac, animated: true)
    }

}
