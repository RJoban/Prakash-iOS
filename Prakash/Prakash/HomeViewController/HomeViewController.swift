//
//  HomeViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 04/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import ImageSlideshow

class HomeViewController: UIViewController {
    
    var isFromNotification = false

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var cvMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var cvAdsHeight: NSLayoutConstraint!
    var arrAd = [[String : AnyObject]]()
    var arrBanner = [[String : AnyObject]]()
    @IBOutlet weak var cvMenu: UICollectionView!
    @IBOutlet weak var cvAd: UICollectionView!
    @IBOutlet weak var slideViewHeight: NSLayoutConstraint!
    var arrOptions = [[String : Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        
        slideViewHeight.constant = self.view.frame.width / 2.083
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        slideshow.activityIndicator = DefaultActivityIndicator(style: .gray, color: .black)
        
        cvMenu.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SectionHeader")
        cvMenu.register(UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        cvMenu.register(UINib(nibName: "AdvertiseCell", bundle: nil), forCellWithReuseIdentifier: "AdvertiseCell")
        
        arrOptions.insert(["name" : "પ્રકાશ", "image" : UIImage(named: "0")!], at: 0)
        arrOptions.insert(["name" : "કેડી ન્યૂઝ", "image" : UIImage(named: "1")!], at: 1)
        arrOptions.insert(["name" : "ડીરેકટરી", "image" : UIImage(named: "2")!], at: 2)
        arrOptions.insert(["name" : "બ્લડ", "image" : UIImage(named: "3")!], at: 3)
        arrOptions.insert(["name" : "હિસ્ટોરિકલ નોલેજ", "image" : UIImage(named: "4")!], at: 4)
        arrOptions.insert(["name" : "ન્યૂઝ પેપર", "image" : UIImage(named: "5")!], at: 5)
        arrOptions.insert(["name" : "વિડિઓ એડ", "image" : UIImage(named: "6")!], at: 6)
        arrOptions.insert(["name" : "નોટિફિકેશન", "image" : UIImage(named: "7")!], at: 7)
        
        DispatchQueue.main.async {
            self.cvMenu.reloadData()
        }

        getAllBanner()
        getAllAdvertise()
        
        if let flowLayout = cvMenu?.collectionViewLayout as? UICollectionViewFlowLayout {
            if #available(iOS 11.0, *) {
                flowLayout.sectionInsetReference = .fromSafeArea
            }
        }
        
        if let flowLayout = cvAd?.collectionViewLayout as? UICollectionViewFlowLayout {
            if #available(iOS 11.0, *) {
                flowLayout.sectionInsetReference = .fromSafeArea
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isFromNotification {
            isFromNotification = false
            guard let type = UserDefaults.standard.value(forKey: "NotificationType") as? String else { return }
            
            switch type {
            case "1":
                let prakashVC = self.storyboard?.instantiateViewController(withIdentifier: "PrakashViewController") as! PrakashViewController
                prakashVC.strType = "PRAKASH"
                self.navigationController?.pushViewController(prakashVC, animated: true)
            case "2":
                let prakashVC = self.storyboard?.instantiateViewController(withIdentifier: "PrakashViewController") as! PrakashViewController
                prakashVC.strType = "KD"
                self.navigationController?.pushViewController(prakashVC, animated: true)
            case "4":
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoAdViewController") as! VideoAdViewController
                directoryVC.isNotifiction = true
                directoryVC.title = "Notification"
                self.navigationController?.pushViewController(directoryVC, animated: true)
            case "5":
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoAdViewController") as! VideoAdViewController
                self.navigationController?.pushViewController(directoryVC, animated: true)
            default:
                break
            }
        }
    }
    
    func getAllAdvertise(){
        let apiName = APIName.sponsoredads
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                strongSelf.arrAd = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                DispatchQueue.main.async {
                    strongSelf.cvMenu.reloadSections(IndexSet(arrayLiteral: 1))
                    let height = strongSelf.cvMenu.collectionViewLayout.collectionViewContentSize.height
                    strongSelf.cvMenuHeight.constant = height
                    //
                    let height1 = strongSelf.cvAd.collectionViewLayout.collectionViewContentSize.height
                    strongSelf.cvAdsHeight.constant = height1
                    strongSelf.view.setNeedsLayout()
                }
            } else {
                guard self != nil else {return}
                print(response as Any)
            }
            
        }
        
    }
    
