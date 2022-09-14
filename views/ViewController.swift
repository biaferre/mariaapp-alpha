//
//  ViewController.swift
//  marIA
//
//  Created by Bof on 23/04/22.
//

import UIKit
import GooglePlaces
import MapKit
import CoreLocation
import MessageUI
import AuthenticationServices

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ASAuthorizationControllerDelegate, MFMessageComposeViewControllerDelegate {
    
    var routeMap = MKMapView()
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        // organizacao inicial das views
            super.viewDidLoad()

             let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))


            view.addGestureRecognizer(tap)
        
        let appleConfig = UIImage.SymbolConfiguration(pointSize: 74, weight: .bold, scale: .large)
        let largeBoldApple = UIImage(systemName: "applelogo", withConfiguration: appleConfig)
        self.signin.setImage(largeBoldApple, for: .normal)
        
        loginpage.isHidden = false
        lowbar.isHidden = true
        Home.isHidden = true
        menubar.isHidden = true
        setroute.isHidden = true
        setcontacts.isHidden = true
        confirmbar.isHidden = true
        ongoingroute.isHidden = true
        review.isHidden = true
        popUpContacts.isHidden = true
        setdetails.isHidden = true
        maxContactWarning.isHidden = true
        checkIn.isHidden = true
        checkInSecond.isHidden = true
        checkInThird.isHidden = true
        missingArea.isHidden = true
        
        furtherDelayView.isHidden = true
        furtherDelayView2.isHidden = true
        
        emptyList.isHidden = false
        emptyListIcon.isHidden = false
        contactPrint.isHidden = true
        contactN.isHidden = true
        
        maxContactWarning.layer.cornerRadius = 24
        popUpContacts.layer.cornerRadius = 24
        checkIn.layer.cornerRadius = 24
        missingArea.layer.cornerRadius = 24
        checkInSecond.layer.cornerRadius = 24
        checkInThird.layer.cornerRadius = 24
        
        
        createMapView()
        checkLocationServices()
        
        routeMap.isHidden = true
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func authButton(_ sender: UIButton) {
        handleAppleIDRequest()
    }
    
    @objc func handleAppleIDRequest() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        
        request.requestedScopes = [.fullName,.email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        
        authorizationController.delegate = self
        
        authorizationController.performRequests()
    }
    
    let formatter = PersonNameComponentsFormatter()
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let fullName = appleIDCredential.fullName
            userName.text = fullName?.givenName
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("Erro de validação")
    }

    @IBOutlet var signin: UIButton!
    
    // views:
    
    @IBOutlet var lowbar: UIView!
    @IBOutlet var loginpage: UIView!
    @IBOutlet var Home: UIView!
    @IBOutlet var menubar: UIView!
    @IBOutlet var setroute: UIView!
    @IBOutlet var setcontacts: UIView!
    @IBOutlet var setdetails: UIView!
    @IBOutlet var confirmbar: UIView!
    @IBOutlet var ongoingroute: UIView!
    @IBOutlet var review: UIView!
    @IBOutlet var popUpContacts: UIView!
    @IBOutlet var maxContactWarning: UIView!
    @IBOutlet var checkIn: UIView!
    @IBOutlet var checkInSecond: UIView!
    @IBOutlet var checkInThird: UIView!
    @IBOutlet var missingArea: UIView!
    
    // botões de navegacao:
    // home -> setroute
    @IBOutlet var startJourney: UIButton!
    // setroute -> contacts
    @IBOutlet var goToContacts: UIButton!
    // contacts -> details
    @IBOutlet var goToDetails: UIButton!
    // details -> confirmbar
    @IBOutlet var goToConfirmation: UIButton!
    // confirmbar -> ongoingroute
    @IBOutlet var goToOngoing: UIButton!
    // ongoingroute -> review
    @IBOutlet var finish: UIButton!
    @IBOutlet var routeFromMenu: UIButton!
    @IBOutlet var contactsFromMenu: UIButton!
    @IBOutlet var finishFromMenu: UIButton!
    
    
    // botoes e labels de mapa
    @IBOutlet var startMap: UIButton!
    @IBOutlet var endMap: UIButton!
    @IBOutlet var detail1: UILabel!
    @IBOutlet var detail2: UILabel!
    @IBOutlet var userName: UILabel!
    
    // info a usar p/ notificacao
    @IBOutlet var contactName: UITextField!
    @IBOutlet var contactNumber: UITextField!
    var timer = Timer()
    var newtimer = Timer()
    var finaltimer = Timer()
    var initial = 0
    var sec: Bool! = false
    var thi: Bool! = false
    
    var timeRemaining: Int!
    
    @IBAction func showMissing(_ sender: UIButton!) {
        missingArea.isHidden = false
        self.view.bringSubviewToFront(missingArea)
    }
    @IBAction func closeMissing(_ sender: UIButton) {
        missingArea.isHidden = true
    }
    
    func getExpectedTime() -> Int{
        // retorna total do tempo esperado pra rota em segundos
        return Int(countDown0.countDownDuration)
    }
    
    @objc func firstCount() {
        initial += 1
        print("contando")
        if (initial == 1) {
            initial = 0
            print("fodase")
            routeMap.isHidden = true
            getScreen(checkIn)
            timer.invalidate()
        }
    }
    
    @objc func secondCount() {
        initial += 1
        if initial == 900 {
            initial = 0
            print("fodase dnv")
            routeMap.isHidden = true
            getScreen(checkInSecond)
            newtimer.invalidate()
        }
    }
    
    @objc func thirdCount() {
        initial += 1
        if initial == 1800 {
            initial = 0
            print("fodase ultimo")
            routeMap.isHidden = true
            getScreen(checkInThird)
            finaltimer.invalidate()
        }
    }
    
    func getScreen(_ screen: UIView!) {
        screen.isHidden = false
        
    }
    
    
    // funcoes pra view management:
    @IBAction func openMenu(_ sender: UIButton!) {
        menubar.isHidden = false
        if Home.isHidden == false {
            lowbar.isHidden = true
        }
    }
    
    
    @IBAction func emergencyMenu(_ sender: UIButton) {
        if let url = URL(string: "tel://\(190)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(url)) {
                application.open(url, options: [:], completionHandler: nil)
            }
        }
    }

    @IBAction func closeMenu(_ sender: UIButton!) {
        menubar.isHidden = true
        if Home.isHidden == false {
            lowbar.isHidden = false
        }
    }
    
    @IBAction func backToStart(_ sender: UIButton!) {
        // volta p/ home
        loginpage.isHidden = true
        Home.isHidden = false
        menubar.isHidden = true
        setroute.isHidden = true
        setcontacts.isHidden = true
        popUpContacts.isHidden = true
        confirmbar.isHidden = true
        ongoingroute.isHidden = true
        review.isHidden = true
        lowbar.isHidden = false
        setdetails.isHidden = true
        
        routeMap.isHidden = true
    }
    
    @IBAction func login(_ sender: UIButton!) {
        loginpage.isHidden = true
        Home.isHidden = false
        lowbar.isHidden = false
    }
    
    @IBAction func openNextFlow(_ sender: UIButton!) {
        // abre a prox pag no flowchart
        if sender == startJourney || sender == routeFromMenu {
            menubar.isHidden = true
            setroute.isHidden = false
            Home.isHidden = true
            lowbar.isHidden = true
        }
        else if sender == goToContacts || sender == contactsFromMenu {
            menubar.isHidden = true
            Home.isHidden = true
            setcontacts.isHidden = false
            setroute.isHidden = true
            
        }
        else if sender == goToDetails {
            countDown0.setValue(UIColor.black, forKeyPath: "textColor")
            detail1.text = currentLoc.text
            detail2.text = finalLoc.text
            setdetails.isHidden = false
            setcontacts.isHidden = true
        }
        else if sender == goToConfirmation {
            startConfirm.text = currentLoc.text
            endConfirm.text = finalLoc.text
            confirmbar.isHidden = false
            setdetails.isHidden = true
        }
        else if sender == goToOngoing {
            print(getExpectedTime())
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.firstCount), userInfo: nil, repeats: true)
            ongoingroute.isHidden = false
            routeMap.isHidden = false
            startTracking.text = currentLoc.text
            endTracking.text = finalLoc.text
            
            confirmbar.isHidden = true
        }
        else if sender == finish || sender == finishFromMenu {
            timer.invalidate()
            newtimer.invalidate()
            finaltimer.invalidate()
            
            menubar.isHidden = true
            Home.isHidden = true
            routeMap.isHidden = true
            review.isHidden = false
            ongoingroute.isHidden = true
        }
    }
    @IBOutlet var emptyListIcon: UIImageView!
    @IBOutlet var emptyList: UILabel!
    
    // abrir adicao de contatos
    @IBAction func addContact(_ sender: UIButton!) {
        if isFull {
            maxContactWarning.isHidden = false
        }
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveLinear, animations: {
            self.popUpContacts.frame.origin.x = 15
        }) {(completed) in}
        self.setcontacts.backgroundColor = UIColor.gray
        popUpContacts.isHidden = false
    }
    
    @IBOutlet var contactPrint: UILabel!
    @IBOutlet var contactN: UILabel!
    
    var c1 = Contato()
    var isFull: Bool! = false
    @IBOutlet var checkName: UILabel!
    @IBOutlet var checkNum: UILabel!
    @IBOutlet var contNameConfirm: UILabel!
    
    // fechar adicao de contatos
    @IBOutlet var saveButton: UIButton!
    @IBAction func closePopUp(_ sender: UIButton) {
        if sender == saveButton {
            if isFull == false {
                emptyList.isHidden = true
                emptyListIcon.isHidden = true
                c1.addInfo(contactName.text, Int(contactNumber.text!))
                
                contactPrint.text = contactName.text
                contactN.text = contactNumber.text
                contactPrint.isHidden = false
                contactN.isHidden = false
                isFull = true
                checkName.text = c1.name
                checkNum.text = String(c1.num)
                contNameConfirm.text = c1.name
            }
        }
        popUpContacts.isHidden = true
        self.setcontacts.backgroundColor = UIColor.clear
    }
 
    @IBAction func closeMaxWarning(_ sender: UIButton) {
        maxContactWarning.isHidden = true
    }
    
    // labels p/ permitir escolha de mapas
    @IBOutlet var currentLoc: UILabel!
    @IBOutlet var finalLoc: UILabel!
    
    var editableCoordinate: CLLocationCoordinate2D!
    var editableLabel: UILabel!
    var editableStart: UILabel!
    var editableEnd: UILabel!
    
    var startPlace: String!
    var endPlace: String!
    
    @IBOutlet var startConfirm: UILabel!
    @IBOutlet var endConfirm: UILabel!

    @IBOutlet var startTracking: UILabel!
    @IBOutlet var endTracking: UILabel!
    
    
    @objc @IBAction func autocompleteClicked(_ sender: UIButton!) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        
        let fields: GMSPlaceField = GMSPlaceField(rawValue: UInt(GMSPlaceField.name.rawValue) | UInt(GMSPlaceField.placeID.rawValue))
        autocompleteController.placeFields = fields
        
        let filter = GMSAutocompleteFilter()
        filter.type = .address
        autocompleteController.autocompleteFilter = filter
        present(autocompleteController, animated: true, completion: nil)
        
        if sender == startMap {
            editableLabel = currentLoc
        }
        else {
            editableLabel = finalLoc
        }
    }
    
    
    @IBOutlet var countDown0: UIDatePicker!

    
    @IBOutlet var furtherDelayView: UIView!
    @IBOutlet var furtherDelayView2: UIView!
    
    @IBAction func closeFurtherDelay(_ sender: UIButton) {
        furtherDelayView.isHidden = true
        routeMap.isHidden = false
        
        newtimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.secondCount), userInfo: nil, repeats: true)
    }

    @IBAction func closeFurtherDelay2(_ sender: UIButton!) {
        furtherDelayView2.isHidden = true
        routeMap.isHidden = false
        
        finaltimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.thirdCount), userInfo: nil, repeats: true)
    }
    
    @IBAction func openFurtherDelay(_ sender: UIButton) {
        furtherDelayView.isHidden = false
        checkIn.isHidden = true
    }
    @IBAction func openFurtherDelay2(_ sender: Any) {
        checkInSecond.isHidden = true
        furtherDelayView2.isHidden = false
    }
    
    @IBOutlet var emergencyCall: UIButton!
    @IBOutlet var callContact: UIButton!
    
    
    @IBAction func closeLastAlert(_ sender: UIButton) {
        checkInThird.isHidden = true
        routeMap.isHidden = false
        if sender == emergencyCall {
            if let url = URL(string: "tel://\(190)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(url)) {
                    application.open(url, options: [:], completionHandler: nil)
                }
            }
        }
        else if sender == callContact {
            if let url = URL(string: "tel://\(String(describing: c1.num))") {
                    let application:UIApplication = UIApplication.shared
                    if (application.canOpenURL(url)) {
                        application.open(url, options: [:], completionHandler: nil)
                    }
                }
        }
    }
    @IBAction func callContact(_ sender: UIButton) {
        if let url = URL(string: "tel://\(String(describing: c1.num))") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(url)) {
                    application.open(url, options: [:], completionHandler: nil)
                }
            }
    }
    
    @IBAction func sendSMS(_ sender: UIButton!) {
        if (MFMessageComposeViewController.canSendText()){
            let controller = MFMessageComposeViewController()
            controller.body = "Algo está errado! Acompanhe minha rota com atenção..."
            controller.recipients = [String(c1.num)]
            controller.messageComposeDelegate = self
            self.present(controller, animated:true, completion: nil)
            
            if checkIn.isHidden == false {
                checkIn.isHidden = true
            }
            else if checkInSecond.isHidden == false {
                checkInSecond.isHidden = true
            }
            else if checkInThird.isHidden == false {
                checkInThird.isHidden = true
            }

        }
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }

    
    func createMapView() {
        routeMap.frame = CGRect(x: 60, y: 217, width: 294, height: 347)
        routeMap.mapType = MKMapType.standard
        routeMap.isZoomEnabled = true
        routeMap.isScrollEnabled = true
        
        view.addSubview(routeMap)
    }
    
    func checkLocationAuth() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            routeMap.showsUserLocation = true
            followUserLocation()
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            break
        case .denied:
            break
        case .authorizedAlways:
            break
        @unknown default:
            break
        }
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuth()
        }
    }
    
    func followUserLocation() {
        if let location = locationManager.location?.coordinate {
            let region = MKCoordinateRegion.init(center: location, latitudinalMeters: 4000, longitudinalMeters: 4000)
            routeMap.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuth()
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let region = MKCoordinateRegion.init(center: location.coordinate, latitudinalMeters: 4000, longitudinalMeters: 4000)
        routeMap.setRegion(region, animated: true)
    }
    
}


extension ViewController: GMSAutocompleteViewControllerDelegate {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Local: \(String(describing: place.name))")
        editableLabel.text = place.name
        print("ID: \(String(describing: place.placeID))")
        print("Atribuições: \(String(describing: place.attributions))")
        dismiss(animated: true, completion: nil)
        editableCoordinate = place.coordinate
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // lida com erro? (printar popup?)
        print("Error :", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}
