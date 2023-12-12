//
//  LoginVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 13.11.2023.
//

import UIKit
import Firebase
class LoginVC: UIViewController {

    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTexkField: CustomTextField!
    @IBOutlet weak var loginButton: CustomButton!
    
    let viewModel = LoginVM()
//    let authService = AuthManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        loginButton.isEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(signUpLabelTapped))
        signUpLabel.addGestureRecognizer(tapGesture)
        signUpLabel.isUserInteractionEnabled = true
    }
    
    //MARK: Sign In
    @IBAction func loginButtonTapped(_ sender: Any) {
        guard let userEmail = emailTextField.text else {return}
        guard let userPassword = passwordTexkField.text else {return}
        
        viewModel.signInUser(email: userEmail, password: userPassword){result in
            switch result{
            case .success(let userId):
                let mainVM = MainVM(userId: userId)
                    let mainVC = UIStoryboard (name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MainVC") as! MainVC
                    mainVC.viewModel = mainVM
                    self.navigationController?.pushViewController(mainVC, animated: true)
                
            case .failure(let error):
                print("Login failed with error: \(error.localizedDescription)")
            }
        }
    }
    
    private func setUpLabels(){
        forgotPasswordLabel.text = "Forgot Password?"
        signUpLabel.text = "Sign Up Now"
        
        self.underlineLabelText(label: forgotPasswordLabel)
        self.underlineLabelText(label: signUpLabel)
    }
    
    private func underlineLabelText(label:UILabel){
        let attributedString = NSAttributedString(string: label.text ?? "",
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = attributedString
    }
    
    @objc private func signUpLabelTapped(){
        let registerVC = UIStoryboard (name: "Register", bundle: nil).instantiateViewController(withIdentifier: "RegisterVC") as! RegisterVC
        self.navigationController?.pushViewController(registerVC, animated: true)
    }
}
