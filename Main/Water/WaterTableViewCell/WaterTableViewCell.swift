//
//  WaterTableViewCell.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 21.12.2023.
//

import UIKit
import Firebase

class WaterTableViewCell: UITableViewCell {
    
    var viewModel: WaterVM!{
        didSet{
            setUpCell()
        }
    }
    var indexPath: Int?
    var deleteButtonAction: (() -> Void)?
    @IBOutlet weak var millilitreLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    static let identifier = "WaterTableViewCell"
    static let nibName = "WaterTableViewCell"
    @IBOutlet weak var contentStackView: UIStackView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestures()
        setUpCell()
    }
    
    func setUpCell(){
        guard let indexPath = indexPath else {return}
        millilitreLabel.text = "\(String(viewModel.addedWaterArray[indexPath].millilitre)) ml"
        
        guard let hour = viewModel.addedWaterArray[indexPath].date else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        var hourString = dateFormatter.string(from: hour)
        
        hourLabel.text = hourString
        
        contentStackView.layer.borderColor = UIColor.americanSilver.cgColor
        contentStackView.layer.borderWidth = 1
        
    }
    
    private func tapGestures(){
        let deleteTapGesture = UITapGestureRecognizer(target: self, action: #selector(deleteImageViewTapped))
        deleteImageView.addGestureRecognizer(deleteTapGesture)
        deleteImageView.isUserInteractionEnabled = true
    }
    
    @objc func deleteImageViewTapped(){
        deleteButtonAction?()
        
        guard let indexPath = indexPath else {return}
        let selectedData = viewModel.addedWaterArray[indexPath]

    }
    
    func deleteDocumentFromFirebase(documentId: String){
        let db = Firestore.firestore()
        
        db.collection("yourCollectionName").document(documentId).delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
}

