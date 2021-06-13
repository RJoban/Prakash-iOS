//
//  DetailHistoryViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 09/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import WebKit

class DetailHistoryViewController: UIViewController, WKUIDelegate {

    @IBOutlet weak var webView: WKWebView!
    
    var arrResults = [[String : AnyObject]]()
    var isNewsPaper = true
    var news = ""
    var link = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.uiDelegate = self
        if isNewsPaper{
            getNewpaper()
        }else{
            let url = URL(string: link)
            let requestObj = URLRequest(url: url! as URL)
            webView.load(requestObj)
        }
    }
    
    
    func getNewpaper() {
        
        let apiName = APIName.newspaper
        let param = ["agency" : news]
        APICall.CallAPI(view: appDelegate.window, apiName: apiName, apiMethod: .POST, apiCallTimeKeyName: "0", dictionary: param as [String : Any]) { [weak self] (isSuccess, responseCode, message, response) in
            DispatchQueue.main.async {
                if isSuccess == true {
                    guard let strongSelf = self else {return}
                    
                    print(response as? [String : Any] ?? [String : Any]())
                    let newsPaper = (response?["data"] as? [[String : Any]] ?? [[String : Any]]()).first
                    
                    let url = URL(string: AppConfig.baseImageURL + (newsPaper?["image"] as? String ?? ""))
                    let requestObj = URLRequest(url: url! as URL)
                    strongSelf.webView.load(requestObj)
                    
                } else {
                    guard let strongSelf = self else {return}
                    print(response)
                }
            }
        }
    }
}
