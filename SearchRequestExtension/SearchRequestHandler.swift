//
//  SerachRequestHandler.swift
//  SearchRequestExtension
//
//  Created by Mac on 17/06/21.
//

import UIKit
import Intents

class SearchRequestHandler: NSObject,INPlayMediaIntentHandling {

    override init() {
        
    }
    
    @available(iOSApplicationExtension 12.0, *)
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        let respose = INPlayMediaIntentResponse(code: .handleInApp, userActivity: nil)
        completion(respose)
    }
    
    
    @available(iOSApplicationExtension 13.0, *)
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        print("\(intent.mediaSearch?.mediaName)")
        
        let song = Repo.gallow_ParkestAlbum[1]
        
        MusicPlayerUtility.shared.setCurrentURL(url: song.url)
        MusicPlayerUtility.shared.setup(getMusic: song)
        MusicPlayerUtility.shared.play()
        
        
        completion([INPlayMediaMediaItemResolutionResult.success(with: INMediaItem(identifier: nil, title: song.title, type: .song, artwork: nil))])
    }

    
    
}
