//
//  RegisterVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 14.11.2023.
//

import UIKit

class RegisterVC: UIViewController {

    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var loginLabel: UILabel!
    @IBOutlet weak var nameTextField: CustomTextField!
    @IBOutlet weak var surnameTextField: CustomTextField!
    @IBOutlet weak var emailTextField: CustomTextField!
    @IBOutlet weak var passwordTextField: CustomTextField!
    @IBOutlet weak var confirmPasswordTextField: CustomTextField!
    @IBOutlet weak var nextButton: CustomButton!
    var viewModel = RegisterVM()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        setUpTextFields()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(loginLabelTapped))
        loginLabel.addGestureRecognizer(tapGesture)
        loginLabel.isUserInteractionEnabled = true
        
        passwordTextField.passwordRules = nil
    }
    
    private func setUpLabels(){
        forgotPasswordLabel.text = "Forgot Password?"
        loginLabel.text = "Login Now"
        
        self.underlineLabelText(label: forgotPasswordLabel)
        self.underlineLabelText(label: loginLabel)
    }
    
    private func setUpTextFields(){
        passwordTextField.addTarget(self, action: #selector(passwordControl), for: .editingChanged)
        confirmPasswordTextField.addTarget(self, action: #selector(passwordControl), for: .editingChanged)
    }
    
   @objc private func passwordControl(){
        guard let password = passwordTextField.text else {return}
        guard let confirmedPassword = confirmPasswordTextField.text else {return}
        
        if password.count>0 && password == confirmedPassword {
            nextButton.isEnabled = true
        }
        
        else{
            nextButton.isEnabled = false
        }
    }
    
    
    private func underlineLabelText(label:UILabel){
        let attributedString = NSAttributedString(string: label.text ?? "",
                                                  attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
        label.attributedText = attributedString
    }
    
   @objc private func loginLabelTapped(){
       self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        let personalDetailsVC = UIStoryboard (name: "PersonalDetails", bundle: nil).instantiateViewController(withIdentifier: "PersonalDetailsVC") as! PersonalDetailsVC
        personalDetailsVC.viewModel = viewModel.getProfileDetailsVM(to: emailTextField.text ?? "",
                                                                    password: passwordTextField.text ?? "",
                                                                    name: nameTextField.text ?? "" ,
                                                                    surname: surnameTextField.text ?? "")
        self.navigationController?.pushViewController(personalDetailsVC, animated: true)
    }
}
