//
//  VideoAdViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 09/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class VideoAdViewController: UIViewController {

    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var closePlayerButton: UIButton!

    var isNotifiction = false
    
    var arrResults = [[String : AnyObject]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if isNotifiction{
            self.title = "Notification"
            getNotifications()
        }else{
            self.title = "VIDEO ADS"
            let clipBtn: UIButton = UIButton(type: .custom)
            clipBtn.setImage(UIImage(named: "ic_v"), for: .normal)
            clipBtn.addTarget(self, action: #selector(openPressNoteViewController), for: UIControl.Event.touchUpInside)
            clipBtn.imageView?.contentMode = .scaleAspectFit
//            clipBtn.setTitleColor(UIColor.red, for: .normal)
//            clipBtn.setTitle("Add News", for: .normal)
            clipBtn.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
            clipBtn.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                clipBtn.widthAnchor.constraint(equalToConstant: 65)
            ])
            let clipBarBtn = UIBarButtonItem(customView: clipBtn)
            self.navigationItem.setRightBarButtonItems([clipBarBtn], animated: false)
            getAllVideoAd()
        }

        tblView.tableFooterView = UIView(frame: .zero)
    }
    
    @objc func openPressNoteViewController(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddVideoAdViewController") as! AddVideoAdViewController
//        vc.isPrakash = strType == "PRAKASH" ? true : false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getAllVideoAd(){
        let apiName = APIName.videoAd
        
        //        let param = [:]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
    
    func getNotifications(){
        let apiName = APIName.notifications
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
}

extension VideoAdViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isNotifiction{
            let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "NotificationDetailViewController") as! NotificationDetailViewController
            detailVC.imgURL = AppConfig.baseImageURL + (arrResults[indexPath.section]["image"] as? String ?? "")
            detailVC.strTitle = arrResults[indexPath.section]["title"] as? String ?? ""
            detailVC.strDesc = arrResults[indexPath.section]["description"] as? String ?? ""
            self.navigationController?.pushViewController(detailVC, animated: true)
            return
        }
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.videoId = (arrResults[indexPath.section]["url"] as! String)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension VideoAdViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return arrResults.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "history", for : indexPath) as! VideoAdCell

        let dict = arrResults[indexPath.section]
        if UIDevice.current.userInterfaceIdiom == .pad {
            cell.lblName.font = UIFont.systemFont(ofSize: 19)
        } else {
            cell.lblName.font = UIFont.systemFont(ofSize: 15)
        }
        if isNotifiction{
            
            cell.lblName.text = dict["title"] as? String ?? ""
            cell.imgView.kf.setImage(with: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? ""))))
        }
        else{
            cell.lblName.text = dict["name"] as? String ?? ""
            let key = dict["url"] as! String
            let keyPath = "https://img.youtube.com/vi/\(key)/0.jpg"
            cell.imgView.kf.setImage(with: URL(string:keyPath))
            cell.imgView.contentMode = .scaleToFill
        }

        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 435
        }
       return 290
    }
}

class VideoAdCell : UITableViewCell{
    
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!

}

extension UIView {
    
    func cardView() {
        self.layer.cornerRadius = 10.0
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.layer.shadowOpacity = 0.3
        self.layer.masksToBounds = false
    }
}
