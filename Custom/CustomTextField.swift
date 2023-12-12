//
//  CustomTextField.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 13.11.2023.
//

import Foundation
import UIKit

enum TextFieldTypes:Int{
    case defaultTextField //0
    case email // 1
    case password //2
}

class CustomTextField: UITextField{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
        setUpBackground()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpUI()
        setUpBackground()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setUpUI()
        setUpBackground()
    }
    
    private func setUpUI(){
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 5.0
        self.textColor = UIColor.whiteOwn
        self.attributedPlaceholder = NSAttributedString(string: self.placeholder ?? "", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    
    var textFieldType: TextFieldTypes! = .defaultTextField{
        didSet{
            switch textFieldType {
            case .defaultTextField: break
            case .email:
                setUpEmailField()
            case .password:
                setUpPasswordField()
            case .none:
                break
            }
        }
    }
    
    @IBInspectable var textFieldTypeRawValue: Int {
        get {
            return textFieldType.rawValue
        }
        set {
            if let type = TextFieldTypes(rawValue: newValue) {
                textFieldType = type
            }
        }
    }
    
    private func setUpEmailField(){
        //        self.addTarget(self, action: #selector(validateEmail), for: .editingDidEnd)
        self.textContentType = .emailAddress
        keyboardType = .emailAddress
    }
    
    //    @objc private func valideEmail(){
    //        
    //    }
    
    private func setUpPasswordField(){
        addImageView()
        self.passwordRules = nil
        self.isSecureTextEntry = true
    }
    
    private var rightImageView: UIImageView?
    
    private func addImageView(){
        let imageView = UIImageView(image: UIImage(systemName: "eye"))
        imageView.tintColor = UIColor.white
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: frame.height)
        rightImageView = imageView
        rightImageView?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(rightViewTapped))
        rightImageView?.addGestureRecognizer(tapGesture)
        bringSubviewToFront(rightImageView ?? UIImageView())
        insertSubview(rightImageView ?? UIImageView(), at: 1)
    }
    
    @objc private func rightViewTapped(){
        self.isSecureTextEntry.toggle()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        rightImageView?.frame = CGRect(x: frame.width - 32 , y: 0, width: 16, height: frame.height)
        bringSubviewToFront(rightImageView ?? UIImageView())
    }
    
    private func setUpBackground(){
        self.backgroundColor = UIColor.paleViolet.withAlphaComponent(0.1)
    }
    
    
}
