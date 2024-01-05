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
    var delegate: WaterDelegate?
    var documentIdArray: [String]?
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
        guard let indexPath = indexPath else {return}
        guard let selectedDataId = documentIdArray?[indexPath] else {
            print("Error: Selected documentId is nil.")
            return
        }
        self.deleteDocumentFromFirebase(documentId: selectedDataId)
        viewModel.addedWaterArray.remove(at: indexPath)
        delegate?.setUpProgressView()
        viewModel.getTotalMlFromFirebase { totalMl in
            self.viewModel.totalMl = totalMl
        }
    }
    
    func deleteDocumentFromFirebase(documentId: String){
        guard let indexPath = indexPath else {return}
        let deletedMl = self.viewModel.addedWaterArray[indexPath].millilitre
        
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()
        let documentRef =   db.collection("water").document(uid).collection("waterEntries").document(documentId)
        
        documentRef.delete { error in
            if let error = error {
                print("Error removing document: \(error)")
            } else {
                self.updateTotalMlAfterDelete(ml: deletedMl)
                self.delegate?.updateUI()
                self.delegate?.setUpProgressView()
            }
        }
    }
    
    func setTotalMlForDelete(ml: Int) -> Int {
        let updatedTotalMl = viewModel.totalMl - ml
        viewModel.totalMl = updatedTotalMl
        return updatedTotalMl
    }
    
    func updateTotalMlAfterDelete(ml: Int) {
        guard let user = Auth.auth().currentUser else { return }
        let uid = user.uid
        let db = Firestore.firestore()
        
        
        db.collection("water").document(uid).collection("waterEntries").getDocuments { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching documents: \(error)")
                return
            }
            
            for document in documents {
                do {
                    let documentID = document.documentID
                    let totalMl = document.data()["totalMl"] as? Int ?? 0
                    
                    let documentRef = db.collection("water").document(uid).collection("waterEntries").document(documentID)
                    documentRef.updateData([
                        "totalMl": self.setTotalMlForDelete(ml:ml)
                    ]) { error in
                        if let error = error {
                            print("Error updating document: \(error)")
                        } else {
                            print("Document successfully updated!")
                            self.delegate?.updateUI()
                        }
                    }
                } catch {
                    print("Error parsing document: \(error)")
                }
            }
        }
    }
}


