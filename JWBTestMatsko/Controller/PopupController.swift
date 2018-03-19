//
//  PopupController.swift
//  JWBTestMatsko
//
//  Created by Mykola Matsko on 3/17/18.
//  Copyright © 2018 Mykola Matsko. All rights reserved.
//

import UIKit

protocol PopupDelegate {
    func getTextFromLocale(code: String)
}

extension PopupController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return localCodes.count
    }
    
    //UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return localCodes[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        code = self.localCodes[row]
    }
}

class PopupController: UIViewController {
    
    var delegatePop: PopupDelegate?
    var code: String = ""
    
    let localCodes = ["bg_BG", "da_DK", "el_GR", "en_NG", "en_ZA", "fi_FI", "he_IL", "ka_GE", "me_ME", "nl_NL", "pt_PT", "sr_Cyrl_RS", "tr_TR", "zh_TW", "ar_JO", "en_AU", "en_NZ", "es_AR", "hr_HR", "kk_KZ", "ro_MD", "sr_Latn_RS", "uk_UA", "ar_SA", "bn_BD", "de_AT", "en_CA", "en_PH", "es_ES", "fr_BE", "is_IS", "ko_KR", "mn_MN", "ro_RO", "sr_RS", "at_AT", "de_CH", "en_GB", "en_SG", "es_PE", "fr_CA", "hu_HU", "it_CH", "nb_NO", "ru_RU", "sv_SE", "de_DE", "en_HK", "en_UG", "es_VE", "fr_CH", "hy_AM", "it_IT", "lt_LT", "ne_NP", "pl_PL", "sk_SK", "vi_VN", "cs_CZ", "el_CY", "en_IN", "en_US", "fa_IR", "fr_FR", "id_ID", "ja_JP", "lv_LV", "nl_BE", "pt_BR", "sl_SI", "th_TH", "zh_CN"]
    
    let inputsContainerViewPopup: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let selectLabelView: UILabel = {
        let label = UILabel()
        label.backgroundColor = .red
        label.text = "Select local code"
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var pickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.backgroundColor = .white
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    let chooseButton: UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.setTitle("Choose", for: UIControlState.normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleChooseButton), for: UIControlEvents.touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 0.5)
        view.addSubview(inputsContainerViewPopup)
        
        
        inputsContainerViewPopup.addSubview(selectLabelView)
        inputsContainerViewPopup.addSubview(chooseButton)
        inputsContainerViewPopup.addSubview(pickerView)
        
        setupContainerView()
        
    }
    
    @objc func handleChooseButton() {
        dismiss(animated: true) {
            print("---\(self.code)---")
            self.delegatePop?.getTextFromLocale(code: self.code)
        }
    }
    
    func setupContainerView() {
        inputsContainerViewPopup.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsContainerViewPopup.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsContainerViewPopup.widthAnchor.constraint(equalToConstant: 350).isActive = true
        inputsContainerViewPopup.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        selectLabelView.topAnchor.constraint(equalTo: inputsContainerViewPopup.topAnchor).isActive = true
        selectLabelView.leadingAnchor.constraint(equalTo: inputsContainerViewPopup.leadingAnchor).isActive = true
        selectLabelView.trailingAnchor.constraint(equalTo: inputsContainerViewPopup.trailingAnchor).isActive = true
        selectLabelView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        chooseButton.bottomAnchor.constraint(equalTo: inputsContainerViewPopup.bottomAnchor).isActive = true
        chooseButton.leadingAnchor.constraint(equalTo: inputsContainerViewPopup.leadingAnchor).isActive = true
        chooseButton.trailingAnchor.constraint(equalTo: inputsContainerViewPopup.trailingAnchor).isActive = true
        chooseButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        pickerView.topAnchor.constraint(equalTo: selectLabelView.bottomAnchor).isActive = true
        pickerView.leadingAnchor.constraint(equalTo: inputsContainerViewPopup.leadingAnchor).isActive = true
        pickerView.trailingAnchor.constraint(equalTo: inputsContainerViewPopup.trailingAnchor).isActive = true
        pickerView.bottomAnchor.constraint(equalTo: chooseButton.topAnchor).isActive = true
        
    }
}
