//
//  ItemViewController.swift
//  Prakash
//
//  Created by apple on 14/04/20.
//  Copyright © 2020 I. All rights reserved.
//
import UIKit

class ItemViewController: UIViewController, URLSessionDownloadDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var loader: UIProgressView!
    @IBOutlet weak var imgView: UIImageView!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        showImage(url: url)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imgView
    }
    
    func showImage(url: String) {
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue.main)
        
        let task = session.downloadTask(with: URL(string: url)!)
        task.resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        self.loader.isHidden = true
        do {
            self.imgView.image = UIImage(data: try Data.init(contentsOf: location))
        } catch { }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        
        DispatchQueue.main.async {
            self.loader.progress = progress
        }
    }
}
