//
//  FoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 29.11.2023.
//

import UIKit

protocol FoodVCInterface{
    func setUpProgressViews()
    func updateSelectedFoodModelArray(_ selectedFoodModelArray: [SelectedFoodModel])
    func deleteTableViewRow(indexPath: IndexPath)
}

class FoodVC: UIViewController {
    @IBOutlet weak var foodTableView: UITableView!
    @IBOutlet weak var goBackView: UIImageView!
    @IBOutlet weak var carbsProgressView: UIProgressView!
    @IBOutlet weak var fatProgressView: UIProgressView!
    @IBOutlet weak var proteinProgressView: UIProgressView!
    var viewModel: FoodVM!{
        didSet{
            viewModel.viewInterface = self
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFoodModelArray()
        setUpTableView()
        tapGestures()
        setUpProgressViews()
    }

    private func setUpTableView(){
        foodTableView.register(UINib(nibName: SelectedFoodTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: SelectedFoodTableViewCell.identifier)
        foodTableView.delegate = self
        foodTableView.dataSource = self
        foodTableView.reloadData()
    }
    

    
    private func tapGestures(){
        let goBackTapGesture = UITapGestureRecognizer(target: self, action: #selector(goBackViewTapped))
        goBackView.addGestureRecognizer(goBackTapGesture)
        goBackView.isUserInteractionEnabled = true
    }
    
    @objc func goBackViewTapped(){
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func addFoodButtonTapped(_ sender: Any) {
        let addFoodVC = UIStoryboard (name: "AddFood", bundle: nil).instantiateViewController(withIdentifier: "AddFoodVC") as! AddFoodVC
        addFoodVC.modalPresentationStyle = .overCurrentContext
        addFoodVC.viewModel = viewModel
        addFoodVC.viewModel.foodModelArray = viewModel.foodModelArray
        self.present(addFoodVC, animated: true, completion: nil)
    }
}

extension FoodVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.selectedFoods.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedFoodTableViewCell.identifier) as! SelectedFoodTableViewCell
        cell.indexPath = indexPath.row
        cell.viewModel = viewModel
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FoodVC: FoodVCInterface{
    func setUpProgressViews(){
        carbsProgressView.progress = Float(viewModel.carbsProgress)
        proteinProgressView.progress = Float(viewModel.proteinProgress)
        fatProgressView.progress = Float(viewModel.fatProgress)
    }
    
    func updateSelectedFoodModelArray(_ selectedFoodModelArray: [SelectedFoodModel]){
        self.foodTableView.reloadData()
    }
    
    func deleteTableViewRow(indexPath: IndexPath){
        self.foodTableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
