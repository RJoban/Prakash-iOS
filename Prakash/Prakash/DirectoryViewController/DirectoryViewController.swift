//
//  DirectoryViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 07/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import ImageSlideshow
import SafariServices
class DirectoryViewController: UIViewController,UISearchBarDelegate {

    @IBOutlet weak var slideshow: ImageSlideshow!
    @IBOutlet weak var slideShowHeight: NSLayoutConstraint!
    
    
    var arrBanner = [[String : AnyObject]]()
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var tblViewTop: NSLayoutConstraint!
    
    @IBOutlet weak var customTitleLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!

    var data = [String]()
    var filteredData = [[String : AnyObject]]()

    var arrResults = [[String : AnyObject]]()
    var city = ""
    var categories = ""
    var categoryName = ""
    var currentBanner = 0
    @objc func didTap() {
        print(bannerNavigationUrls[currentBanner])
        guard bannerNavigationUrls[currentBanner] != "#" && bannerNavigationUrls[currentBanner] != "*" && bannerNavigationUrls[currentBanner] != "" else { return }
        if let url = URL(string: bannerNavigationUrls[currentBanner]) {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
              
              let vc = SFSafariViewController(url: url, configuration: config)
            present(vc, animated: true)
        }
      
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        slideshow.addGestureRecognizer(gestureRecognizer)
        slideshow.currentPageChanged = { (index : Int) -> () in
            self.currentBanner = index
        }
        slideshow.slideshowInterval = 5.0
        slideshow.contentScaleMode = UIView.ContentMode.scaleToFill
        slideshow.activityIndicator = DefaultActivityIndicator(style: .gray, color: .black)
        
        slideShowHeight.constant = 0
        searchBar.delegate = self
        // Do any additional setup after loading the view.
        searchView.isHidden = false
        if city == "" {
            topView.isHidden = true
            topViewHeightConstraint.constant = 0
            //tblViewTop.constant = 0
        } else {
            topView.isHidden = false
            //tblViewTop.constant = 50
            topViewHeightConstraint.constant = 50
        }
        customTitleLabel.text = ""
        if city.length < 1{
            getAllDirectory()
        }else if city.length > 0 && categories.length > 0{
            customTitleLabel.text = categoryName.capitalized
            slideShowHeight.constant = self.view.frame.width / 2.083
            self.getAllBanner()
            getCategoriesByCategories()
        }else{
            getCategoriesByCity()
            tblView.separatorStyle = .singleLine
        }
        let clipBtn: UIButton = UIButton(type: .custom)
        //        clipBtn.setImage(clipImage, forState: UIControlState.Normal)
        clipBtn.addTarget(self, action: #selector(openPressNoteViewController), for: UIControl.Event.touchUpInside)
        clipBtn.setTitleColor(UIColor.red, for: .normal)
//        clipBtn.setTitle("Add Directory", for: .normal)
        clipBtn.setImage(UIImage(named: "ic_d"), for: .normal)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 65, height: 40)
        clipBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clipBtn.widthAnchor.constraint(equalToConstant: 65)
        ])
        clipBtn.imageView!.contentMode = .scaleAspectFit
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        self.navigationItem.setRightBarButtonItems([clipBarBtn], animated: false)
        tblView.register(UITableViewCell.self, forCellReuseIdentifier: "cell3")
        searchView.isHidden = true
        setupSearchTextField()
    }
    
    func setupSearchTextField() {
        
        
        //searchBar.setSearchFieldBackgroundImage(UIImage(), for: .normal)
        searchBar.setImage(UIImage(), for: .search, state: .normal)
        UILabel.appearance(whenContainedInInstancesOf: [UISearchBar.self]).textColor = .white
        
                let textFieldInsideSearchBar = searchBar.value(forKey: "searchField") as! UITextField
                textFieldInsideSearchBar.textColor = UIColor.white
                //textFieldInsideSearchBar.backgroundColor = .black
                
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
        
        self.navigationController?.navigationBar.isHidden = true

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
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       // self.navigationController?.navigationBar.isHidden = false

    }
    @objc func openPressNoteViewController(){
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddDirectoryViewController") as! AddDirectoryViewController
       
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func getAllDirectory(){
        let apiName = APIName.alldirectories
        
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: [:]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    self!.filteredData = self!.arrResults
                    strongSelf.tblView.reloadData()
                    
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
                }
            }
            
            
        }
        
    }
    func getCategoriesByCity(){
        let apiName = APIName.directories
        let param = ["city" : city]
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    
                    self!.arrResults = self!.arrResults.sorted(by: { (item1, item2) -> Bool in
                        (item1["name"] as! String) < (item2["name"] as! String)
                    })
                    self!.filteredData = self!.arrResults
                    strongSelf.tblView.reloadData()
                    
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
                }
            }
            
            
        }
    }
    var bannerNavigationUrls = [String]()
    func getAllBanner(){
            let apiName = APIName.slider
            
            let param = ["page" : "Directory"]
            
            APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrBanner = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    var kingFisherSource = [KingfisherSource]()
                    strongSelf.bannerNavigationUrls = []
                    strongSelf.arrBanner = strongSelf.arrBanner.shuffled()
                    
                    for dict in strongSelf.arrBanner{
                        if (dict["pagetype"] as? String ?? "").lowercased() != "exit"{
                            if let category = dict["category"] as? String, let city = dict["city"] as? String {
                                if strongSelf.categories == category && strongSelf.city == city {
                                    strongSelf.bannerNavigationUrls.append(dict["url"] as? String ?? "#")
                                    kingFisherSource.append(KingfisherSource(url: URL(string:(AppConfig.baseImageURL + (dict["sliderimage"] as? String ?? "")))!))
                                }
                            } else if let city = dict["city"] as? String {
                                if strongSelf.city == city {
                                    strongSelf.bannerNavigationUrls.append(dict["url"] as? String ?? "#")
                                    kingFisherSource.append(KingfisherSource(url: URL(string:(AppConfig.baseImageURL + (dict["sliderimage"] as? String ?? "")))!))
                                }
                            }
                        }
                        
                    }
                    if kingFisherSource.count == 0 {
                        strongSelf.slideShowHeight.constant = 0
                    }
                    //kingFisherSource = kingFisherSource.shuffled()
                    strongSelf.slideshow.setImageInputs(kingFisherSource)
                    
                } else {
                    guard let strongSelf = self else {return}
                    strongSelf.slideShowHeight.constant = 0
                    print(response)
                }
                
            }
            
        }
    func getCategoriesByCategories(){
        let apiName = APIName.directoriesByCity
        let param = ["city" : city , "category" : categories]
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    //_id
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    strongSelf.arrResults = response?["data"] as? [[String : AnyObject]] ?? [[String : AnyObject]]()
                    self?.filteredData = self!.arrResults
                    strongSelf.tblView.reloadData()
                    
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
                }
            }
            
            
        }
    }
}
extension DirectoryViewController : UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let directoryVC = self.storyboard?.instantiateViewController(withIdentifier: "DirectoryViewController") as! DirectoryViewController
        
        if city.length < 1{
            
            self.navigationController?.navigationBar.isHidden = true
            topView.isHidden = false
            directoryVC.city = filteredData[indexPath.section]["_id"] as? String ?? ""
        }else if categories.length < 1{
            directoryVC.city = city
            directoryVC.categoryName = filteredData[indexPath.section]["name"] as? String ?? ""
            directoryVC.categories = filteredData[indexPath.section]["_id"] as? String ?? ""
        }else{
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
        }
        self.navigationController?.pushViewController(directoryVC, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if city.length < 1{
            return 60
        }else if city.length > 0 && categories.length > 0{
            return 85
        }else{
            return 50
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredData.removeAll()
        for obj1 in arrResults
        {
            //var arr = obj1
            
            //print(obj1)
            obj1.filter { (key,val) -> Bool in
                print(key)
                print(val)
                if let value = val as? String {
                    if key != "_id" && (value).range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
                    {
                     filteredData.append(obj1)
                     }
                }
                
                return true
            }
        }
        if filteredData.count == 0 {
            filteredData = arrResults
        }
        tblView.reloadData()
    }

}
extension DirectoryViewController : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return filteredData.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if city.length < 1{
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DirectoryCell
            cell.lblName.text = (filteredData[indexPath.section]["name"] as? String)?.capitalized ?? ""
            cell.lblName.superview?.layer.cornerRadius = 4
            cell.contentView.backgroundColor = .clear
            cell.contentView.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius:2, scale: true)
        return cell
        }else if city.length > 0 && categories.length > 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath) as! DirectoryCityCell
            cell.lblName.text = (filteredData[indexPath.section]["name"] as? String ?? "").capitalized
            cell.lblAddress.text = (filteredData[indexPath.section]["city"]?["name"] as? String ?? "").capitalized
            cell.lblPhone.text = (filteredData[indexPath.section]["number"] as? String ?? "")
            cell.lblName.superview?.layer.cornerRadius = 4
            cell.contentView.backgroundColor = .clear
            cell.contentView.dropShadow(color: .black, opacity: 0.2, offSet: CGSize(width: -1, height: 1), radius:2, scale: true)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
            cell.selectionStyle = .none
            cell.textLabel!.text = (filteredData[indexPath.section]["name"] as? String ?? "").capitalized
            if cell.textLabel!.text == ""
            {
                cell.textLabel!.text = (filteredData[1]["name"] as? String ?? "").capitalized

            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if city.length > 0 && categories.length > 0 {
            return 5
        }
        return 0
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if city.length == 0{
            topView.isHidden = true
        }
        else
        {
            topView.isHidden = false
            self.navigationController?.navigationBar.isHidden = true

        }
    }
}
class DirectoryCell : UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
}
class DirectoryCityCell : UITableViewCell{
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblPhone: UILabel!
}

