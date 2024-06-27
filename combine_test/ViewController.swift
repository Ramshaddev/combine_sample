//
//  ViewController.swift
//  combine_test
//
//  Created by artmac on 26/06/24.
//

import UIKit
import Combine

class ViewController: UIViewController{

    @IBOutlet weak var termsAndConditionSwitch: UISwitch!
    @IBOutlet weak var privacyPolicySwitch: UISwitch!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var button: UIButton!
    
    //publishers
    @Published private var acceptedTerms = false
    @Published private var acceptedPrivacy = false
    @Published private var name = ""
    
    //combine publishers in to single stream
    private var validToSubmit: AnyPublisher<Bool, Never>{
        return Publishers.CombineLatest3($acceptedTerms, $acceptedPrivacy, $name).map{ terms, privacy, name in
            return terms && privacy && !name.isEmpty
            
        }.eraseToAnyPublisher()
    }
    
    //define subscriber
    private var buttonSubscriber: AnyCancellable?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameTextField.delegate = self
    
        //subscribe
        buttonSubscriber = validToSubmit.receive(on: RunLoop.main).assign(to: \.isEnabled, on: button)
    }

    @IBAction func termsAction(_ sender: UISwitch) {
        acceptedTerms = sender.isOn
    }
    
    @IBAction func privacyAction(_ sender: UISwitch) {
        acceptedPrivacy = sender.isOn
    }
    
    @IBAction func nameChanged(_ sender: UITextField) {
        name = sender.text ?? ""
    }
    
    @IBAction func submitAction(_ sender: Any) {
    }
}

extension UIViewController: UITextFieldDelegate{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

