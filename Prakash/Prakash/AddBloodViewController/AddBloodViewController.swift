//
//  AddBloodViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 14/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddBloodViewController: UIViewController {

    @IBOutlet weak var btnCity: UIButton!
    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnBloodGroup: UIButton!
    @IBOutlet weak var tfNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    @IBOutlet weak var btnSelectCity: UIButton!
    
    var bloodId = ""
    var cityId = ""
    var selectedButton = UIButton()
    var arrCity = [[String : Any]]()
    var arBloodGroup = [[String : Any]]()
    var isBlood = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "ADD DONOR"
        // Do any additional setup after loading the view.
        if self.arBloodGroup.count > 0{
            btnBloodGroup.setTitle(self.arBloodGroup[0]["type"] as? String ?? "", for: .normal)
            self.bloodId = self.arBloodGroup[0]["type"] as? String ?? ""
        }
        getCity()
    }
    func getCity(){
        let apiName = APIName.allCity

        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    print(response ?? [String : Any]())
                    guard let strongSelf = self else {return}
                    strongSelf.arrCity = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                   
                    if strongSelf.arrCity.count > 0{
                        strongSelf.btnSelectCity.setTitle(strongSelf.arrCity[0]["name"] as? String ?? "", for: .normal)
                        strongSelf.cityId = strongSelf.arrCity[0]["_id"] as? String ?? ""
                    }
                } else {
                    print(response as Any)
                }
            }
            
            
        }
    }
    func openPicker(sender : UIButton){
    selectedButton = sender
    let vc = UIViewController()
    vc.preferredContentSize = CGSize(width: 250,height: 300)
    let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
    pickerView.delegate = self
    pickerView.dataSource = self
    vc.view.addSubview(pickerView)
    let editRadiusAlert = UIAlertController(title: "Choose", message: "", preferredStyle: UIAlertController.Style.alert)
    editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
            if self.selectedButton == self.btnSelectCity{
                self.cityId = self.arrCity[pickerView.selectedRow(inComponent: 0)]["_id"] as? String ?? ""
                self.btnSelectCity.setTitle(self.arrCity[pickerView.selectedRow(inComponent: 0)]["name"] as? String ?? "", for: .normal)
            }else{
                self.bloodId = self.arBloodGroup[pickerView.selectedRow(inComponent: 0)]["type"] as? String ?? ""
                self.btnBloodGroup.setTitle(self.arBloodGroup[pickerView.selectedRow(inComponent: 0)]["type"] as? String ?? "", for: .normal)
            }
        }))
    editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    self.present(editRadiusAlert, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func Action_OnSubmit(_ sender: UIButton) {
        
        if sender == btnSelectCity{
            openPicker(sender: sender)
        }else if sender == btnBloodGroup{
            openPicker(sender: sender)
        }else if sender == btnSubmit{
            if (tfName.text?.length)! < 1{
                UIAlertController.showAlertError(message: "Please enter name.")
                return
            }
            if (tfNumber.text?.length)! != 10{
                UIAlertController.showAlertError(message: "Please enter valid number.")
                return
            }
            let param = ["city" : cityId,"type" : bloodId,"name": tfName.text?.trim(),"number" : tfNumber.text?.trim()]
            
            let apiName = APIName.addBlood
            
            //        let param = [:]
            
            APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
                DispatchQueue.main.async {
                    if isSuccess == true {
                        guard let strongSelf = self else {return}
                        //_id
                        
                        print(response as? [String : Any] ?? [String : Any]())
                        UIAlertController.showAlert(message: "Donor successfully Added",complition: {
                            self?.navigationController?.popViewController(animated: true)
                        })
                    } else {
                        guard let strongSelf = self else {return}
                        print(response)
                    }
                }
                
            }
        }
        
    }
    
}
extension AddBloodViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedButton == btnSelectCity{
            return arrCity[row]["name"] as? String ?? ""
        }else{
            return arBloodGroup[row]["type"] as? String ?? ""
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
//        if selectedButton == btnSelectCity{
//            btnSelectCity.setTitle(arrCity[row]["name"] as? String ?? "", for: .normal)
//        }else{
//            btnBloodGroup.setTitle(arBloodGroup[row]["type"] as? String ?? "", for: .normal)
//        }
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if selectedButton == btnSelectCity{
            return arrCity.count
        }else{
            return arBloodGroup.count
        }
    }
}
