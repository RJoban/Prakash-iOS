//
//  BloodViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 09/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import ImageSlideshow

class BloodViewController: UIViewController, UISearchBarDelegate, UIDocumentInteractionControllerDelegate, FileManagerDelegate {
    var selectedItem = ""
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var ProgressView: UIView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var slideShowHeight: NSLayoutConstraint!
    @IBOutlet var slideshow: ImageSlideshow!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var myProgressView: UIProgressView!
    
    var theBool: Bool = false
    var myTimer: Timer!
    
    var documentController: UIDocumentInteractionController!
    
    var arrResults = [[String : AnyObject]]()
    
    var filteredData = [[String: AnyObject]]()
    
    var arrBanner = [[String : AnyObject]]()
    
    var bloodType = ""
    var city = ""
    var isHistory = false
    
    
    func setupSearchTextField() {
        
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        
        
        let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
        textFieldInsideSearchBar.textColor = UIColor.white
        
        
        let clearButton = textFieldInsideSearchBar.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(clearButton.imageView?.image?.withRenderingMode(.alwaysTemplate), for: .normal)
        clearButton.tintColor = UIColor.white
        
        let textFieldInsideSearchBarLabel = textFieldInsideSearchBar.value(forKey: "placeholderLabel") as! UILabel
        textFieldInsideSearchBarLabel.textColor = UIColor.white
        
        let glassIconView = textFieldInsideSearchBar.leftView as? UIImageView
        glassIconView?.image = glassIconView?.image?.withRenderingMode(.alwaysTemplate)
        glassIconView?.tintColor = UIColor.white
        
        let clearButton2 = textFieldInsideSearchBar.value(forKey: "clearButton") as! UIButton
        clearButton.setImage(UIImage(named: "ic_clear"), for: .normal)
        clearButton2.tintColor = .white
    }
    @IBAction func onClickSearchButton()
    {
        searchView.isHidden = false
        self.view.bringSubviewToFront(searchView)
        
    }
    @IBAction func backFromSearch()
    {
        searchView.isHidden = true
        
    }
    @IBAction func onClickBackVC()
    {
        topView.isHidden = true
        self.navigationController?.navigationBar.isHidden = false
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        documentController = UIDocumentInteractionController()
        documentController.delegate = self
        searchBar.delegate = self
        setupSearchTextField()
        
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        slideshow.activityIndicator = DefaultActivityIndicator()
        
        getAllBanner()
        
        let clipBtn: UIButton = UIButton(type: .custom)
        
        clipBtn.addTarget(self, action: #selector(openPressNoteViewController), for: UIControl.Event.touchUpInside)
        clipBtn.setTitleColor(UIColor.red, for: .normal)
        if isHistory == true{
            clipBtn.setImage(UIImage(named: "ic_h"), for: .normal)
        }else{
            clipBtn.setImage(UIImage(named: "ic_b"), for: .normal)
        }
        clipBtn.imageView?.contentMode = .scaleAspectFit
        clipBtn.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        clipBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clipBtn.widthAnchor.constraint(equalToConstant: 65)
        ])
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        self.navigationItem.setRightBarButtonItems([clipBarBtn], animated: false)
        
        
        if isHistory{
            getAllHistory()
            self.title = "HISTORICAL KNOWLEDGE"
        }else if bloodType.length < 1{
            getAllBlood()
            self.title = "BLOOD DONOR"
        }else if bloodType.length > 1 && city.length < 1{
            self.title = bloodType
            getAllBloodWithType()
            self.customTitleLabel.text = bloodType
            self.navigationItem.setRightBarButtonItems([], animated: false)
        }else if city.length > 1{
            self.title = bloodType
            self.customTitleLabel.text = bloodType
            getAllBloodWithCity()// hide slider and implement search.
            
        }
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tblView.tableFooterView = UIView(frame: .zero)
        searchView.isHidden = true
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        for obj1 in arrResults
        {
            _ = obj1.filter { (key,val) -> Bool in
                if let value = val as? String {
                    if key != "_id" && (value).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                    {
                        filteredData.append(obj1)
                    }
                }
                return true
            }
        }
        if filteredData.count == 0
        {
            filteredData = arrResults
        }
        tblView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UINavigationBar.appearance().tintColor = .white
        if city.length > 1 {
            self.navigationItem.setRightBarButtonItems([], animated: false)
            self.navigationController?.navigationBar.isHidden = true
            self.topView.isHidden = false
            self.topViewHeightConstraint.constant = 50
            slideShowHeight.constant = 0
            slideshow.isHidden = true
        } else {
            slideShowHeight.constant = self.view.frame.width / 2.083
            self.navigationController?.navigationBar.isHidden = false
            self.topView.isHidden = true
            self.topViewHeightConstraint.constant = 0
        }
    }
    @objc func openPressNoteViewController(){
        if isHistory == true{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "KDNewsViewController") as! KDNewsViewController
            vc.isPrakash = false
            vc.isHistory = true
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddBloodViewController") as! AddBloodViewController
            vc.isBlood = true
            vc.arBloodGroup = filteredData
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func getAllBanner(){
        let apiName = APIName.slider
        var param = ["page" : "Home"]
        if isHistory {
            param = ["page" : "Home"]
        }
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    
                    print(response ?? [String : Any]())
                    strongSelf.arrBanner = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    var kingFisherSource = [KingfisherSource]()
                    for dict in strongSelf.arrBanner{
                        if (dict["pagetype"] as? String ?? "").lowercased() != "exit" {
                            kingFisherSource.append(KingfisherSource(url: URL(string:(AppConfig.baseImageURL + (dict["sliderimage"] as? String ?? "")))!))
                        }
                    }
                    strongSelf.slideshow.setImageInputs(kingFisherSource.shuffled())
                    
                } else {
                    print(response as Any)
                }
            }
        }
    }
    
    func getAllBloodWithType(){
        let apiName = APIName.allBloodWithType
        let param = ["type": bloodType]
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.filteredData = strongSelf.arrResults
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
    
    func getAllBloodWithCity(){
        let apiName = APIName.allBloodGroups
        let param = ["type": bloodType,"city" : city]
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.arrResults = strongSelf.arrResults.shuffled()
                    strongSelf.filteredData = strongSelf.arrResults
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
    
    
    func getAllHistory(){
        let apiName = APIName.allNews
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.filteredData = strongSelf.arrResults
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
    
    var session: URLSession!
    
    func getAllBlood(){
        let apiName = APIName.allBloods
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    strongSelf.filteredData = strongSelf.arrResults
                    strongSelf.tblView.reloadData()
                }
            }
        }
    }
}

