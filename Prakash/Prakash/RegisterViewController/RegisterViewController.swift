//
//  RegisterViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 04/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPetName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var tfPhone: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func Action_On_Submit(_ sender: Any) {
        
        if (tfName.text?.isEmpty)!{
            UIAlertController.showAlertError(message: "Please enter your name.")
            return
        }
        apiCallRegister()
    }
    
    func apiCallRegister(){
        let apiName = APIName.signUp
        let fcmToken = (UserDefaults.standard.value(forKey: "fcmToken") as? String) ?? "123456"
        let param = ["name" : tfName.text?.trim(), "patname" : tfPetName.text?.trim(),"city" : tfCity.text?.trim(),"mobileno" : tfPhone.text?.trim(),"fcmtoken" : fcmToken]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                //_id
                UserDefaults.standard.set((response!["data"] as? [String : Any] ?? [String : Any]())["_id"], forKey: "userId")
                UserDefaults.standard.set(strongSelf.tfName.text?.trim(), forKey: "name")
                UserDefaults.standard.set(strongSelf.tfPetName.text?.trim(), forKey: "petname")
                UserDefaults.standard.set(strongSelf.tfPhone.text?.trim(), forKey: "mobileno")
                UserDefaults.standard.set(strongSelf.tfCity.text?.trim(), forKey: "city")
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                appDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
                
            }
        }
    }
}

extension RegisterViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
