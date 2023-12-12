//
//  LoginVM.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 18.11.2023.
//

import Foundation
import Firebase
import FirebaseAuth

class LoginVM{
    let authService = AuthManager()
    func signInUser(email: String, password: String, completion: @escaping (Result<String, Error>) -> Void) {
        authService.signIn(email: email, password: password) { result in
                    switch result {
                    case .success(let user):
                        completion(.success(user.uid))
                    case .failure(let error):
                        completion(.failure(error))
            }
        }
    }
}
