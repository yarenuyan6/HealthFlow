//
//  LaunchScreenVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 13.11.2023.
//

import UIKit
import Firebase

class OnboardingVC: UIViewController {
    static var foodsArray = [FoodModel]()
    let authService = AuthManager()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        authService.signIn(email: "yarenuyan@gmail.com", password: "Yaren234") { result in
            switch result{
            case .success(let userId):
                let mainVM = MainVM(userId: userId.uid)
                    let mainVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainVC
                    mainVC.viewModel = mainVM
                    self.navigationController?.pushViewController(mainVC, animated: true)
                
            case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
            
            }
            
            getFoods { [weak self] res in
                guard let self = self else { return }
                switch res {
                case .success(let foods):
                    OnboardingVC.foodsArray = foods
                case .failure(let error):
                    print("Error fetching foods: \(error)")
                }
            }
            
        }
        
        func getFoods(completion: @escaping (Result<[FoodModel], Error>) -> Void) {
            let db = Firestore.firestore()
            let foodsRef = db.collection("foods")

            foodsRef.getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                var foods: [FoodModel] = []
                for document in querySnapshot!.documents {
                    do {
                        let jsonData = try JSONSerialization.data(withJSONObject: document.data())
                        let food = try JSONDecoder().decode(FoodModel.self, from: jsonData)
                        foods.append(food)
                    } catch {
                        completion(.failure(error))
                        return
                    }
                }

                completion(.success(foods))
            }
        }
        // Delay of 3 seconds
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
//            let loginVC = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC")
//            self.navigationController?.setViewControllers([loginVC], animated: true)
//        }
    }
}
