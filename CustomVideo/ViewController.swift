//
//  ViewController.swift
//  CustomVideo
//
//  Created by Nidhi on 1/1/18.
//  Copyright © 2018 CreoleStudios. All rights reserved.
//

import UIKit
import AVFoundation
import AssetsLibrary

class ViewController: UIViewController {
    var avPlayer = AVPlayer()
    var avPlayerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    var strStartTime: NSString = "00:00"
    var sliderValue : UISlider = UISlider()
    var muted : Bool = false
    var isPresented = true
    
    @IBOutlet var lblVideoTime: UILabel!
    @IBOutlet var viewVideo: UIView!
    @IBOutlet var playerSilder: UISlider!
    
    @IBOutlet var btnPlay: UIButton!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        try! AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        
        avPlayerLayer = AVPlayerLayer(player: avPlayer)
        viewVideo.layer.insertSublayer(avPlayerLayer, at: 0)
        
        viewVideo.layoutIfNeeded()
        avPlayerLayer.frame = CGRect.init(x: 0, y: 0, width: viewVideo.frame.size.width, height: viewVideo.frame.size.height)
        
        let videoURL = URL(string: "https://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        let playerItem = AVPlayerItem.init(url: videoURL!)
        avPlayer.replaceCurrentItem(with: playerItem)

        let currentPlayerItem = avPlayer.currentItem
        let duration = currentPlayerItem?.asset.duration
        print("Duration: \(CMTimeGetSeconds(duration!))")
        let seconds : Float64 = CMTimeGetSeconds(duration!)

        let newTime = self.formatTimeFor(seconds: CMTimeGetSeconds(duration!))
        print("New Time: \(newTime)")
        strStartTime = newTime as NSString
        lblVideoTime.text = "00:00" + "/" + (strStartTime as String) as String
        
        //Slider
        playerSilder.minimumValue = 0
        playerSilder.maximumValue = Float(seconds)
        playerSilder.isContinuous = true
        playerSilder.tintColor = UIColor.red
        playerSilder.thumbTintColor = UIColor.clear
        playerSilder.addTarget(self, action: #selector(ViewController.playbackSliderValueChanged(_:)), for: .valueChanged)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval,queue: DispatchQueue.main)
        { (elapsedTime: CMTime) -> Void in
            print("elapsedTime now:", CMTimeGetSeconds(elapsedTime))
            let seconds : Int64 = Int64(CMTimeGetSeconds(elapsedTime))
            self.playerSilder.setValue(Float(seconds), animated: true)
            self.updateTime()
        } as AnyObject

    }
    override func viewWillDisappear(_ animated: Bool) {
        let value = Int(UIInterfaceOrientation.portrait.rawValue)
        UIDevice.current.setValue(value, forKey: "orientation")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avPlayer.play() // Start the playback
    }
    
    override func viewDidLayoutSubviews() {
        viewVideo.layoutIfNeeded()
        avPlayerLayer.frame = CGRect.init(x: 0, y: 0, width: viewVideo.frame.size.width, height: viewVideo.frame.size.height)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // Layout subviews manually
//        avPlayerLayer.frame = viewVideo.frame
    }
    
    deinit {
        avPlayer.removeTimeObserver(timeObserver)
    }
    
     // MARK: - Custom Methods
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
    {
        let seconds : Int64 = Int64(playbackSlider.value)
        let targetTime:CMTime = CMTimeMake(seconds, 1)
        avPlayer.seek(to: targetTime)
        if avPlayer.rate == 0{
            avPlayer.play()
        }
    }
    
    func formatTimeFor(seconds: Double) -> String {
        let result = getHoursMinutesSecondsFrom(seconds: seconds)
        let hoursString = "\(result.hours)"
        var minutesString = "\(result.minutes)"
        if minutesString.characters.count == 1 {
            minutesString = "0\(result.minutes)"
        }
        var secondsString = "\(result.seconds)"
        if secondsString.characters.count == 1 {
            secondsString = "0\(result.seconds)"
        }
        var time = "\(hoursString):"
        if result.hours >= 1 {
            time.append("\(minutesString):\(secondsString)")
        }
        else {
            time = "\(minutesString):\(secondsString)"
        }
        return time
    }
    
    func getHoursMinutesSecondsFrom(seconds: Double) -> (hours: Int, minutes: Int, seconds: Int) {
        let secs = Int(seconds)
        let hours = secs / 3600
        let minutes = (secs % 3600) / 60
        let seconds = (secs % 3600) % 60
        return (hours, minutes, seconds)
    }
    
    func updateTime() {
        // Access current item
        if let currentItem = avPlayer.currentItem {
            // Get the current time in seconds
            let playhead = currentItem.currentTime().seconds
            let duration = currentItem.duration.seconds
            // Format seconds for human readable string
            let strUpdateTime = formatTimeFor(seconds: playhead) as NSString
            lblVideoTime.text = strUpdateTime as String + "/" + (strStartTime as String)
        }
    }
    
    private func updateTimeLabel(elapsedTime: Float64, duration: Float64) {
        let timeRemaining: Float64 = CMTimeGetSeconds(avPlayer.currentItem!.duration) - elapsedTime
        lblVideoTime.text = String(format: "%02d:%02d", ((lround(timeRemaining) / 60) % 60), lround(timeRemaining) % 60)
    }
    
    private func observeTime(elapsedTime: CMTime) {
        let duration = CMTimeGetSeconds(avPlayer.currentItem!.duration)
        let elapsedTime = CMTimeGetSeconds(elapsedTime)
        updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
    }
    
     // MARK: - Actions Methods
    @IBAction func btnPlayClick(_ sender: Any) {
        if avPlayer.rate == 0
        {
            avPlayer.play()
            //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
            btnPlay!.setTitle("Pause", for: UIControlState.normal)
        } else {
            avPlayer.pause()
            //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
            btnPlay!.setTitle("Play", for: UIControlState.normal)
        }
    }
    
    @IBAction func btnBackClick(_ sender: Any) {
        guard let duration = avPlayer.currentItem?.duration else {return}
        let currenTime = CMTimeGetSeconds(avPlayer.currentTime())
        var newTime = currenTime - 5.0
        
        if newTime < 0{
            newTime = 0
        }
        let time : CMTime = CMTimeMake(Int64(newTime*1000), 1000)
        avPlayer.seek(to: time)
        self.updateTime()
    }
    
    @IBAction func btnNextClick(_ sender: Any) {
        guard let duration = avPlayer.currentItem?.duration else {return}
        let currenTime = CMTimeGetSeconds(avPlayer.currentTime())
        let newTime = currenTime + 5.0
        
        if newTime < (CMTimeGetSeconds(duration) - 5.0){
            let time : CMTime = CMTimeMake(Int64(newTime*1000), 1000)
            avPlayer.seek(to: time)
        }
        self.updateTime()
    }
    @IBAction func btnZoomClick(_ sender: Any) {
        if isPresented {
            isPresented = false
            let value = Int(UIInterfaceOrientation.landscapeLeft.rawValue)
            UIDevice.current.setValue(value, forKey: "orientation")
        }else{
            isPresented = true
            let value = Int(UIInterfaceOrientation.portrait.rawValue)
            UIDevice.current.setValue(value, forKey: "orientation")
        }
    }
    
    @IBAction func btnSoundClick(_ sender: Any) {
        if muted{
            avPlayer.volume = 1.0
            muted = false
        }else{
            avPlayer.volume = 0.0
            muted = true
        }
        
    }
}
