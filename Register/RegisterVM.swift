//
//  RegisterVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 18.11.2023.
//

import Foundation
import Firebase

class RegisterVM{
    func getProfileDetailsVM(to email:String,
                             password:String,
                             name: String,
                             surname: String) ->ProfileDetailsVM{
        let loginModel = LoginModel(email: email, password: password)
        let userModel = UserModel(name: name, lastName: surname)
        return ProfileDetailsVM(user: userModel, loginModel: loginModel)
    }
}
