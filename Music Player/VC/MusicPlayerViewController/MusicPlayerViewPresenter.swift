//
//  MusicPlayerViewPresenter.swift
//  Music Player
//
//  Created by Mac on 22/04/21.
//

import Foundation
import UIKit

class MusicPlayerViewPresenter: NSObject {
    private var view: MusicPlayerViewController? = nil
    
    private var listOfMusic = [Music]()
    private var queue: Queue? = nil
    private var currentIndex:Int = 0
    private var musicPlayerCoreData: CoreDataMusicProtocol? = nil
    private var currentState:PlayerState = .Stop
    //private var currentQueue = [Music]()
    var playerState: ((PlayerState) -> ())? = nil
    private var isRepeat: Bool = false
    
    private var currentBuffer:Double = 0.0
    private var musicPlayerUtil = MusicPlayerUtility.shared
    
    //private var currentItemIndex:Int = 0
    
    override init() {
        super.init()
    }
    
    convenience init(view:MusicPlayerViewController) {
        self.init()
        self.view = view
        queue = Queue(coreData: self.view?.returnCoreDataStack())
        self.view?.getNowPlaying().register(NowPlayingCollectionViewCell.self, forCellWithReuseIdentifier: "nowPlaying")
        self.view?.getNowPlaying().delegate = self
        self.view?.getNowPlaying().dataSource = self
        musicPlayerCoreData = CoreDataMusic()
        
        self.view?.doUpdate = { [weak self] in
            self?.updateQueue_data()
        }
        
        musicPlayerUtil.updateCurrentBuffer = { buffer in
            
        }
        
        musicPlayerUtil.updateDuration = { getDuration in
            let hour = Int(getDuration)/3600 >= 10 ? "\(Int(getDuration)/3600)" : "0\(Int(getDuration)/3600)"
    
            let minute = (Int(getDuration)%3600) / 60 >= 10 ? "\((Int(getDuration)%3600) / 60)" : "0\((Int(getDuration)%3600) / 60)"
    
            let second = (Int(getDuration)%3600) % 60 >= 10 ? "\((Int(getDuration)%3600) % 60)" : "0\((Int(getDuration)%3600) % 60)"
    
            self.view?.getLabelDuration().text = "\(hour):\(minute):\(second)"

        }
        
        musicPlayerUtil.updateStatePlayer = { getPlayerState in
            self.currentState = getPlayerState
            if getPlayerState == .Stop || getPlayerState == .Pause {
                
                if getPlayerState == .Stop {
                    let indexPath = IndexPath(item: self.currentIndex, section: 0)
                    guard let cell = self.view?.getNowPlaying().cellForItem(at: indexPath) as? NowPlayingCollectionViewCell else {
                        return
                    }
                    cell.reset_rotation?()
                    
                    if (self.musicPlayerUtil.returnCurrentTimeProgress() / self.musicPlayerUtil.returnCurrentDuration()) >= 0.99 {
                        print("player finish")
                        self.moveNextQueue()
                    }
                    
                }
                
                self.view?.getButtonPlayPause().setTitle("Play", for: .normal)
            } else {
                self.view?.getButtonPlayPause().setTitle("Pause", for: .normal)
            }
            self.playerState?(getPlayerState)
        }
        
        musicPlayerUtil.updateTimeElapsed = { getProgress , getPercent in
            let hour = Int(getProgress)/3600 >= 10 ? "\(Int(getProgress)/3600)" : "0\(Int(getProgress)/3600)"
            
            let minute = (Int(getProgress)%3600) / 60 >= 10 ? "\((Int(getProgress)%3600) / 60)" : "0\((Int(getProgress)%3600) / 60)"
            
            let second = (Int(getProgress)%3600) % 60 >= 10 ? "\((Int(getProgress)%3600) % 60)" : "0\((Int(getProgress)%3600) % 60)"
            
            
            self.view?.getProgressBar().value = Float(getPercent)
            self.view?.getCurrentTimeLabel().text = "\(hour):\(minute):\(second)"
            
            let indexPath = IndexPath(item: self.currentIndex, section: 0)
            guard let cell = self.view?.getNowPlaying().cellForItem(at: indexPath) as? NowPlayingCollectionViewCell else {
                return
            }
            cell.in_rotateImage?()
        }
        
        
        
        updateQueue_data()
        
    }
    
    
}

