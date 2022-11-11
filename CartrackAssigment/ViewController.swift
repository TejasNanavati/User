//
//  ViewController.swift
//  CartrackAssigment
//
//  Created by Tejas Nanavati on 08/11/22.
//

import UIKit

class ViewController: UIViewController,CAAnimationDelegate {
    
    
    @IBOutlet weak var usernameTxt: UITextField!
    @IBOutlet weak var passwordTxt: UITextField!
    @IBOutlet weak var loginBtn: UIButton!
    @IBOutlet weak var countryPickrerView: UIPickerView!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var countryBtn: UIButton!
    var countries: [String] = []

    
    var viewModel = LoginViewModel()


    // MARK: - Life cycle

    override func viewDidLoad() {
        
        displayView(isHidden: true)
        getCountries()
        SetUpVieWithAttribution()
        setTextFieldDelegate()
        setPicketViewDelegateAndDataSource()
        super.viewDidLoad()
    }
    
    // MARK: - SetUpVieWithAttribution

    func SetUpVieWithAttribution(){
        self.view.backgroundColor = .gray
        self.loginBtn.layer.cornerRadius = 10.0
        self.countryBtn.layer.cornerRadius = 10.0
        self.toolBar.backgroundColor = .systemGray
        usernameTxt.attributedPlaceholder = NSAttributedString(string:"username", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        passwordTxt.attributedPlaceholder = NSAttributedString(string:"password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        pulsate()
    }
    
    // MARK: - Animation

    func rotateButton(){
        let fullRotation = CABasicAnimation(keyPath: "transform.rotation")
        fullRotation.delegate = self
        fullRotation.fromValue = NSNumber(floatLiteral: 0)
        fullRotation.toValue = NSNumber(floatLiteral: Double(CGFloat.pi * 2))
        fullRotation.duration = 1
        fullRotation.repeatCount = 2
        loginBtn.layer.add(fullRotation, forKey: "360")
    }
    
   
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.98
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.5
        pulse.damping = 1.0
        self.countryBtn.layer.add(pulse, forKey: nil)
    }
    // MARK: - Set Delegate and DataSource

    func setTextFieldDelegate(){
        usernameTxt.delegate = self
        passwordTxt.delegate = self
       
    }
    
    
    func setPicketViewDelegateAndDataSource(){
        countryPickrerView.delegate = self
        countryPickrerView.dataSource = self
    }
    
    // MARK: - Hide/Show Views

    func displayView(isHidden:Bool){
        countryPickrerView.isHidden = isHidden
        toolBar.isHidden = isHidden
    }
    
    

    // MARK: - Button Actions

    @IBAction func loginBtnPressed(_ sender: Any) {
        viewModel.validateInput(usernameTxt.text, password: passwordTxt.text) { [weak self] (success, message) in
            if success {
                self?.rotateButton()
                self?.validateUser()
            } else {
                self?.showAlert("Error!", message: message!, actions: ["Ok"]) { (actionTitle) in
                    print(actionTitle)
                }
            }
        }

    }
    
    @IBAction func countryBtnPressed(_ sender: Any) {
        pulsate()
        displayView(isHidden: false)
    }
    
    @IBAction func donePressed(_ sender: Any) {
        displayView(isHidden: true)
        self.countryBtn.layer.removeAllAnimations()
    }
    
    // MARK: - Validate User

    func allowAnimation(){
        let seconds = 2.1
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds){
            let request = LoginRequestModel(username: self.usernameTxt.text!, password: self.passwordTxt.text!)
            self.viewModel.login(request) { (responseModel) in
                if responseModel.success {
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserListViewController") as? UserListViewController {
                       
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                } else {
                    self.showAlert("Error!", message: responseModel.errorMessage ?? "", actions: ["Ok"]) { (actionTitle) in
                        print(actionTitle)
                    }
                }
            }
        }
    }
    private func validateUser() {
        allowAnimation()
        
    }

    
    // MARK: - Get Country List
    func getCountries() {

        for code in NSLocale.isoCountryCodes  {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_UK").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        print(countries)

    }
    
}

// MARK: - TextField Delegate

extension ViewController:UITextFieldDelegate  {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

// MARK: - PickerView Delegate & DataSource

extension ViewController: UIPickerViewDelegate,UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: countries[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let country = self.countries[row]
        return country
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let country = self.countries[row]
        countryBtn.setTitle(country, for: .normal)
    }
    

    
    
    
}

// MARK: - ShowAlert

extension UIViewController {
    func showAlert(_ title: String, message: String, actions: [String], completion: @escaping ((String) -> Void)) {
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        for title in actions {
            controller.addAction(UIAlertAction.init(title: title, style: .default, handler: { _ in
                completion(title)
            }))
        }
        self.present(controller, animated: true, completion: nil)
    }
}
