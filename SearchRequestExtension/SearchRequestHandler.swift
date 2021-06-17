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
        let respose = INPlayMediaIntentResponse(code: .handleInApp, userActivity: .none)
        completion(respose)
    }
    
    
    @available(iOSApplicationExtension 13.0, *)
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        print("\(intent.mediaSearch?.mediaName)")
        
        completion([INPlayMediaMediaItemResolutionResult.unsupported()])
    }

    
    
}