extension MusicPlayerViewPresenter:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfMusic.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlaying", for: indexPath) as? NowPlayingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.setImage(image: UserDefaults.standard.string(forKey: "nowPlayingImage") ?? "")
        
        cell.doPrepareRotate = { [weak self] in
            self?.pause()
        }
        
        cell.doRotate = { [weak self] value in
            if self?.view?.returnProgressBar().value != 0 || self?.view?.returnProgressBar().value != 100{
                
                self?.view?.returnProgressBar().value = (self?.view?.returnProgressBar().value)! + Float(value)
                
                
                
            }
        }
        
        cell.doRotateEnd = { [weak self] in
            self?.seek(value: (self?.view?.returnProgressBar().value)!)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "nowPlaying", for: indexPath) as? NowPlayingCollectionViewCell else {
            return
        }
        
        cell.returnImageView().kf.cancelDownloadTask()
        
    }
    
}

extension MusicPlayerViewPresenter: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print("frame width cell: \(self.view!.getNowPlaying().frame.width)")
        
        return CGSize(width: ((self.view!.getNowPlaying().frame.width - 20)), height: (self.view!.getNowPlaying().frame.height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
}

extension MusicPlayerViewPresenter {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        moveQueue()
    }
    
    private func moveQueue() {
        print("index - current index: \(currentIndex)")
        
        let oldMusic = listOfMusic[currentIndex]
        
        if let visibleCell = self.view?.getNowPlaying().visibleCells {
            for cell in visibleCell {
                let indexPath = self.view?.getNowPlaying().indexPath(for: cell)
                
                self.view?.setSongInfo(music: listOfMusic[indexPath!.row])
                
                print("listOfMusic item :\(listOfMusic[indexPath!.row].title) , index: \(indexPath!.row)")
                
                currentIndex = indexPath!.row
                
                print("index - current index updated: \(currentIndex)")
            }
        }
        
        let newMusic = listOfMusic[currentIndex]
        
        guard oldMusic.title != newMusic.title else {
            print("lagu sama")
            return
        }
        
        var temp = QueueTemp.queue
        let getNew = temp.firstIndex(where: { $0.title == newMusic.title })!
        let element = temp.remove(at: getNew)
        temp.insert(element, at: 0)
        let getOld = temp.firstIndex(where: { $0.title == oldMusic.title })!
        let element2 = temp.remove(at: getOld)
        temp.insert(element2, at: temp.count)
        
        QueueTemp.queue = temp
        reSetupCoreDataQueue()
        
        musicPlayerUtil.setCurrentURL(url: newMusic.url)
        musicPlayerUtil.setup(getMusic: newMusic)
        musicPlayerUtil.play()
    }
    
    
    private func reSetupCoreDataQueue() {
        self.view?.returnCoreDataStack()?.doInBackground(managedContext: { [weak self] context in
            self?.musicPlayerCoreData?.deleteAllSong(managedContext: context, success: {
                self?.musicPlayerCoreData?.addAllSong(managedContext: context, musics: QueueTemp.queue, success: {
                    print("success update urutan queue")
                    self?.view?.doUpdateQueue?()
                }, failed: {
                    print("gagal update urutan queue")
                })
            }, failed: {
                print("failed update queue")
            })
        })
    }
    
}

extension MusicPlayerViewPresenter: MusicPlayerViewPresenterRule {
    
