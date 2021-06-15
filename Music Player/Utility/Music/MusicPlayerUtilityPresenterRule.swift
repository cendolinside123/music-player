//
//  MusicPlayerUtilityPresenterRule.swift
//  Music Player
//
//  Created by Mac on 14/06/21.
//

import Foundation

protocol MusicPlayerUtilityPresenterRule {
    func pause()
    func seek(value: Float)
    func setup(getMusic: Music)
    func play()
    func stop()
    func setCurrentURL(url:String)
    func togglePlayPause()
    func returnCurrentDuration() -> Double
    func returnCurrentTimeProgress() -> Double
    var updateDuration: ((Double) -> ())? { get set }
    var updateTimeElapsed: ((_ timeProgres: Double,_ percent: Double) -> ())? { get set }
    var updateCurrentBuffer: ((Double) -> ())? { get set }
    var updateStatePlayer: ((PlayerState) -> ())? { get set }
}

protocol MusicPlayerUtilityPresenterPrivateRule {
    var currentURL:String { get set }
    var currentDuration:Double { get set }
    var currentTimeProgress:Double { get set }
    var currenState: PlayerState { get set }
}
