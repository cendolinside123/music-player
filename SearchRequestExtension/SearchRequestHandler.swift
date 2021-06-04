//
//  SearchRequestHandler.swift
//  SearchRequestExtension
//
//  Created by Mac on 04/06/21.
//

import Foundation
import Intents

class SearchRequestHandler:NSObject, INPlayMediaIntentHandling {
    override init() {
        
    }
    
    @available(iOSApplicationExtension 12.0, *)
    func handle(intent: INPlayMediaIntent, completion: @escaping (INPlayMediaIntentResponse) -> Void) {
        let respose = INPlayMediaIntentResponse(code: .handleInApp, userActivity: .none)
        completion(respose)
    }
    
//    @available(iOSApplicationExtension 12.0, *)
//    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
//        if #available(iOSApplicationExtension 13.0, *) {
//            completion([INPlayMediaMediaItemResolutionResult.unsupported()])
//        } else {
//            // Fallback on earlier versions
//        }
//    }
    
    
    
}

extension SearchRequestHandler {
//    @available(iOSApplicationExtension 13.0, *)
//    func handle(intent: INAddMediaIntent, completion: @escaping (INAddMediaIntentResponse) -> Void) {
//
//        print("\(intent.identifier)")
//
//        completion(INAddMediaIntentResponse(code: INAddMediaIntentResponseCode.failure, userActivity: .none))
//    }
    
    @available(iOSApplicationExtension 13.0, *)
    func resolveMediaItems(for intent: INPlayMediaIntent, with completion: @escaping ([INPlayMediaMediaItemResolutionResult]) -> Void) {
        print("\(intent.mediaSearch?.mediaName)")
        
        completion([INPlayMediaMediaItemResolutionResult.unsupported()])
    }
    
    
}