    func moveToSelectedQueue(song:Music) {
        
        musicPlayerUtil.setCurrentURL(url: song.url)
        
        
        let getIndex = listOfMusic.firstIndex(where: { $0.title == song.title })!
        
        self.view?.getNowPlaying().scrollToItem(at: IndexPath(item: getIndex, section: 0), at: .centeredHorizontally, animated: true)
        self.currentIndex = getIndex
        self.view?.setSongInfo(music: listOfMusic[getIndex])
        self.view?.doUpdateQueue?()
        
        musicPlayerUtil.setup(getMusic: song)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
            self.musicPlayerUtil.play()
            
        })
        
    }
    
    
    func moveNextQueue() {
        let oldMusic = listOfMusic[currentIndex]
        
        if currentIndex + 1 < listOfMusic.count {
            self.view?.getNowPlaying().scrollToItem(at: IndexPath(item: currentIndex + 1, section: 0), at: .centeredHorizontally, animated: true)
            //moveQueue()
            
            self.view?.setSongInfo(music: listOfMusic[currentIndex + 1])
            currentIndex = currentIndex + 1
            
            let newMusic = listOfMusic[currentIndex]
            var temp = QueueTemp.queue
            let getNew = temp.firstIndex(where: { $0.title == newMusic.title })!
            let element = temp.remove(at: getNew)
            temp.insert(element, at: 0)
            let getOld = temp.firstIndex(where: { $0.title == oldMusic.title })!
            let element2 = temp.remove(at: getOld)
            temp.insert(element2, at: temp.count)
            
            QueueTemp.queue = temp
            reSetupCoreDataQueue()
            musicPlayerUtil.setCurrentURL(url: newMusic.url)
            musicPlayerUtil.setup(getMusic: newMusic)
            musicPlayerUtil.play()
            
            //note: diberi delay karena saat pindah ke queue selanjutnya terjadi masalah pada player (lagu tidak play) yg menyebabkan player harus toggle music playernya, untuk menangani hal tersebut maka dibuat delay
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
//                MusicPlayer.sharedInstance.play()
                self.musicPlayerUtil.play()
            })
            
        } else {
            if isRepeat != false {
                //currentState = .Stop
                
                self.view?.getNowPlaying().scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
                //moveQueue()
                
                self.view?.setSongInfo(music: listOfMusic[0])
                currentIndex = 0
                
                let newMusic = listOfMusic[0]
                
                QueueTemp.queue = listOfMusic
                reSetupCoreDataQueue()
                musicPlayerUtil.setCurrentURL(url: newMusic.url)
                musicPlayerUtil.setup(getMusic: newMusic)
                musicPlayerUtil.play()
                
                //note: diberi delay karena saat pindah ke queue selanjutnya terjadi masalah pada player (lagu tidak play) yg menyebabkan player harus toggle music playernya, untuk menangani hal tersebut maka dibuat delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
    //                MusicPlayer.sharedInstance.play()
                    self.musicPlayerUtil.play()
                })
                
            }
        }
        
    }
    
    func movePrevQueue() {
        let oldMusic = listOfMusic[currentIndex]
        
        //moveQueue()
        
        if currentIndex - 1 >= 0 {
            self.view?.getNowPlaying().scrollToItem(at: IndexPath(item: currentIndex - 1, section: 0), at: .centeredHorizontally, animated: true)
            self.view?.setSongInfo(music: listOfMusic[currentIndex - 1])
            currentIndex = currentIndex - 1
            
            let newMusic = listOfMusic[currentIndex]
            var temp = QueueTemp.queue
            let getNew = temp.firstIndex(where: { $0.title == newMusic.title })!
            let element = temp.remove(at: getNew)
            temp.insert(element, at: 0)
            let getOld = temp.firstIndex(where: { $0.title == oldMusic.title })!
            let element2 = temp.remove(at: getOld)
            temp.insert(element2, at: temp.count)
            
            QueueTemp.queue = temp
            reSetupCoreDataQueue()
            
            musicPlayerUtil.setCurrentURL(url: newMusic.url)
            musicPlayerUtil.setup(getMusic: newMusic)
            musicPlayerUtil.play()
        }
        
        
        
        
    }
    
    func updateQueue_data() {
        self.queue?.getQueue(result: { [weak self] list in
            DispatchQueue.main.async {
                self?.listOfMusic = list
                //self?.currentQueue = list
                
                QueueTemp.queue = list
                self?.currentIndex = 0
                
                self?.view?.getNowPlaying().reloadData()
                self?.view?.getNowPlaying().scrollToItem(at: IndexPath(row: 0, section: 0), at: .centeredHorizontally, animated: false)
                
                if let getFirstIndex:Music = list.first {
                    self?.view?.setSongInfo(music: getFirstIndex)
                }
                
            }
        })
    }
    
    
    func playPause() {
        if currentState == .Stop {
            
            self.queue?.getQueue(result: { [weak self] list in
                DispatchQueue.main.async {
                    
                    let getFirstIndex:Music = list.first!
                    
                    self?.musicPlayerUtil.setCurrentURL(url: getFirstIndex.url)
                    self?.musicPlayerUtil.setup(getMusic: getFirstIndex)
                    self?.musicPlayerUtil.play()
                    
                }
            })
            
            
        } else {
            musicPlayerUtil.togglePlayPause()
        }
    }
    
    func seek(value: Float) {
        musicPlayerUtil.seek(value: value)
    }
    
    func pause() {
        musicPlayerUtil.pause()
    }
    
    func toggleRepeat() {
        if isRepeat == true {
            isRepeat = false
            self.view?.setRepeat()
        } else {
            isRepeat = true
            self.view?.setUnRepeat()
        }
    }
    
    func rotateWhenSeek(oldValue:Float,newValue:Float) {
        let indexPath = IndexPath(item: currentIndex, section: 0)
        guard let cell = self.view?.getNowPlaying().cellForItem(at: indexPath) as? NowPlayingCollectionViewCell else {
            return
        }
        
        if oldValue < newValue {
            print("slider increase")
            cell.rotateWhenSeek?(1)
            
        } else if oldValue == newValue {
            print("slider equal")
        } else {
            print("slider decrease")
            cell.rotateWhenSeek?(-1)
        }
        
    }
    
    func closePanelMusicPlayer_WithAnimation(frame:CGRect,isFinish:@escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view?.setViewClosePanel(frame: frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func maximizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish: @escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view?.setMaximizePanel(frame: frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func minimizePanelMusicPlayer_withAnimation(frame:CGRect,duration:Double,isFinish:@escaping (Bool)->()) {
        UIView.animateKeyframes(withDuration: 0.3, delay: 0.0, options: [.allowUserInteraction], animations: {
            self.view?.setMinimizePanel(frame: frame)
        }, completion: { isFinished in
            isFinish(isFinished)
        })
    }
    
    func maximizePanelController(frame:CGRect,animated: Bool, duration: Double, completion: (() -> Void)?){
        
        if animated {
            maximizePanelMusicPlayer_withAnimation(frame: frame, duration: duration, isFinish: { isFinished in
                guard isFinished else {
                    return
                }
                self.view?.setPanelState(state: .isMaximize)
                completion?()
            })
            
        }
        else {
            self.view?.setMaximizePanel(frame: frame)
            self.view?.setPanelState(state: .isMaximize)
            completion?()
        }
        
    }
    
    func minimizePanelController(frame:CGRect,animated: Bool, duration: Double, completion: (() -> Void)?){
        
        if animated {
            minimizePanelMusicPlayer_withAnimation(frame: frame, duration: duration, isFinish: { isFinished in
                guard isFinished else {
                    return
                }
                self.view?.setPanelState(state: .isMinimize)
                completion?()
            })
        } else {
            self.view?.setMinimizePanel(frame: frame)
            self.view?.setPanelState(state: .isMinimize)
            completion?()
        }
        
    }
    
}

