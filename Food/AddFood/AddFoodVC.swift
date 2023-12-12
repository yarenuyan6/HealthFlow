//
//  AddFoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 4.12.2023.
//

import UIKit

protocol FoodTableViewCellDelegate{
    func didTapButtonInCell()
}

class AddFoodVC: UIViewController {

    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var foodTableView: UITableView!
    var viewModel: FoodInterface!
    var delegate : TableViewCellDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFoodModelArray()
        tapGestures()
        setUpTableView()
        
        delegate = TableViewCellDelegate(action:{
            let amountAddedFoodVC = UIStoryboard (name: "AmountAddedFood", bundle: nil).instantiateViewController(withIdentifier: "AmountAddedFoodVC") as! AmountAddedFoodVC
                   let navigationController = UINavigationController(rootViewController: amountAddedFoodVC)
                   navigationController.modalPresentationStyle = .overCurrentContext
                   self.present(navigationController ,animated: true)
        })
    }
    
    private func tapGestures(){
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeImgViewTapped))
        closeImageView.addGestureRecognizer(closeTapGesture)
        closeImageView.isUserInteractionEnabled = true
    }
    
    @objc func closeImgViewTapped(){
        self.viewModel.tempSelectedFoods.removeAll()
        self.dismiss(animated: true)
    }
    
    private func setUpTableView(){
        foodTableView.register(UINib(nibName: FoodTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: FoodTableViewCell.identifier)
        foodTableView.delegate = self
        foodTableView.dataSource = self
        foodTableView.reloadData()
    }
    
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        self.dismiss(animated: true)
        viewModel.addSelectedFood()
    }
}

extension AddFoodVC: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.foodModelArray?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FoodTableViewCell.identifier) as! FoodTableViewCell
        cell.indexPath = indexPath.row
        cell.viewModel = viewModel
        cell.delegate = self.delegate
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

class TableViewCellDelegate: FoodTableViewCellDelegate{
    var didTapButtonInCellAction: (() -> Void)?

        init(action: @escaping (() -> Void)) {
            self.didTapButtonInCellAction = action
        }

        func didTapButtonInCell() {
            didTapButtonInCellAction?()
        }
}
