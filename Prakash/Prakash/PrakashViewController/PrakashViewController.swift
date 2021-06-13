//
//  PrakashViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 07/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit

class PrakashViewController: UIViewController {

    @IBOutlet weak var cvPrakash: UICollectionView!
    
    var strType = "PRAKASH"
    var arrNews = [[String : Any]]()
    var filteredDictionary = [[String: Any]]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getAllNews()
    }
    
    @objc func openPressNoteViewController(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "KDNewsViewController") as! KDNewsViewController
        vc.isPrakash = strType == "PRAKASH" ? true : false
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        var logo = UIImage()
        let clipBtn: UIButton = UIButton(type: .custom)
        logo = UIImage(named: strType == "PRAKASH" ? "0" : "1")!
        
        clipBtn.setImage(UIImage(named: strType == "PRAKASH" ? "ic_ads" : "ic_p"), for: .normal)
        if strType != "PRAKASH"{
            navigationController?.navigationBar.barTintColor = UIColor.black
        }
        clipBtn.imageView?.contentMode = .scaleAspectFit
        let container = UIView(frame: CGRect(x: 0, y: 0, width: 1000, height: 30))
        
        let imageView = UIImageView(image:logo)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(imageView)
        self.navigationItem.titleView = container
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: container.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            imageView.centerXAnchor.constraint(equalTo: container.centerXAnchor, constant: 0),
//            imageView.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        clipBtn.addTarget(self, action: #selector(openPressNoteViewController), for: UIControl.Event.touchUpInside)
    
        clipBtn.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        clipBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clipBtn.widthAnchor.constraint(equalToConstant: 65)
        ])
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        self.navigationItem.setRightBarButtonItems([clipBarBtn], animated: false)
        
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.barTintColor = UIColor.red//(red: 234.0/255.0, green: 46.0/255.0, blue: 73.0/255.0, alpha: 1.0)

    }
    
    func getAllNews(){
        let apiName = APIName.allnews
        
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            
            if isSuccess == true {
                guard let strongSelf = self else {return}
                
                print(response ?? [String : Any]())
                
                strongSelf.arrNews = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                strongSelf.arrNews = strongSelf.arrNews.filter { $0["agency"] as? String ?? "" == strongSelf.strType.lowercased() }
                
                for i in 0..<strongSelf.arrNews.count{
                    let dict = strongSelf.arrNews[i]
                    let createdDate = strongSelf.convertDateFormater(date: dict["createdAt"] as? String ?? "", from: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", to: "EEEE, d MMM yyyy")
                    var mutableDict = dict
                    mutableDict["createdAt"] = createdDate
                    strongSelf.arrNews.remove(at: i)
                    strongSelf.arrNews.insert(mutableDict, at: i)
                }
                
                
                for item in strongSelf.arrNews {
                    
                    let result = strongSelf.filteredDictionary.filter { (innerItem) -> Bool in
                        return ((item["createdAt"] as! String) == (innerItem["createdAt"] as! String))
                    }
                    if result.count == 0 {
                        strongSelf.filteredDictionary.append(item)
                    }
                       
                }
                
                strongSelf.cvPrakash.reloadData()
                
            } else {
                guard let strongSelf = self else {return}
                print(response)
            }
            
        }
    }

}
extension PrakashViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailVC = self.storyboard?.instantiateViewController(withIdentifier: "PrakashDetailViewController") as! PrakashDetailViewController
        detailVC.arrImages = self.arrNews.filter{$0["createdAt"] as? String ?? "" == (self.filteredDictionary[indexPath.item])["createdAt"] as? String ?? ""} as [[String : AnyObject]]
        detailVC.title = (self.filteredDictionary[indexPath.item])["createdAt"] as? String
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}
extension PrakashViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filteredDictionary.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : PrakashCell = collectionView.dequeueReusableCell(withReuseIdentifier: "prakash", for: indexPath) as! PrakashCell
        
        let dict = filteredDictionary[indexPath.item]
        
        cell.lblDate.text = dict["createdAt"] as? String ?? ""
        cell.thumImage.kf.setImage(with: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? ""))), placeholder: #imageLiteral(resourceName: "6"),options: nil)
            return cell
        
    }
    func convertDateFormater(date: String,from : String , to : String) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = from
        
        let dateFromInputString = dateFormatter.date(from: date)
        dateFormatter.dateFormat = to
        if(dateFromInputString != nil){
            return dateFormatter.string(from: dateFromInputString!)
        }
        else{
            debugPrint("could not convert date")
            return "N/A"
        }
        
    }
}
extension PrakashViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
        return CGSize(width: collectionView.bounds.size.width - 30 , height: 200)
    }
}
class PrakashCell : UICollectionViewCell{
    @IBOutlet weak var thumImage: UIImageView!
    @IBOutlet weak var lblDate: UILabel!
    
    
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
