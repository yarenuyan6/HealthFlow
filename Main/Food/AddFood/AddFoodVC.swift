//
//  AddFoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 4.12.2023.
//

import UIKit
import Alamofire

protocol FoodTableViewCellDelegate{
    func didTapButtonInCell()
}

class AddFoodVC: UIViewController {

    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var foodTableView: UITableView!
    var viewModel: FoodVM!
    var delegate : TableViewCellDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.getFoodModelArray()
        tapGestures()
        setUpTableView()
        LoadingOverlay.shared.showOverlay(view: self.view)
        loadImages()

//        delegate = TableViewCellDelegate(action:{
//            let amountAddedFoodVC = UIStoryboard (name: "AmountAddedFood", bundle: nil).instantiateViewController(withIdentifier: "AmountAddedFoodVC") as! AmountAddedFoodVC
//                   let navigationController = UINavigationController(rootViewController: amountAddedFoodVC)
//                   navigationController.modalPresentationStyle = .overCurrentContext
//            navigationController.isNavigationBarHidden = true
//                   self.present(navigationController ,animated: true)
//        })
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
          
        viewModel.addSelectedFood()
          
          self.dismiss(animated: true)
    }
    
    func loadImages() {
            guard let imageURLs = viewModel.foodModelArray?.compactMap({ $0.photo }) else {
                return
            }

            var imageLoadCounter = 0

            for imageURL in imageURLs {
                guard let url = URL(string: imageURL) else { continue }

                AF.request(url).responseImage { response in
                    switch response.result {
                    case .success(let image):
                        
                        print("Resim yüklendi: \(image)")

                        imageLoadCounter += 1

                        if imageLoadCounter == imageURLs.count {
                            LoadingOverlay.shared.hideOverlayView()
                        }

                        self.foodTableView.reloadData()

                    case .failure(let error):
                        print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                    }
                }
            }
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
        cell.viewModel.foodModelArray = viewModel.foodModelArray 
        cell.setUpCell()
        
        delegate = TableViewCellDelegate(action:{ [self] in
            let amountAddedFoodVC = UIStoryboard (name: "AmountAddedFood", bundle: nil).instantiateViewController(withIdentifier: "AmountAddedFoodVC") as! AmountAddedFoodVC
            let amountAddedFoodVM = AmountAddedFoodVM()
            amountAddedFoodVC.viewModel = amountAddedFoodVM
                   let navigationController = UINavigationController(rootViewController: amountAddedFoodVC)
                   navigationController.modalPresentationStyle = .overCurrentContext
            navigationController.isNavigationBarHidden = true
            amountAddedFoodVC.viewModel.foodArray = viewModel.foodModelArray
            amountAddedFoodVC.indexPath = cell.indexPath
                   self.present(navigationController ,animated: true)
        })
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
