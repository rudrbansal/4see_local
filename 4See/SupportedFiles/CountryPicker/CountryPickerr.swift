//
//  CountryPickerr.swift
//  4See
//
//  Created by Gagan Arora on 19/03/21.
//

import UIKit
import CountryPicker

class CountryPickerr: UIViewController {

    @IBOutlet weak var picker: CountryPicker!
    var dismissCountryPicker: ((Bool,CountrySelectModel) -> Void)?
    
    var viewModel = CountrySelectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        picker.setCountryByPhoneCode("+\(viewModel.country?.phoneCode ?? "+91")")
    }
    @IBAction func actionDismiss(_ sender: UIButton) {
        if sender.tag == 1 {
            self.dismissCountryPicker?(false, self.viewModel.country!)
        } else {
            self.dismissCountryPicker?(true, self.viewModel.country!)
        }
    }
}
extension CountryPickerr : CountryPickerDelegate {
    // MARK: - CountryPhoneCodePicker Delegate
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        viewModel.country = CountrySelectModel.init(name: name, countryCode: countryCode, phoneCode: phoneCode)
    }
}
