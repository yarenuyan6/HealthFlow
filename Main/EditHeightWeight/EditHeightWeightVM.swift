//
//  EditHeightWeightVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 16.12.2023.
//

import Foundation
import Firebase

class EditHeightWeightVM{
    let userId: String
    let db = Firestore.firestore()
   
    init(userId: String) {
        self.userId = userId
    }
    
    func updateHeight(height:Int){
        let documentReference = db.collection("users").document(userId)
        let updatedData: [String: Any] = [
            "height": height,
            ]
        
        documentReference.updateData(updatedData){  error in
            if let error = error {
                print("Boy güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Boy başarıyla güncellendi.")
            }
        }
    }
    
    func updateWeight(weight: Int){
        let documentReference = db.collection("users").document(userId)
        let updatedData: [String: Any] = [
            "weight": weight,
            ]
        
        documentReference.updateData(updatedData){  error in
            if let error = error {
                print("Kilo güncelleme hatası: \(error.localizedDescription)")
            } else {
                print("Kilo başarıyla güncellendi.")
            }
        }
    }
}
