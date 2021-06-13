//
//  NotificationDetailViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 10/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit
import Kingfisher

class NotificationDetailViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var tvDescription: UITextView!
    
    var imgURL = ""
    var strTitle = ""
    var strDesc = ""
    @IBOutlet weak var imgHeight: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.title = "Notification"
        // Do any additional setup after loading the view.
        lblTitle.text = strTitle
        tvDescription.text = strDesc
        self.imgHeight.constant = 0
        
        self.imageView.kf.setImage(with: URL(string:imgURL), placeholder: nil, options: nil) { (result: Result<RetrieveImageResult, KingfisherError>) in
            DispatchQueue.main.async {
                guard let source = try? result.get() else { return }
                self.imgHeight.constant = source.image.size.height * (self.imageView.bounds.width / source.image.size.width)
            }
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
