//
//  PlayerVC.swift
//  Prakash
//
//  Created by apple on 18/03/20.
//  Copyright © 2020 Maulik Kundaliya. All rights reserved.
//

import UIKit

class PlayerVC: UIViewController {
    @IBOutlet weak var playerView: YoutubePlayerView!
    var videoId : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        

        _ = URL(string: videoId)
               let playerVars: [String: Any] = [
                   "controls": 1,
                   "modestbranding": 1,
                   "playsinline": 1,
                   "origin": "https://youtube.com"
               ]
               playerView.delegate = self
               playerView.loadWithVideoId(videoId, with: playerVars)
               DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                   self.playerView.play()
               })
               playerView.superview?.isHidden = false
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.landscapeRight, andRotateTo: UIInterfaceOrientation.landscapeRight)
    }

    override func viewWillDisappear(_ animated : Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.AppUtility.lockOrientation(UIInterfaceOrientationMask.portrait, andRotateTo: UIInterfaceOrientation.portrait)
    }
}

extension PlayerVC: YoutubePlayerViewDelegate {
    func playerViewDidBecomeReady(_ playerView: YoutubePlayerView) {
        print("Ready")
        playerView.fetchPlayerState { (state) in
            print("Fetch Player State: \(state)")
        }
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangedToState state: YoutubePlayerState) {
        print("Changed to state: \(state)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didChangeToQuality quality: YoutubePlaybackQuality) {
        print("Changed to quality: \(quality)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, receivedError error: Error) {
        print("Error: \(error)")
    }
    
    func playerView(_ playerView: YoutubePlayerView, didPlayTime time: Float) {
        print("Play time: \(time)")
    }
    
    func playerViewPreferredInitialLoadingView(_ playerView: YoutubePlayerView) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
}
