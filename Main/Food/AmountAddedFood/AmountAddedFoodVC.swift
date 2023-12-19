//
//  AmoutAddedFoodVC.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 8.12.2023.
//

import UIKit
import Alamofire
import AlamofireImage

protocol AmountAddedFoodInterface{
    func setUpFoodLabel(foodName:String)
}

class AmountAddedFoodVC: UIViewController {
    
    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var grButton: UIButton!
    @IBOutlet weak var cupButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var closeImageView: UIImageView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    let imageCache = AutoPurgingImageCache()
    var viewModel: AmountAddedFoodVM!
    //    {
    //        didSet{
    //viewModel.amountInterface = self
    //        }
    //    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        tapGestures()
        
        guard let foodImageUrl = viewModel.foodImageUrl else {return}
        setFoodImage(imageURL: foodImageUrl)
    }
    
    private func setUpUI(){
        grButton.layer.borderColor = UIColor.americanSilver.cgColor
        grButton.layer.borderWidth = 1
        
        cupButton.layer.borderColor = UIColor.americanSilver.cgColor
        cupButton.layer.borderWidth = 1
        
        self.foodNameLabel.text = viewModel.foodName
        
    }
    
    func setFoodImage(imageURL: String){
        guard let url = URL(string: imageURL) else { return }
        if let cachedImage = imageCache.image(withIdentifier: imageURL) {
            foodImageView.image = cachedImage
        } else {
            AF.request(url).responseImage { response in
                switch response.result {
                case .success(let image):
                    self.imageCache.add(image, withIdentifier: imageURL)
                    
                    self.foodImageView.image = image
                    
                case .failure(let error):
                    print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                }
            }
        }
    }
    
    
    private func tapGestures(){
        let closeTapGesture = UITapGestureRecognizer(target: self, action: #selector(closeViewTapped))
        closeImageView.addGestureRecognizer(closeTapGesture)
        closeImageView.isUserInteractionEnabled = true
    }
    
    @objc private func closeViewTapped(){
        self.dismiss(animated: true)
    }
    
//    private func setUpDropDown(){
//        dropDown.dataSource = ["Seçenek 1", "Seçenek 2", "Seçenek 3"]
//
//            // Dropdown'un açılıp kapanma animasyonunu ayarlayın
//            dropDown.animationduration = 0.25
//
//            // Dropdown elemanı seçildiğinde yapılacak işlemleri belirtin
//            dropDown.selectionAction = { [unowned self] (index: Int, item: String) in
//                print("Seçilen indeks: \(index), Seçenek: \(item)")
//            }
//
//            // Dropdown'u ekranınıza ekleyin
//            view.addSubview(dropDown)
//
//            // Dropdown'u istediğiniz bir konumda görüntülemek için konumunu ayarlayın
//            dropDown.anchorView = someButton
//    }
}

//extension AmountAddedFoodVC:AmountAddedFoodInterface{
//    func setUpFoodLabel(foodName: String) {
//        self.foodNameLabel.text = foodName
//    }
//
//
//}
