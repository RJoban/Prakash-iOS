//
//  AddDirectoryViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 14/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class AddDirectoryViewController: UIViewController {

    @IBOutlet weak var btnSubmit: UIButton!
    @IBOutlet weak var btnBloodGroup: UIButton!
    @IBOutlet weak var tfNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    var cityId = ""
    var categoryId = ""
    @IBOutlet weak var btnSelectCity: UIButton!
    @IBOutlet weak var tvAddress: UITextView!
    var selectedButton = UIButton()
    var arrCity = [[String : Any]]()
    var arrCategory = [[String : Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getCity()
    }
    func getCity(){
        let apiName = APIName.allCity
        
        //        let param = [:]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrCity = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    
                    if strongSelf.arrCity.count > 0{
                        strongSelf.btnSelectCity.setTitle((strongSelf.arrCity[0]["name"] as? String ?? "").capitalized, for: .normal)
                        strongSelf.cityId = strongSelf.arrCity[0]["_id"] as? String ?? ""
                        self?.getCategoriesByCity()
                    }
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
                }
            }
            
            
        }
    }
    func getCategoriesByCity(){
        let apiName = APIName.directories
        let param = ["city" : cityId]
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrCategory = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.arrCategory = strongSelf.arrCategory.sorted(by: { (item1, item2) -> Bool in
                        return (item1["name"] as! String) < (item2["name"] as! String)
                    })
    //                ન્યૂઝ
                    if strongSelf.arrCategory.count > 0{
                        strongSelf.btnBloodGroup.setTitle((strongSelf.arrCategory[0]["name"] as? String ?? "").capitalized, for: .normal)
                        strongSelf.categoryId = strongSelf.arrCategory[0]["_id"] as? String ?? ""
                    }
                                
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
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
                self.btnSelectCity.setTitle((self.arrCity[pickerView.selectedRow(inComponent: 0)]["name"] as? String ?? "").capitalized, for: .normal)
                self.getCategoriesByCity()
            }else{
                self.categoryId = self.arrCategory[pickerView.selectedRow(inComponent: 0)]["_id"] as? String ?? ""
                self.btnBloodGroup.setTitle((self.arrCategory[pickerView.selectedRow(inComponent: 0)]["name"] as? String ?? "").capitalized, for: .normal)
            }
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
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
            if (tfNumber.text?.length)! != 10 {
                UIAlertController.showAlertError(message: "Please enter valid number.")
                return
            }
            if (tvAddress.text.length) < 1{
                UIAlertController.showAlertError(message: "Please enter address.")
                return
            }
            let param = ["city" : cityId,"category" : categoryId,"name": tfName.text?.trim(),"number" : tfNumber.text?.trim(),"address" : tvAddress.text.trim(),"status" : "0"]
            
            let apiName = APIName.addDirectory
            
            //        let param = [:]
            
            APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
                DispatchQueue.main.async {
                    if isSuccess == true {
                        guard let strongSelf = self else {return}
                        //_id
                        
                        print(response as? [String : Any] ?? [String : Any]())
                        UIAlertController.showAlert(message: message,complition: {
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
extension AddDirectoryViewController : UIPickerViewDelegate,UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if selectedButton == btnSelectCity{
            return (arrCity[row]["name"] as? String ?? "").capitalized
        }else{
            return (arrCategory[row]["name"] as? String ?? "").capitalized
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
            return arrCategory.count
        }
    }
}
