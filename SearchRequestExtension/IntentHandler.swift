//
//  IntentHandler.swift
//  SearchRequestExtension
//
//  Created by Mac on 17/06/21.
//

import Intents

class IntentHandler: INExtension {
    
    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.
        
        if #available(iOSApplicationExtension 12.0, *) {
            if intent is INPlayMediaIntent {
                return SearchRequestHandler()
            }
            else if intent is INSetAudioSourceInCarIntent {
                return self
            }
        } else {
            // Fallback on earlier versions
        }
        
        return self
    }
    
}
