//
//  ChannelViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 09/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import ImageSlideshow
import AVKit
import AVFoundation

class ChannelViewController: UIViewController, UIDocumentInteractionControllerDelegate, URLSessionDownloadDelegate {
    
    var selectedItem = ""
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ProgressView: UIView!
    
    @IBOutlet weak var sldeShow: ImageSlideshow!
    @IBOutlet weak var cvChannel: UICollectionView!
    var arrBanner = [[String : AnyObject]]()
    var session: URLSession!
    var arrResults = [[String : AnyObject]]()
    var documentController: UIDocumentInteractionController!
    var isNewPaper = false
    @IBOutlet weak var slideViewHeight: NSLayoutConstraint!
    @IBOutlet weak var myProgressView: UIProgressView!
    
    var theBool: Bool = false
    var myTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        slideViewHeight.constant = self.view.frame.width / 2.083
        if isNewPaper {
            documentController = UIDocumentInteractionController()
            documentController.delegate = self
            documentController.name = "Newspaper"
            
            self.title = "Newspaper"
        } else {
            
            self.title = "Live TV"
        }
    
        sldeShow.slideshowInterval = 5.0
        sldeShow.contentScaleMode = UIView.ContentMode.scaleToFill
        sldeShow.activityIndicator = DefaultActivityIndicator()
        
        getAllBanner()
        cvChannel.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        if isNewPaper{
            getAgency()
        }else{
            self.getAllChannels()
        }
    }
    func getAllChannels(){
        let apiName = APIName.getAllChannels
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                strongSelf.cvChannel.reloadData()
                
            }
        }
    }
    func getAgency(){
        let apiName = APIName.allAgency
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                strongSelf.cvChannel.reloadData()
                
            }
        }
    }
    
    func getAllBanner(){
        let apiName = APIName.slider
        
        var param = ["page" : "Home"]
        if isNewPaper {
            param = ["page" : "Home"]
        }
        
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                strongSelf.arrBanner = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                var kingFisherSource = [KingfisherSource]()
                for dict in strongSelf.arrBanner{
                    if (dict["pagetype"] as? String ?? "").lowercased() != "exit"{
                        kingFisherSource.append(KingfisherSource(url: URL(string:(AppConfig.baseImageURL + (dict["sliderimage"] as? String ?? "")))!))
                    }
                }
                strongSelf.sldeShow.setImageInputs(kingFisherSource.shuffled())
                
            }
        }
    }
}

extension ChannelViewController : UICollectionViewDelegate{
    
    func startLoadingProgress() {
        self.ProgressView.isHidden = false
        self.myProgressView.progress = 0.0
        self.progressLabel.text = "0%"
        self.theBool = false
        self.view.isUserInteractionEnabled = false
        self.myTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(timerCallback), userInfo: nil, repeats: true)
    }
    
    func finishLoadingProgress() {
        self.theBool = true
    }
    
    @objc func timerCallback() {
        if self.theBool {
            if self.myProgressView.progress >= 1 {
                self.ProgressView.isHidden = true
                self.myTimer.invalidate()
                self.view.isUserInteractionEnabled = true
            } else {
                self.myProgressView.progress += 0.1
            }
        } else {
            self.myProgressView.progress += 0.05
            if self.myProgressView.progress >= 0.95 {
                self.myProgressView.progress = 0.95
            }
        }
        self.progressLabel.text = Int(self.myProgressView.progress * 100).description + "%"
    }
    
    
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    func documentInteractionControllerDidEndPreview(_ controller: UIDocumentInteractionController) {
        UINavigationBar.appearance().tintColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = .white
    }
    
    func storeAndShare(withURLString: String,_ title: String) {
        
        self.ProgressView.isHidden = false
        self.myProgressView.progress = 0.0
        self.progressLabel.text = "0%"
        session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.downloadTask(with: URL(string: withURLString)!)
        task.resume()
    }
    
    func getNewpaper(_ news: String){
        let apiName = APIName.newspaper
        
        let param = ["agency" : news]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            if isSuccess == true {
                guard let strongSelf = self else {return}
                let newsPaper = (response?["data"] as? [[String : Any]] ?? [[String : Any]]()).first
                self?.storeAndShare(withURLString: AppConfig.baseImageURL + (newsPaper?["image"] as? String ?? ""), "NewsPaper")
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isNewPaper{
            self.cvChannel.isUserInteractionEnabled = false
            selectedItem = arrResults[indexPath.row]["_id"] as? String ?? ""
            self.getNewpaper(arrResults[indexPath.row]["_id"] as? String ?? "")
            return
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PlayerVC") as! PlayerVC
        vc.videoId = (arrResults[indexPath.row]["url"] as? String ?? "")
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ChannelViewController : UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChannelCell", for:  indexPath) as! ChannelCell
        cell.PPCorneredius = 5
        cell.PPBorderWidth = 1
        cell.PPBorderColor = UIColor.lightGray
        let dict = self.arrResults[indexPath.item]
        cell.img.kf.setImage(with: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? ""))))
        
        return cell
    }
}

extension ChannelViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let noOfCellsInRow = 2
        
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalSpace = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(noOfCellsInRow - 1))
        
        let size = Int((collectionView.bounds.width - totalSpace) / CGFloat(noOfCellsInRow))
        
        return CGSize(width: size, height: size)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.cvChannel.isUserInteractionEnabled = true
        print("downloadLocation:", location)
        // create destination URL with the original pdf name
        guard let url = downloadTask.originalRequest?.url else { return }
        let documentsPath = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let destinationURL = documentsPath.appendingPathComponent(url.lastPathComponent)
        // delete original copy
        try? FileManager.default.removeItem(at: destinationURL)
        // copy from temp to Document
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            print(location.absoluteString)
            DispatchQueue.main.async {
                self.showFileWithPath(path: destinationURL)
                //                    self.documentInteractor.url = destinationURL
                //                    self.documentInteractor.presentPreview(animated: true)
            }
            
            //self.pdfURL = destinationURL
        } catch let error {
            print("Copy Error: \(error.localizedDescription)")
        }
    }
    
    func showFileWithPath(path: URL){
        self.ProgressView.isHidden = true
        UINavigationBar.appearance().tintColor = .black
        self.documentController.url = path
        self.documentController.presentPreview(animated: true)
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.myProgressView.progress = progress
            self.progressLabel.text = Int(progress * 100.0).description + "%"
        }
    }
}

class ChannelCell: UICollectionViewCell {
    @IBOutlet weak var img: UIImageView!
}
