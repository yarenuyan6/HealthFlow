//
//  ProfileDetailsVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 17.11.2023.
//

import Foundation
import Firebase
import FirebaseFirestore

enum PersonalDetailsPageTypes{
    case gender
    case height
    case weight
    case age
}


class PersonalDetailsVM {
    let initialHeightIndex = 50
    let initialWeightIndex = 40
    let initialDate: Date = Date()
    let dateFormatter = DateFormatter()
    var userModel: UserModel
    var loginModel: LoginModel
    var personalDetailsPageType : PersonalDetailsPageTypes!
    
    init(user: UserModel, loginModel: LoginModel) {
        self.userModel = user
        self.loginModel = loginModel
        dateFormatter.dateFormat = "yyyy-MM-dd"
    }

    var selectedHeight: Int!{
        didSet{
            self.userModel.height = selectedHeight
        }
    }
    var selectedWeight: Int! {
        didSet{
            self.userModel.weight = selectedWeight
        }
    }
    
    var selectedDate: String!{
        didSet{
            self.userModel.birthDate = selectedDate
        }
    }
    
    let genders = ["Female", "Male", "Other"]
    let weights: [Int] = {
        var weights = [Int]()
        for i in 0...200 {
            weights.append((i))
        }
        return weights
    }()
    
    let heights: [Int] = {
        var heights = [Int]()
        for i in 100...250 {
            heights.append(i)
        }
        return heights
    }()
    
    //MARK: Setting information methods
    func setGender(gender:String){
        userModel.gender = gender
    }
    
    func setHeight(height:Int){
        userModel.height = height
    }
    
    func setWeight(weight:Int){
        userModel.weight = weight
    }
    
    func setBirthDate (birthDate: String){
        userModel.birthDate = birthDate
    }
    
    //MARK: Register
    func register(userModel: UserModel, loginModel: LoginModel){
        AuthManager.shared.signUp(email: loginModel.email,
                                  password: loginModel.password){ [weak self] result in
            switch result{
            case .success(let user):
                
                func userToMap(user: UserModel) -> [String: Any] {
                    return [
                        "name": user.name,
                        "lastName": user.lastName,
                        "gender": user.gender,
                        "height": user.height,
                        "weight": user.weight,
                        "birthDate": user.birthDate
                    ]
                }
                
                
                let db = Firestore.firestore()
                let userRef = db.collection("users").document(user.uid)
                
                userRef.setData(userToMap(user: userModel), merge: true) { error in
                    if let error = error {
                        print("Kullanıcı verisi eklenirken hata oluştu: \(error.localizedDescription)")
                    } else {
                        print("Kullanıcı verisi başarıyla eklendi.")
                        do {
                                   try Auth.auth().signOut()
                               } catch let signOutError as NSError {
                                   print ("Error signing out: %@", signOutError)
                               }
                    }
                }

            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
}
