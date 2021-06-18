//
//  MusicPlayerUtility.swift
//  Music Player
//
//  Created by Mac on 14/06/21.
//

import Foundation


class MusicPlayerUtility: MusicPlayerUtilityPresenterRule {
    
    static var shared: MusicPlayerUtilityPresenterRule = MusicPlayerUtility()
    
    var currentURL:String = ""
    var currentDuration:Double = 0.0
    var currentTimeProgress:Double = 0.0
    var currentState:PlayerState = .Stop
    
    var updateTimeElapsed: ((_ timeProgres: Double,_ percent: Double) -> ())? = nil
    var updateCurrentBuffer: ((Double) -> ())? = nil
    var updateDuration: ((Double) -> ())? = nil
    var updateStatePlayer: ((PlayerState) -> ())? = nil
    
    init() {
        MusicPlayer.sharedInstance.playerDelegate = self
        
    }
    
    
}

extension MusicPlayerUtility {
    
    func returnCurrentDuration() -> Double {
        return currentDuration
    }
    
    func returnCurrentTimeProgress() -> Double {
        return currentTimeProgress
    }
    
    func pause() {
        guard currentURL != "" else {
            return
        }
        MusicPlayer.sharedInstance.pause()
    }
    
    func stop() {
        MusicPlayer.sharedInstance.stop()
    }
    
    func seek(value: Float) {
        guard currentURL != "",currentDuration != 0 else {
            return
        }
        
        let seek = Double(value) * currentDuration
        MusicPlayer.sharedInstance.seek(timeTo: seek)
    }
    
    func setup(getMusic: Music) {
        MusicPlayer.sharedInstance.stop()
        MusicPlayer.sharedInstance.getInfo(music: getMusic)
        MusicPlayer.sharedInstance.setSong(url: getMusic.url)
        //MusicPlayer.sharedInstance.play()
    }
    
    func play() {
        DispatchQueue.main.async {
            MusicPlayer.sharedInstance.play()
        }
    }
    
    func setCurrentURL(url: String) {
        DispatchQueue.main.async {
            self.currentURL = url
        }
    }
    
    func togglePlayPause() {
        MusicPlayer.sharedInstance.togglePlayPause()
    }
    
}

extension MusicPlayerUtility: PlayerDelegate {
    func updateProgresTime(time: Double) {
        
        guard currentDuration != 0 else {
            return
        }
        
        currentTimeProgress = time
        let resultTimeProgres = time/currentDuration
        updateTimeElapsed?(time,resultTimeProgres)
    }
    
    func updateDuration(time:Double) {
        currentDuration = time
        updateDuration?(time)
    }
    
    func updateState(state: PlayerState) {
        currentState = state
        
        updateStatePlayer?(state)
        
    }
    
    func updateBuffer(second:Double) {
        
        guard currentDuration != 0 else {
            return
        }
        
        let getBufferResult = second/currentDuration
        
        updateCurrentBuffer?(getBufferResult)
    }
}
