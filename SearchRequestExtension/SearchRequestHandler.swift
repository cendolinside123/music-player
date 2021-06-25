//
//  SerachRequestHandler.swift
//  SearchRequestExtension
//
//  Created by Mac on 17/06/21.
//

import UIKit
import Intents

class SearchRequestHandler: NSObject,INPlayMediaIntentHandling {
    
    private var coreDataStack: CoreDataStack? = nil
    private var queue: Queue? = nil
    private var coreDataMusic: CoreDataMusicProtocol? = nil

    override init() {
        
    }
    convenience init(coreData: CoreDataStack) {
        self.init()
        coreDataStack = coreData
        
        queue = Queue(coreData: coreDataStack)
        coreDataMusic = CoreDataMusic()
    }
    
    
    func setCoreDataStack(coreData: CoreDataStack) {
        coreDataStack = coreData
    }
    
    @available(iOSApplicationExtension 12.0, *)
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        let respose = INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil)
        completion(respose)
    }
    
    
    @available(iOSApplicationExtension 13.0, *)
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        print("\(intent.mediaSearch?.mediaName)")
        
        
        
//        let song = Repo.gallow_ParkestAlbum[1]
//
//        MusicPlayerUtility.shared.setCurrentURL(url: song.url)
//        MusicPlayerUtility.shared.setup(getMusic: song)
//        MusicPlayerUtility.shared.play()
        
        testPlayQueueSong(doPlay: { music in
            
            MusicPlayerUtility.shared.setCurrentURL(url: music.url)
            MusicPlayerUtility.shared.setup(getMusic: music)
            MusicPlayerUtility.shared.play()
            
            completion([INPlayMediaMediaItemResolutionResult.success(with: INMediaItem(identifier: nil, title: "Gallow", type: .song, artwork: nil))])
        }, doFailed: {
            completion([INPlayMediaMediaItemResolutionResult.unsupported(forReason: .serviceUnavailable)])
        })
        
        
        
    }
    
    private func testPlayQueueSong(doPlay: @escaping (Music) -> () , doFailed: @escaping () -> ()) {
        coreDataStack?.doInBackground(managedContext: { [weak self] context in
            self?.coreDataMusic?.deleteAllSong(managedContext: context, success: {
                self?.coreDataMusic?.addAllSong(managedContext: context, musics: Repo.gallow_ParkestAlbum, success: {
                    self?.queue?.getPlayedSong(result: { result in
                        guard let music = result else {
                            print("failed get now playing")
                            doFailed()
                            return
                        }
                        
                        doPlay(music)
                        
                    })
                }, failed: {
                    
                })
            }, failed: {
                
            })
        })
    }

    
    
}


