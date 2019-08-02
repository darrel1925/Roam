//
//  StripeApi.swift
//  Roam
//
//  Created by Darrel Muonekwu on 7/26/19.
//  Copyright © 2019 Darrel Muonekwu. All rights reserved.
//

import Foundation
import Stripe
import FirebaseFunctions

let StripeApi = _StripeApi()

class _StripeApi: NSObject, STPCustomerEphemeralKeyProvider {
    
    func createCustomerKey(withAPIVersion apiVersion: String, completion: @escaping STPJSONResponseCompletionBlock) {
        
        print(UserService.user.stripeId)
        
        // data that our cloud function needs
        let data: [String: Any] = [
            "stripe_version": apiVersion,
            "customer_id": UserService.user.stripeId
        ]
        print("Stripe ID: , ", UserService.user.stripeId)
        
        // invoke our cloud function on back-end
        Functions.functions().httpsCallable("createEphemeralKey").call(data) { (result, error) in
            
            if let error = error {
                debugPrint(error.localizedDescription)
                // protocol comes with completion that take in (jsonResponse, error)
                completion(nil, error)
                return
            }
            
            guard let key = result?.data as? [String: Any] else {
                debugPrint(error!.localizedDescription)
                completion(nil, nil)
                return
            }
            // if everything was successful
            completion(key, nil)
        }
    }   
}