extension BloodViewController : UITableViewDelegate, URLSessionDownloadDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isHistory{
            let str = AppConfig.baseImageURL + (filteredData[indexPath.section]["file"] as? String ?? "")
            self.selectedItem = (filteredData[indexPath.section]["file"] as? String ?? "")
            self.storeAndShare(withURLString: str, "")
            return
        }else if city.length > 0{
            let phone = self.filteredData[indexPath.section]["number"] as? String ?? ""
            if let url = URL(string: "tel://\(phone)"),
                UIApplication.shared.canOpenURL(url) {
                if #available(iOS 10, *) {
                    UIApplication.shared.open(url, options: [:], completionHandler:nil)
                } else {
                    UIApplication.shared.openURL(url)
                }
            } else {
                // add error message here
            }
            return
        } else if bloodType.length > 0 {
                   let bloodVC = self.storyboard?.instantiateViewController(withIdentifier: "BloodViewController") as! BloodViewController
                   bloodVC.bloodType = bloodType
                   bloodVC.city = filteredData[indexPath.section]["id"] as? String ?? ""
                   self.navigationController?.pushViewController(bloodVC, animated: true)
        } else {
            let bloodVC = self.storyboard?.instantiateViewController(withIdentifier: "BloodViewController") as! BloodViewController
            bloodVC.bloodType = filteredData[indexPath.section]["type"] as? String ?? ""
            self.navigationController?.pushViewController(bloodVC, animated: true)
        }
        
    }
}
extension BloodViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isHistory{
            let cell = tableView.dequeueReusableCell(withIdentifier: "history", for : indexPath) as! HistoryCell
            let dict = filteredData[indexPath.section]
            cell.lblName.text = dict["name"] as? String ?? ""
            cell.imgView.kf.setImage(with: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? ""))))
            return cell
        }
        if bloodType.length > 0 && city.length < 1{
            let cell = tableView.dequeueReusableCell(withIdentifier: "city", for : indexPath) as! City
            cell.lblCity.text = filteredData[indexPath.section]["city"] as? String ?? ""
            return cell
        }else if city.length > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1") as! PersonCell
            cell.lblName.text = (filteredData[indexPath.section]["name"] as? String ?? "").capitalized
            cell.lblNumber.text = (filteredData[indexPath.section]["number"] as? String ?? "").capitalized
            cell.lblCity.text = ""
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "city", for : indexPath) as! City
        cell.lblCity.text = filteredData[indexPath.section]["type"] as? String ?? ""
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isHistory{
            if UIDevice.current.userInterfaceIdiom == .pad {
                return 275
            }
            return 190
        }
        if bloodType.length < 1{
            return 60
        }else if city.length > 0 && bloodType.length > 0{
            return 50
        }else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if isHistory {
            return 12
        }
        if bloodType.length < 1 {
            return 0
        }else{
            return 12
        }
    }
    
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
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        print(error.debugDescription)
    }
    func fileManager(_ fileManager: FileManager, shouldMoveItemAt srcURL: URL, to dstURL: URL) -> Bool {
        return true
    }
    func fileManager(_ fileManager: FileManager, shouldMoveItemAtPath srcPath: String, toPath dstPath: String) -> Bool {
        return true
    }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
            self.tblView.isUserInteractionEnabled = true
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
                
                    
//                    self.session.finishTasksAndInvalidate();
//                    self.session.invalidateAndCancel()
               
                    
                    

            
        }
        func showFileWithPath(path: URL){
//            let isFileFound:Bool? = FileManager.default.fileExist
//            if isFileFound == true{
                self.ProgressView.isHidden = true
//                let savedURL = URL.init(fileURLWithPath: path)
//                print(savedURL)
                UINavigationBar.appearance().tintColor = .black
                self.documentController.url = path
                self.documentController.presentPreview(animated: true)
//            }
        }
        func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            
            DispatchQueue.main.async {
                self.myProgressView.progress = progress
                self.progressLabel.text = Int(progress * 100.0).description + "%"
            }
        }
        func storeAndShare(withURLString: String,_ title: String) {
            self.ProgressView.isHidden = false
            self.myProgressView.progress = 0.0
            self.tblView.isUserInteractionEnabled = false
            self.progressLabel.text = "0%"
            session = URLSession(configuration: .background(withIdentifier: UUID.init().uuidString), delegate: self, delegateQueue: OperationQueue.main)
            
            let task = session.downloadTask(with: URL(string: withURLString)!)
            task.resume()
            
//            guard let url = URL(string: withURLString) else { return }
//            /// START YOUR ACTIVITY INDICATOR HERE
//    //        HUD.show()
//            self.startLoadingProgress()
//            URLSession.shared.dataTask(with: url) { data, response, error in
//                guard let data = data, error == nil else {
//    //                HUD.hide()
//                    self.finishLoadingProgress()
//                    return
//                }
//                let tmpURL = FileManager.default.temporaryDirectory
//                    .appendingPathComponent(response?.suggestedFilename ?? "fileName.pdf")
//                do {
//                    try data.write(to: tmpURL)
//                } catch {
//                    print(error)
//                }
//                DispatchQueue.main.async {
//    //                HUD.hide()
//                    self.finishLoadingProgress()
//    //                UINavigationBar appearance].tintColor = [UIColor whiteColor];
//                    UINavigationBar.appearance().tintColor = .black
//                    self.documentController.url = tmpURL
//                    self.documentController.presentPreview(animated: true)
//                }
//                }.resume()
        }
    
    
}

class City : UITableViewCell{
    @IBOutlet weak var lblCity: UILabel!
}
class PersonCell : UITableViewCell{
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var lblName: UILabel!
}
class HistoryCell : UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var imgView: UIImageView!
}
