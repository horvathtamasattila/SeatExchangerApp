//
//  SelectSeatsViewController.swift
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

protocol SelectSeatsDisplayLogic: class {
    func fetchDataFromPreviousViewController(viewModel: ListFlights.SelectSeatsData.ViewModel)
    func displayData(viewModel: SelectSeats.DisplayData.ViewModel)
    func displayPickerView(viewModel: SelectSeats.PickerDataModel.ViewModel)
    func displaySuccessfulSeatUpdate(response: SelectSeats.UpdateSeat.Response)
    func displayUnsuccessfulSeatUpdate(response: SelectSeats.UpdateSeat.Response)
    func routeToCheckSeats(dataModel: SelectSeats.StoredData.CheckSeatsModel)
}

class SelectSeatsViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, SelectSeatsDisplayLogic {

    @IBOutlet weak var updateButton: CustomButton!
    @IBOutlet weak var destinationImageView: CustomImageView!
    @IBOutlet var backgroundView: UIView!
    @IBOutlet weak var flightNr: UILabel!
    @IBOutlet weak var flightLogo: UIImageView!
    @IBOutlet weak var seat1Picker: UIPickerView!
    var spinnerView: UIView!
    var ai: UIActivityIndicatorView!
    var viewModel = SelectSeats.PickerDataModel.ViewModel()

  var interactor: SelectSeatsBusinessLogic?
  var router: (NSObjectProtocol & SelectSeatsRoutingLogic & SelectSeatsDataPassing)?

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
    let interactor = SelectSeatsInteractor()
    let presenter = SelectSeatsPresenter()
    let router = SelectSeatsRouter()
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
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
    setSpinnerView()
    interactor?.requestDisplayData(request: SelectSeats.DisplayData.Request())
    interactor?.requestPickerInitialization(request: SelectSeats.PickerDataSource.Request())
  }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setBackground()
        backgroundView.bringSubviewToFront(backgroundView.subviews[0])
        updateButton.setupButton()
    }

    //Fetch functions
    func fetchDataFromPreviousViewController(viewModel: ListFlights.SelectSeatsData.ViewModel) {
        interactor?.pushDataFromPreviousViewController(viewModel: viewModel)
    }

    //Display functions
    func displayData(viewModel: SelectSeats.DisplayData.ViewModel) {
        flightNr.text = viewModel.flightNumber
        flightLogo.image = viewModel.image
    }

    func displayPickerView(viewModel: SelectSeats.PickerDataModel.ViewModel) {
        self.viewModel.pickerData = viewModel.pickerData
        self.viewModel.pickerDataNumbers = viewModel.pickerDataNumbers
        seat1Picker.delegate = self
        seat1Picker.dataSource = self
        seat1Picker.selectRow((viewModel.maxElements / 2) - 8, inComponent: 0, animated: false)
        seat1Picker.selectRow((viewModel.maxElements / 2) - 2, inComponent: 1, animated: false)
        self.viewModel.selectedSeatNumber = "\(self.viewModel.pickerData[0][seat1Picker.selectedRow(inComponent: 0) % self.viewModel.pickerData[0].count])\(self.viewModel.pickerData[1][seat1Picker.selectedRow(inComponent: 1) % self.viewModel.pickerData[1].count])"
    }

    func displaySuccessfulSeatUpdate(response: SelectSeats.UpdateSeat.Response) {
        self.removeSpinner(spinnerView: spinnerView, ai: ai)
        displayAlertController(title: "Success", message: "Seat \(response.selectedSeatNumber!) updated successfully")
        let request = SelectSeats.StoredData.Request()
        interactor?.pushJustSelectedSeatState(request: request)
    }

    func displayUnsuccessfulSeatUpdate(response: SelectSeats.UpdateSeat.Response) {
        self.removeSpinner(spinnerView: spinnerView, ai: ai)
        displayAlertController(title: "Fail", message: "Operation failed: \(response.errorMessage ?? "No details are available")")
    }

    // MARK: Local functions

    @IBAction func updateSeats(_ sender: Any) {
        showSpinner(view: self.view, spinnerView: spinnerView, ai: ai)
        var request = SelectSeats.UpdateSeat.Request()
        request.selectedSeatNumber = viewModel.selectedSeatNumber
        interactor?.requestUpdateSeat(request: request)
    }

    @objc func doneButtonPressed() {
            interactor?.requestCheckSeatsData(request: SelectSeats.StoredData.Request())
    }

    func displayAlertController(title: String, message: String) {
        DispatchQueue.main.async {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Ok", style: .cancel)
            ac.addAction(cancelAction)
            self.present(ac, animated: true)
        }
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.maxElements
    }

    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return self.view.frame.width * viewModel.rowHeightConstant
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return self.view.frame.width * viewModel.widthForComponentConstant
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        viewModel.selectedSeatNumber = "\(viewModel.pickerData[0][seat1Picker.selectedRow(inComponent: 0) % viewModel.pickerData[0].count])\(viewModel.pickerData[1][seat1Picker.selectedRow(inComponent: 1) % viewModel.pickerData[1].count])"
    }

    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont(name: "Helvetica", size: (self.view.frame.height * 0.0516))
            pickerLabel?.textAlignment = .center
        }
        let myRow = row % viewModel.pickerData[component].count
        pickerLabel?.text = viewModel.pickerData[component][myRow]
        return pickerLabel!
    }

    private func setSpinnerView() {
        spinnerView = UIView.init(frame: self.view.bounds)
        ai = UIActivityIndicatorView.init(style: .whiteLarge)
    }

    private func setBackground() {
        setGradientBackground()
        setCloudImage()
    }

    private func setCloudImage() {
        let imageLayer = CALayer()
        assert(UIImage(named: "clouds_bottom_2") != nil)
        let cloudsBackground = UIImage(named: "clouds_bottom_2")!.cgImage
        imageLayer.contents = cloudsBackground
        imageLayer.frame = view.bounds
        backgroundView.layer.addSublayer(imageLayer)
        view.sendSubviewToBack(backgroundView)
    }

    private func setGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.frame = view.bounds
        gradientLayer.colors = [(#colorLiteral(red: 0.4068969488, green: 0.5874248147, blue: 0.8163669705, alpha: 1)).cgColor, (#colorLiteral(red: 0.8379636407, green: 0.8866117001, blue: 0.9216472507, alpha: 1)).cgColor]
        gradientLayer.masksToBounds = false
        backgroundView.layer.addSublayer(gradientLayer)
    }

    // MARK: - Temporary routing

    func routeToCheckSeats(dataModel: SelectSeats.StoredData.CheckSeatsModel) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "CheckSeats") as? CheckSeatsViewController {
            vc.fetchDataFromPreviousViewController(viewModel: dataModel)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}
