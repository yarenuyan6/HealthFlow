//
//  AuthenticationService.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 20.11.2023.
//

import Firebase

class AuthManager {
    static let shared = AuthManager()

    func signUp(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user, error == nil {
                completion(.success(user))
                
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let user = authResult?.user, error == nil {
                completion(.success(user))
            } else if let error = error {
                completion(.failure(error))
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
}
