//
//  AddVideoAdViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 14/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddVideoAdViewController: UIViewController {
    
    @IBOutlet weak var tfNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    @IBAction func Action_OnSubmit(_ sender: UIButton) {
        
        if (tfName.text?.length)! < 1{
            UIAlertController.showAlertError(message: "Please enter name.")
            return
        }
        if (tfNumber.text?.length)! != 10{
            UIAlertController.showAlertError(message: "Please enter valid number.")
            return
        }
        if ((tfCity.text?.length)!) < 1{
            UIAlertController.showAlertError(message: "Please enter city.")
            return
        }
        let param = ["title" : tfCity.text?.trim(),
                     "name": tfName.text?.trim(),
                     "number" : tfNumber.text?.trim(),
                     "desc":"",
                     "image1": "0","image2": "0","image3": "0","type":"video"]
        
        let apiName = APIName.pressNote
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    UIAlertController.showAlert(message: "Your request submitted successfully",complition: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    UIAlertController.showAlert(message: message,complition: {
                        //self?.navigationController?.popViewController(animated: true)
                    })
                }
            }
            
        }
    }
        
}
