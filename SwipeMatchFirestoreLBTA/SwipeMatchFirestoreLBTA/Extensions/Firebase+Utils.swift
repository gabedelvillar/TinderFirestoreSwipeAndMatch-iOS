//
//  Firebase+Utils.swift
//  SwipeMatchFirestoreLBTA
//
//  Created by Gabriel Del VIllar De Santiago on 11/19/19.
//  Copyright © 2019 gdelvillar. All rights reserved.
//

import Firebase

extension Firestore {
    func fetchCurrentUser(completion: @escaping (User?, Error?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, err) in
            if let err = err {
                completion(nil, err)
                return
            }
            
            // fetch our users here
            guard let dictionary = snapshot?.data() else {
                let error = NSError(domain: "com.gdelvill.swipematch", code: 500, userInfo: [NSLocalizedDescriptionKey: "No user found in Firestore"])
                completion(nil, error)
                return
            }
            
            let user = User(dictionary: dictionary)
            completion(user, nil)
        }
    }
}
