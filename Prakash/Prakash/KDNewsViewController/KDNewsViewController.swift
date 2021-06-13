//
//  KDNewsViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 11/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField

class KDNewsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnImgOne: UIButton!
    @IBOutlet weak var btnImgTwo: UIButton!
    @IBOutlet weak var btnImgThree: UIButton!
    @IBOutlet weak var uploadInfo: UILabel!
    
    var isPrakash = false
    
    var isHistory = false
    
    var imageOne : UIImage!
    var imageTwo : UIImage!
    var imageThree: UIImage!
    
    var selectedButton = UIButton()
    
    @IBOutlet weak var contactBtn: UIButton!
    @IBOutlet weak var tfMatters: SkyFloatingLabelTextField!
    @IBOutlet weak var tfCity: SkyFloatingLabelTextField!
    @IBOutlet weak var tfNumber: SkyFloatingLabelTextField!
    @IBOutlet weak var tfName: SkyFloatingLabelTextField!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var contactBanner: UIView!
    @IBOutlet weak var firmLogo: UIImageView!
    @IBOutlet weak var firmName: UILabel!
    @IBOutlet weak var firmAddress: UILabel!
    @IBOutlet weak var firmContact: UILabel!
    @IBOutlet weak var firmMail: UILabel!
    
    var placeholderImg : UIImageView {
        get {
            let img = UIImageView(frame: CGRect(x: 5, y: 5, width: 90, height: 90))
            img.image = UIImage(named: "upload_image")
            img.contentMode = .scaleAspectFit
            img.tag = 99
            return img
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if isPrakash{
            btnImgOne.alpha = 0
            btnImgTwo.alpha = 1
            btnImgThree.alpha = 0
            uploadInfo.text = "આપની જાહેરાત નો ફોટો પાડી, અપલોડ કરો"
            btnImgTwo.addSubview(placeholderImg)
//            msgLabel.text = "જાહેરાત આપવા માટે સંપર્ક:"
            contactBtn.setTitle("જાહેરાત આપવા માટે સંપર્ક", for: .normal)
            tfCity.placeholder = "Size"
            
            firmLogo.image = #imageLiteral(resourceName: "ic_pra")
            firmName.text = "Prakash Printers"
            firmAddress.text = "Darbargadh, Savarkundla (Gujarat) - 365601"
            firmContact.text = "9824561561 / 9428191918"
            firmMail.text = "prakashprinters.svkd@gmail.com"
//GST    24AJHPD6219Q1ZY

        }else{
            contactBtn.setTitle("પ્રેસ મેટર આપવા માટે સંપર્ક", for: .normal)
            uploadInfo.text = "પ્રેસ મેટર નો ફોટો પાડી, અપલોડ કરો"
            btnImgOne.alpha = 1
            btnImgTwo.alpha = 1
            btnImgThree.alpha = 1
            btnImgOne.addSubview(placeholderImg)
            btnImgTwo.addSubview(placeholderImg)
            btnImgThree.addSubview(placeholderImg)
            
        }
        
    }
    
    @IBAction func Action_On_Image(_ sender: UIButton) {
        selectedButton = sender
        showAlert()
    }
    @IBAction func Action_On_Submit(_ sender: UIButton) {
        if (tfName.text?.length)! < 1{
            UIAlertController.showAlertError(message: "Please enter name.")
            return
        }
        if (tfNumber.text?.length)! != 10{
            UIAlertController.showAlertError(message: "Please enter valid number.")
            return
        }
        if (tfCity.text?.length)! < 1{
            UIAlertController.showAlertError(message: "Please enter city.")
            return
        }
        if (tfMatters.text?.length)! < 1{
            UIAlertController.showAlertError(message: "Please enter matters.")
            return
        }
       
        var params = [String : Any]()
        var responseMSG = "Your Ad has been submitted and we will contact you shortly"
        if isHistory {
            params["type"] = "history"
            responseMSG = "Your response has been submitted"
        } else if isPrakash {
            params["type"] = "praksh"
            //responseMSG = ""
        } else {
            params["type"] = "kd"
            //responseMSG = ""
        }
        
        params["name"] = tfName.text?.trim()
        params["number"] = tfNumber.text?.trim()
        params["desc"] = tfMatters.text?.trim()
        params["title"] = tfCity.text?.trim()
        if (imageOne != nil){
            params["image1"] = convertImageToBase64String(img: imageOne)
        }else{
            params["image1"] = "0"
        }
        if (imageTwo != nil){
            params["image2"] = convertImageToBase64String(img: imageTwo)
        }else{
            params["image2"] = "0"
        }
        if (imageThree != nil){
            params["image3"] = convertImageToBase64String(img: imageThree)
        }else{
            params["image3"] = "0"
        }
        var apiName = APIName.pressNote
        if isHistory == true{
            apiName = APIName.pressNote
        }
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: params as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    UIAlertController.showAlert(message: responseMSG, complition: {
                        self?.navigationController?.popViewController(animated: true)
                    })
                } else {
                    print(response as Any)
                }
            }
            
            
        }
    }
    
    @IBAction func Contact_Closed(_ sender: UIButton) {
        UIView.animate(withDuration: 0.3, animations: {
            
            self.contactBanner.alpha = 0
            self.contactBanner.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
            self.scrollView.alpha = 1
            
        }) { (action) in
            self.scrollView.isUserInteractionEnabled = true
        }
        
    }
    
    
    @IBAction func Contact_Tapped(_ sender: UIButton) {
        
        self.contactBanner.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        self.view.endEditing(true)
        
        UIView.animate(withDuration: 0.3, animations: {
            self.scrollView.alpha = 0.5
            self.contactBanner.alpha = 1
            self.contactBanner.transform = CGAffineTransform(scaleX: 1, y: 1)
            
        }) { (action) in
            self.scrollView.isUserInteractionEnabled = false
        }
        
    }
    
    func convertImageToBase64String (img: UIImage) -> String {
        if let data = img.jpegData(compressionQuality: 1.0) {
            return "data:image/jpeg;base64," + data.base64EncodedString()
        }
        return ""
    }
    func showAlert() {
        
        let alert = UIAlertController(title: "", message: "Choose Action", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Photo Album", style: .default, handler: {(action: UIAlertAction) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        
        //Check is source type available
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        selectedButton.setImage(image, for: .normal)
        selectedButton.bringSubviewToFront(selectedButton.imageView!)
        if isPrakash {
            if selectedButton == btnImgTwo{
                imageOne = image
            }
            
        } else {
            if selectedButton == btnImgOne{
                imageOne = image
            }
            if selectedButton == btnImgTwo{
                imageTwo = image
            }
            if selectedButton == btnImgThree{
                imageThree = image
            }
        }
        
        picker.dismiss(animated: true, completion: nil)
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("imagePickerController cancel")
    }

}
