import UIKit
import MapKit

final class BankLocatorMapViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BankLocatorMapViewModel!
    
    //MARK: - Private Properties
    private let mapView = MKMapView()
    private let locationManager = CLLocationManager()
    
    // MARK: - UI Properties
    let showLocationButton = UIButton()
    let titleLabel = UILabel()
    let updateMapButton = UIButton(type: .system)
    //let delete = UIButton() // Удалить по окончанию!!!🚨🚨🚨🚨🚨🚨🚨🚨🚨🚨
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        setStartLocation()
        addingBankLocations()
        geolocationEnabling()
        configureUI()
        showMyGeolocation()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(titleLabel)
        view.addSubview(updateMapButton)
        mapView.addSubview(showLocationButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        updateMapButton.translatesAutoresizingMaskIntoConstraints = false
        updateMapButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        updateMapButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -26).isActive = true
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        showLocationButton.translatesAutoresizingMaskIntoConstraints = false
        showLocationButton.trailingAnchor.constraint(equalTo: mapView.trailingAnchor, constant: -40).isActive = true
        showLocationButton.bottomAnchor.constraint(equalTo: mapView.bottomAnchor, constant: -40).isActive = true
        showLocationButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        showLocationButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func configureUI() {
        view.backgroundColor = UIColor(resource: .Color.backgroundColorView)
        
        titleLabel.text = "Location"
        titleLabel.textColor = .black
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        updateMapButton.tintColor = .black
        updateMapButton.setImage(UIImage(named: "updateMap"), for: .normal)
        updateMapButton.contentMode = .scaleAspectFit
        updateMapButton.addTarget(self, action: #selector(rightBarButtonItemTapped), for: .touchUpInside)
        
        let configuratorForCurrentLocation = UIImage.SymbolConfiguration(
            pointSize: 40,
            weight: .medium,
            scale: .large
        )
        let imageCurrentLocation = UIImage(systemName: "location.circle.fill", withConfiguration: configuratorForCurrentLocation)
        showLocationButton.setImage(imageCurrentLocation, for: .normal)
    }
    
    //MARK: - Set start location
    private func setStartLocation() {
        let location = CLLocationCoordinate2D(latitude: 53.904541, longitude: 27.561523)
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 15000,
            longitudinalMeters: 15000
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    //MARK: - Adding bank locations
    private func addingBankLocations() {
        let firstBankBranch = MKPointAnnotation()
        firstBankBranch.coordinate = CLLocationCoordinate2D(latitude: 53.916424, longitude: 27.537729)
        firstBankBranch.title = "TBank отделение №1"
        firstBankBranch.subtitle = "проспект Победителей, 8"
        mapView.addAnnotation(firstBankBranch)
        
        let secondBankBranch = MKPointAnnotation()
        secondBankBranch.coordinate = CLLocationCoordinate2D(latitude: 53.896841, longitude: 27.555615)
        secondBankBranch.title = "TBank отделение №2"
        secondBankBranch.subtitle = "ул. Карла Маркса, 12"
        mapView.addAnnotation(secondBankBranch)
        
        let thirdBankBranch = MKPointAnnotation()
        thirdBankBranch.coordinate = CLLocationCoordinate2D(latitude: 53.858723, longitude: 27.671632)
        thirdBankBranch.title = "TBank отделение №3"
        thirdBankBranch.subtitle = "пр-т Партизанский, 150/22"
        mapView.addAnnotation(thirdBankBranch)
        
        let fourthBankBranch = MKPointAnnotation()
        fourthBankBranch.coordinate = CLLocationCoordinate2D(latitude: 53.861322, longitude: 27.478904)
        fourthBankBranch.title = "TBank отделение №4"
        fourthBankBranch.subtitle = "пр-т Газеты Правда, 29"
        mapView.addAnnotation(fourthBankBranch)
        
        let fifthBankBranch = MKPointAnnotation()
        fifthBankBranch.coordinate = CLLocationCoordinate2D(latitude: 53.887078, longitude: 27.534887)
        fifthBankBranch.title = "TBank отделение №5"
        fifthBankBranch.subtitle = "ул. Фабрициуса, 28"
        mapView.addAnnotation(fifthBankBranch)
    }
    
    //MARK: - Geolocation enabling.
    func geolocationEnabling() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
    }
    
    func showMyGeolocation() {
        showLocationButton.addAction(UIAction(handler: { _ in
            guard let coordinate = self.locationManager.location?.coordinate else { return }
            let coordinateRegion = MKCoordinateRegion(
                center: coordinate,
                latitudinalMeters: 250,
                longitudinalMeters: 250
            )
            self.mapView.setRegion(coordinateRegion, animated: true)
        }), for: .touchUpInside)
    }
    
    private func bindings() {
        
    }
    
    @objc func rightBarButtonItemTapped() {
        viewModel.exchangeRatesButtonTapped()
    }
    
}
