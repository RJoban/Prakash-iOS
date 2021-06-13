//
//  WelcomeViewController.swift
//  Prakash
//
//  Created by apple on 22/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Thread.sleep(forTimeInterval: 3)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        if UserDefaults.standard.value(forKey: "userId") != nil{
            let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            appDelegate.window?.rootViewController = UINavigationController(rootViewController: homeVC)
        } else {
            let loginVC = storyboard.instantiateViewController(withIdentifier: "RegisterViewController") as! RegisterViewController
            appDelegate.window?.rootViewController = loginVC
        }
    }

}
