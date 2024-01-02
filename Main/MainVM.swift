//
//  MainVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 27.11.2023.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class MainVM{
    var userId: String
    var userModel: UserModel?
    var name: String?
    var surname: String?
    var gender: String?
    var weight: Int?
    var height: Int?
    var birthDate: String?
    let waterVM: WaterVM!
    
    init(userId: String) {
        self.userId = userId
        //        saveFood()
        self.waterVM = WaterVM()
    }
    
    func calculateBMI(height:Int, weight:Int) -> String{
        let heightInMeters = Double(height) / 100.0
        let bmi = Double(Double(weight) / (heightInMeters * heightInMeters))
        let roundedBmi = String(format: "%.2f", bmi)
        return roundedBmi
    }
    
    
    func getUserInfo(completion: @escaping (UserModel?, Error?) -> Void){
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(userId)
        
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let name = data?["name"] as? String,
                   let lastName = data?["lastName"] as? String,
                   let gender = data?["gender"] as? String,
                   let height = data?["height"] as? Int,
                   let weight = data?["weight"] as? Int,
                   let birthDate = data?["birthDate"] as? String {
                    
                    self.userModel = UserModel(name: name,
                                               lastName: lastName,
                                               gender: gender,
                                               height: height,
                                               weight: weight,
                                               birthDate: birthDate,
                                               uid: self.userId)
                    
                    completion(self.userModel,nil)
                }
                
            } else {
                let error = NSError(domain: "", code: 1, userInfo: [NSLocalizedDescriptionKey: "Belge alınamadı veya hata oluştu: \(error?.localizedDescription ?? "Bilinmeyen Hata")"])
                completion(nil,error)
            }
        }
    }
    
    
    func getWaterInfo(completion: @escaping (Result<(totalMl: Int, idealIntakeWater: Int), Error>) -> Void) {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()
        
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let endOfDay = Calendar.current.date(byAdding: .day, value: 1, to: startOfDay)!
        
        var totalMl = 0
        var idealIntakeWater = Int(waterVM.idealWaterIntake ?? 0)
        
        let waterEntriesCollectionRef = db.collection("water").document(uid).collection("waterEntries")
        waterEntriesCollectionRef
            .whereField("date", isGreaterThanOrEqualTo: startOfDay)
            .whereField("date", isLessThan: endOfDay)
            .order(by: "date", descending: true)
            .limit(to: 1)
            .getDocuments { (querySnapshot, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            for document in querySnapshot?.documents ?? [] {
                if let totalMlValue = document.data()["totalMl"] as? Int {
                    totalMl = totalMlValue
                }
                
                if let idealIntakeValue = document.data()["idealWater"] as? Int {
                    idealIntakeWater = Int(Double(idealIntakeValue))
                }
            }
            completion(.success((totalMl, idealIntakeWater)))
        }
    }
}