    func getAllBanner(){
        let apiName = APIName.slider
        
        let param = ["page" : "Home"]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                strongSelf.arrBanner = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                var kingFisherSource = [KingfisherSource]()
                for dict in strongSelf.arrBanner{
                    if (dict["pagetype"] as? String ?? "").lowercased() == "home" && (dict["pagetype"] as? String ?? "").lowercased() != "exit"{
                        kingFisherSource.append(KingfisherSource(url: URL(string:(AppConfig.baseImageURL + (dict["sliderimage"] as? String ?? "")))!, placeholder: #imageLiteral(resourceName: "6"),options: nil))
                    }
                }
                kingFisherSource = kingFisherSource.shuffled()
                strongSelf.slideshow.setImageInputs(kingFisherSource)
                
            } else {
                guard self != nil else {return}
                print(response as Any)
            }
            
        }
        
    }
}

extension HomeViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            let itemUrl = arrAd[indexPath.row]["url"] as? String ?? ""
            guard let url = URL(string: itemUrl) else { return }
            UIApplication.shared.open(url)
        }else{
            if indexPath.row == 0{
                let prakashVC = self.storyboard?.instantiateViewController(withIdentifier: "PrakashViewController") as! PrakashViewController
                prakashVC.strType = "PRAKASH"
                self.navigationController?.pushViewController(prakashVC, animated: true)
            }else if indexPath.row == 1{
                let prakashVC = self.storyboard?.instantiateViewController(withIdentifier: "PrakashViewController") as! PrakashViewController
                prakashVC.strType = "KD"
                self.navigationController?.pushViewController(prakashVC, animated: true)

            }else if indexPath.row == 2{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "DirectoryViewController") as! DirectoryViewController
                directoryVC.title = "Directory"
                    self.navigationController?.pushViewController(directoryVC, animated: true)
//            }else if indexPath.row == 3{
//                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
//                directoryVC.title = "Channel"
//                self.navigationController?.pushViewController(directoryVC, animated: true)
            }else if indexPath.row == 3{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BloodViewController") as! BloodViewController
                //directoryVC.title = "Blood"
                self.navigationController?.pushViewController(directoryVC, animated: true)
            }else if indexPath.row == 4{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "BloodViewController") as! BloodViewController
                directoryVC.isHistory = true
                self.navigationController?.pushViewController(directoryVC, animated: true)
            }
            else if indexPath.row == 5{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "ChannelViewController") as! ChannelViewController
                directoryVC.isNewPaper = true
                self.navigationController?.pushViewController(directoryVC, animated: true)
            }else if indexPath.row == 6{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoAdViewController") as! VideoAdViewController
                self.navigationController?.pushViewController(directoryVC, animated: true)
            }
            else if indexPath.row == 7{
                let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "VideoAdViewController") as! VideoAdViewController
                directoryVC.isNotifiction = true
                directoryVC.title = "Notification"
                self.navigationController?.pushViewController(directoryVC, animated: true)
            }
        }
    }
}
extension HomeViewController : UICollectionViewDataSource{
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return section == 0 ? arrOptions.count : arrAd.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuCell", for:indexPath) as! MenuCell
            
            if UIDevice.current.userInterfaceIdiom == .pad {
                cell.titleLabel.font = UIFont.systemFont(ofSize: 19)
            } else {
                cell.titleLabel.font = UIFont.systemFont(ofSize: 16)
            }
            cell.titleLabel.text = arrOptions[indexPath.row]["name"] as? String ?? ""
            cell.imageView.image = arrOptions[indexPath.row]["image"] as? UIImage

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AdvertiseCell", for: indexPath) as! AdvertiseCell
            
            let dict = arrAd[indexPath.row]
    
            DispatchQueue.main.async {
                cell.imageView.kf.setImage(with: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? ""))))
            }

            return cell
        }
    }
    func getShadowView(cell:UICollectionViewCell)->UIView
    {
        let view_ = UIView.init(frame: CGRect(x: 1, y: 1, width: cell.bounds.width - 1, height: cell.bounds.height - 3))
        cell.contentView.addSubview(view_)
        view_.layer.cornerRadius = 0
        view_.backgroundColor = .white
        view_.setViewShadow(clr: .gray)
        return view_
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        switch kind {

        case UICollectionView.elementKindSectionHeader:
            if let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SectionHeader", for: indexPath) as? SectionHeader {

            headerView.label.text = indexPath.section == 0 ? "" : "-----BOOST YOUR BUSINESS-----"
            
            headerView.backgroundColor = UIColor.clear
                return headerView
            }
            return UICollectionReusableView()
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "HeaderClass", for: indexPath)

            
            return footerView

        default:
            assert(false, "Unexpected element kind")
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height:  section == 0 ? 0 : 60)
    }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: 0, height: 0)
    }

    
}
extension HomeViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 3
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1)) + 5
        
        let size = Int((self.view.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        if collectionView != cvMenu{
            return  CGSize(width: size, height: size-15)
        }
        return CGSize(width: size, height: size)
    }
}

class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
