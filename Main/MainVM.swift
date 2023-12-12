//
//  MainVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 27.11.2023.
//

import Foundation
import FirebaseFirestore

class MainVM{
    let userId: String
    var userModel: UserModel?
    var name: String?
    var surname: String?
    var gender: String?
    var weight: Int?
    var height: Int?
    var birthDate: String?
    
    init(userId: String) {
        self.userId = userId
//        saveFood()
    }
    
    func saveFood(){
        let foodItems = [
            // Original food items
            [
                "name": "Apple",
                "calories": 95,
                "protein": 0.3,
                "fat": 0.2,
                "carbohydrate": 25,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/1/15/Red_Apple.jpg/220px-Red_Apple.jpg"
            ],
            [
                "name": "Banana",
                "calories": 105,
                "protein": 1.1,
                "fat": 0.3,
                "carbohydrate": 23,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Bananas_on_the_tree.jpg/220px-Bananas_on_the_tree.jpg"
            ],
            [
                "name": "Orange",
                "calories": 47,
                "protein": 0.7,
                "fat": 0.1,
                "carbohydrate": 11,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/21/Orange_Fruit.jpg/220px-Orange_Fruit.jpg"
            ],
            [
                "name": "Egg",
                "calories": 78,
                "protein": 6.3,
                "fat": 5,
                "carbohydrate": 0.7,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/Chicken_egg.jpg/220px-Chicken_egg.jpg"
            ],
            [
                "name": "Chicken breast",
                "calories": 165,
                "protein": 31,
                "fat": 3.5,
                "carbohydrate": 0,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/7/72/Chicken_breast.jpg/220px-Chicken_breast.jpg"
            ],
            [
                "name": "Salmon",
                "calories": 206,
                "protein": 21,
                "fat": 13,
                "carbohydrate": 0.5,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/0/04/Salmo_salar_-_Atlantic_salmon.jpg/220px-Salmo_salar_-_Atlantic_salmon.jpg"
            ],
            [
                "name": "Brown rice",
                "calories": 119,
                "protein": 2.6,
                "fat": 0.3,
                "carbohydrate": 25,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/9/9a/Brown_rice.jpg/220px-Brown_rice.jpg"
            ],
            [
                "name": "Whole-wheat bread",
                "calories": 95,
                "protein": 3.1,
                "fat": 1,
                "carbohydrate": 20,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/2/22/Whole-wheat_bread_loaf.jpg/220px-Whole-wheat_bread_loaf.jpg"
            ],
            [
                "name": "Avocado",
                "calories": 200,
                "protein": 2,
                "fat": 15,
                "carbohydrate": 9,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a5/Avocado_fruit.jpg/220px-Avocado_fruit.jpg"
            ],
            [
                "name": "Almond",
                "calories": 160,
                "protein": 6,
                "fat": 14,
                "carbohydrate": 3,
                "photo": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/e4/Almonds.jpg/220px-Almonds.jpg"
            ]
            ]
        
            for foodItem in foodItems {
                let db = Firestore.firestore()
                let foodRef = db.collection("foods").document()

                foodRef.setData(foodItem, merge: true) { error in
                    if let error = error {
                        print("Error adding food item: \(error.localizedDescription)")
                    } else {
                        print("Food item added successfully.")
                    }
                }
            }
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
    
}
