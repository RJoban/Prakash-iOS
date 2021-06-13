//
//  PrakashDetailViewController.swift
//  Prakash
//
//  Created by Maulik Kundaliya on 07/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit

class PrakashDetailViewController: UIViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    @IBOutlet weak var pageButton: UIPageControl!
    @IBOutlet weak var containerView: UIView!
   
    var pageController: UIPageViewController!
    var arrImages = [[String : AnyObject]]()
    var controllers = [ItemViewController]()
    
    var currentImageIndex: Int = 0{
        didSet {
            self.pageButton.currentPage = currentImageIndex
            
            if !isPageChanged {
                DispatchQueue.main.async {
                    self.pageController.setViewControllers([self.controllers[Int(self.currentImageIndex)]], direction: self.direction, animated: true, completion: nil)
                    
                }
            } else {
                isPageChanged = false
            }
        }
    }
    var direction: UIPageViewController.NavigationDirection!
    
    @objc func shareButtonPressed(sender: UIButton) {
        
        let dict = arrImages[Int(currentImageIndex)]
        downloadImage(from: URL(string:(AppConfig.baseImageURL + (dict["image"] as? String ?? "")))!)
        
    }
    
    var sharableImage: UIImage?
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: URL) {
        print("Download Started")
        getData(from: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                let image = UIImage(data: data)
                let imageToShare = [ image ]
                let activityViewController = UIActivityViewController(activityItems: imageToShare as [Any], applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.view
                activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook]
                
                self.present(activityViewController, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        array = []
        for dict in arrImages {
            array.append((AppConfig.baseImageURL + (dict["image"] as? String ?? "")))
        }
        self.pageButton.numberOfPages = array.count
        setupPageView()

        
        let clipBtn: UIButton = UIButton(type: .custom)
        clipBtn.setImage(UIImage(named: "share"), for: .normal)
        clipBtn.imageView?.contentMode = .scaleAspectFit
        clipBtn.addTarget(self, action: #selector(shareButtonPressed(sender:)), for: UIControl.Event.touchUpInside)
        clipBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        clipBtn.frame = CGRect(x: 0, y: 0, width: 35, height: 35)
        clipBtn.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clipBtn.widthAnchor.constraint(equalToConstant: 35),
            clipBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
        let clipBarBtn = UIBarButtonItem(customView: clipBtn)
        self.navigationItem.setRightBarButtonItems([clipBarBtn], animated: false)
    }
    
    var array = [String]()
    
    func setupPageView() {
        for i in 0..<array.count {
           
            let controller = self.storyboard?.instantiateViewController(withIdentifier: "ItemViewController") as! ItemViewController
            controller.url = array[i]
            controllers.append(controller)
            
            
        }
        
        pageController = UIPageViewController.init(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageController.dataSource = self
        pageController.delegate = self
        pageController.view.frame = self.containerView.bounds
        pageController.setViewControllers([controllers[0]], direction: .forward, animated: true, completion: nil)
        
        self.addChild(pageController)
        self.containerView.addSubview(pageController.view)
        
        
    }
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController as! ItemViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return nil
        }
        
        guard controllers.count > previousIndex else {
            return nil
        }
        direction = .reverse
        
        self.currentIndex = Float(previousIndex)
        return controllers[previousIndex]
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        print(previousViewControllers.count)
        guard let controller = pageViewController.viewControllers?.last as? ItemViewController else { return }
        if let index = self.controllers.index(of: controller) {
            isPageChanged = true
            self.currentImageIndex = index
        }
        
    }
    var currentIndex: Float = 0.0
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = controllers.firstIndex(of: viewController as! ItemViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let orderedViewControllersCount = controllers.count

        guard orderedViewControllersCount != nextIndex else {
            return nil
        }
        
        guard orderedViewControllersCount > nextIndex else {
            return nil
        }
        direction = .forward
        self.currentIndex = Float(nextIndex)
        return controllers[nextIndex]
    }
    var isPageChanged = false
}
