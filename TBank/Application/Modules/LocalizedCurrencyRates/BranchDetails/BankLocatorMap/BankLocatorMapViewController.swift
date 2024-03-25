import UIKit
import MapKit

final class BankLocatorMapViewController: UIViewController {
    
    // MARK: - Public Properties
    var viewModel: BankLocatorMapViewModel!
    
    //MARK: - Private Properties
    private let locationManager = CLLocationManager()
    
    // MARK: - UI Properties
    private let showLocationButton = UIButton()
    private let titleLabel = UILabel()
    private let addressOfBankBranchLabel = UILabel()
    private let mapView = MKMapView()
    private let updateMapButton = UIButton(type: .system)
    
    // MARK: - LyfeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureConstraints()
        setStartLocation()
        addBankLocations()
        geolocationEnabling()
        configureUI()
        showMyGeolocation()
    }
    
    // MARK: - Methods
    private func addSubviews() {
        view.addSubview(mapView)
        view.addSubview(titleLabel)
        view.addSubview(updateMapButton)
        view.addSubview(addressOfBankBranchLabel)
        mapView.addSubview(showLocationButton)
    }
    
    private func configureConstraints() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 40).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        updateMapButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel).offset(10)
            make.trailing.equalTo(view.snp.trailing).inset(24)
            make.width.equalTo(55)
            make.height.equalTo(55)
        }
        
        addressOfBankBranchLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(2)
            make.centerX.equalToSuperview()
        }
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: addressOfBankBranchLabel.bottomAnchor, constant: 20).isActive = true
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
        
        titleLabel.text = NSLocalizedString("App.LocalizedCurrencyRates.BankLocatorMap.NavigationItemTitle", comment: "")
        titleLabel.textColor = UIColor(resource: .Color.textColorTitel)
        titleLabel.font = UIFont.manrope(ofSize: 24, style: .bold)
        
        updateMapButton.backgroundColor = UIColor(resource: .Color.backgroundColorItem)
                updateMapButton.tintColor = UIColor(resource: .Color.textColorTitel)
        updateMapButton.layer.cornerRadius = 27.5
        updateMapButton.setImage(UIImage(systemName: "arrow.triangle.2.circlepath"), for: .normal)
                let symbolConfigurationAdd = UIImage.SymbolConfiguration(pointSize: 28)
                updateMapButton.setPreferredSymbolConfiguration(symbolConfigurationAdd, forImageIn: .normal)
        updateMapButton.addTarget(self, action: #selector(rightBarButtonItemTapped), for: .touchUpInside)
        
        addressOfBankBranchLabel.text = "\(NSLocalizedString("App.LocalizedCurrencyRates.BankLocatorMap.SecondNavigationItemTitle", comment: "")) \(NSLocalizedString("App.Addresses.\(viewModel.bankBranch.address ?? "")", comment: ""))"
        addressOfBankBranchLabel.font = UIFont.manrope(ofSize: 15, style: .bold)
        addressOfBankBranchLabel.textColor = UIColor(resource: .Color.LocalizedCurrencyRates.BranchDetails.ExchangeRates.secondTextTitle)
        
        let configuratorForCurrentLocation = UIImage.SymbolConfiguration(
            pointSize: 40,
            weight: .medium,
            scale: .large
        )
        let imageCurrentLocation = UIImage(systemName: "location.circle.fill", withConfiguration: configuratorForCurrentLocation)
        showLocationButton.setImage(imageCurrentLocation, for: .normal)
        showLocationButton.tintColor = UIColor(resource: .Color.textColorTitel)
    }
    
    private func setStartLocation() {
        let location = CLLocationCoordinate2D(latitude: viewModel.bankBranch.latitude, longitude: viewModel.bankBranch.longitude)
        let coordinateRegion = MKCoordinateRegion(
            center: location,
            latitudinalMeters: 5000,
            longitudinalMeters: 5000
        )
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func addBankLocations() {
        for bank in viewModel.bankBranches {
            let bankBranch = MKPointAnnotation()
            bankBranch.coordinate = CLLocationCoordinate2D(latitude: bank.latitude, longitude: bank.longitude)
            bankBranch.title = "\(NSLocalizedString("App.LocalizedCurrencyRates.BankLocatorMap.MapPointTitle", comment: ""))\(bank.branchNumber!)"
            bankBranch.subtitle = (NSLocalizedString("App.Addresses.\(bank.address ?? "")", comment: ""))
            mapView.addAnnotation(bankBranch)
        }
    }
    
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
    
    @objc func rightBarButtonItemTapped() {
        viewModel.exchangeRatesButtonTapped()
    }
}
