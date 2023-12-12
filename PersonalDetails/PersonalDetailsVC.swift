//
//  PersonalDetailsVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 14.11.2023.
//

import UIKit

class PersonalDetailsVC: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var weightPickerView: UIPickerView!
    @IBOutlet weak var heightPickerView: UIPickerView!
    @IBOutlet weak var nextButton: CustomButton!
    @IBOutlet weak var backButtonView: UIImageView!
    @IBOutlet weak var genderStackView: UIStackView!
    @IBOutlet weak var weightStackView: UIStackView!
    @IBOutlet weak var heightStackView: UIStackView!
    @IBOutlet weak var birthDateStackView: UIStackView!
    @IBOutlet weak var firstPageView: UIView!
    @IBOutlet weak var secondPageView: UIView!
    @IBOutlet weak var thirdPageView: UIView!
    @IBOutlet weak var fourthPageView: UIView!
    @IBOutlet weak var maleStackView: UIStackView!
    @IBOutlet weak var femaleStackView: UIStackView!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    var viewModel: ProfileDetailsVM!
//    var user : UserModel!
    var state : Int! = 0 {
        didSet{
            stepFunction()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nextButton.isEnabled = false
        addTapGesture()
        setUpGenderStackViews()
//        setUpButton()
        
        weightPickerView.delegate = self
        weightPickerView.dataSource = self
        weightPickerView.selectRow(viewModel.initialWeightIndex, inComponent: 0, animated: true)
        
        heightPickerView.delegate = self
        heightPickerView.dataSource = self
        heightPickerView.selectRow(viewModel.initialHeightIndex, inComponent: 0, animated: false)
        
        viewModel.selectedHeight = viewModel.heights[viewModel.initialHeightIndex]
        viewModel.selectedWeight = Int(viewModel.weights[viewModel.initialWeightIndex])
        viewModel.selectedDate = viewModel.dateFormatter.string(from: viewModel.initialDate)
        
        birthDatePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
    }
    
    @objc func dateChanged(_ datePicker: UIDatePicker){
        let selectedDate = birthDatePicker.date
        let dateString = viewModel.dateFormatter.string(from: selectedDate)
        viewModel.selectedDate = dateString
    }
    
    
    //MARK: StepFunc
    
    private func stepFunction() {
        switch state {
        case 0:
            viewModel.personalDetailsPageType = .gender
            nextButton.setTitle("Next", for: .normal)
            setUpUI()
            
        case 1:
            viewModel.personalDetailsPageType = .height
            nextButton.setTitle("Next", for: .normal)
            setUpUI()
            
        case 2:
            viewModel.personalDetailsPageType = .weight
            nextButton.setTitle("Next", for: .normal)
            setUpUI()
            
        case 3:
            viewModel.personalDetailsPageType = .age
            setUpUI()
            nextButton.setTitle("Done", for: .normal)
            
        case -1:
            self.navigationController?.popViewController(animated: true)
            
        case 4:
            viewModel.register(userModel: viewModel.userModel, loginModel: viewModel.loginModel)
            let loginVC = UIStoryboard (name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: true)
            
        default:
            break
        }
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  
    }
    
    //MARK: PickerViews

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView{
        case heightPickerView:
            return viewModel.heights.count
        case weightPickerView:
            return viewModel.weights.count
        default:
            return 0
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView{
        case heightPickerView:
            return String(viewModel.heights[row])
        case weightPickerView:
            return String(viewModel.weights[row])
        default:
            return nil
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView{
        case heightPickerView:
            viewModel.selectedHeight = Int(viewModel.heights[row])
        case weightPickerView:
            let selectedWeight = viewModel.weights[row]
            let selectedWeightInt = selectedWeight
            viewModel.setWeight(weight: selectedWeightInt)
        default:
            break
        }
    }
    
    //MARK: Setting UI
    
    private func setUpUI(){
        switch viewModel.personalDetailsPageType {
        case .gender:
            headerLabel.text = "Choose Your Gender"
            birthDateStackView.isHidden = true
            genderStackView.isHidden = false
            heightStackView.isHidden = true
            weightStackView.isHidden = true
            firstPageView.backgroundColor = UIColor(named: "celticBlue")
            secondPageView.backgroundColor = UIColor(named: "taupeGray")
        case .height:
            headerLabel.text = "Provide Your Height"
            birthDateStackView.isHidden = true
            genderStackView.isHidden = true
            heightStackView.isHidden = false
            weightStackView.isHidden = true
            secondPageView.backgroundColor = UIColor(named: "celticBlue")
            thirdPageView.backgroundColor = UIColor(named: "taupeGray")
        case .weight:
            headerLabel.text = "Provide Your Weight"
            birthDateStackView.isHidden = true
            genderStackView.isHidden = true
            heightStackView.isHidden = true
            weightStackView.isHidden = false
            thirdPageView.backgroundColor = UIColor(named: "celticBlue")
            fourthPageView.backgroundColor = UIColor(named: "taupeGray")
        case .age:
            headerLabel.text = "Provide Your Age"
            birthDateStackView.isHidden =  false
            genderStackView.isHidden = true
            heightStackView.isHidden = true
            weightStackView.isHidden = true
            fourthPageView.backgroundColor = UIColor(named: "celticBlue")
        case .none:
            headerLabel.text = "Choose Your Gender"
        }
        
    }
    
    private func setUpGenderStackViews(){
        maleStackView.layer.borderColor = UIColor.celticBlue.cgColor
        maleStackView.layer.borderWidth = 2
        
        femaleStackView.layer.borderColor = UIColor.celticBlue.cgColor
        femaleStackView.layer.borderWidth = 2
    }
    
    private func addTapGesture(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackViewTapped))
        backButtonView.addGestureRecognizer(goBackTapGesture)
        backButtonView.isUserInteractionEnabled = true
        
        let maleViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(maleViewTapped))
        maleStackView.addGestureRecognizer(maleViewTapGesture)
        maleStackView.isUserInteractionEnabled = true
        
        let femaleViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(femaleViewTapped))
        femaleStackView.addGestureRecognizer(femaleViewTapGesture)
        femaleStackView.isUserInteractionEnabled = true
    }
    
    @objc private func goBackViewTapped(){
        state -= 1
    }
    
    @objc private func maleViewTapped(){
        guard let maleLabeltext = maleLabel.text else {return}
        nextButton.isEnabled = true
        maleStackView.backgroundColor = .darkGrayTwo
        femaleStackView.backgroundColor = .whiteOwn
        viewModel.setGender(gender: maleLabeltext)
        
    }
    
    @objc private func femaleViewTapped(){
        guard let femaleLabeltext = femaleLabel.text else {return}
        maleStackView.backgroundColor = .whiteOwn
        femaleStackView.backgroundColor = .darkGrayTwo
        nextButton.isEnabled = true
        viewModel.setGender(gender: femaleLabeltext)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        state += 1
    }
    
//    private func setUpButton(){
//        if nextButton.isEnabled {
//            nextButton.backgroundColor = UIColor.celticBlue
//        }
//        
//        else{
//            nextButton.backgroundColor = UIColor.americanSilver
//        }
//    }
}
