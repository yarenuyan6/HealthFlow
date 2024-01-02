//
//  WaterTableViewCell.swift
//  HealthFlow
//
//  Created by Yaren Uyan on 21.12.2023.
//

import UIKit

class WaterTableViewCell: UITableViewCell {

    var viewModel: WaterVM!{
        didSet{
            setUpCell()
        }
    }
    var indexPath: Int?
    @IBOutlet weak var millilitreLabel: UILabel!
    @IBOutlet weak var hourLabel: UILabel!
    static let identifier = "WaterTableViewCell"
    static let nibName = "WaterTableViewCell"
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpCell()
    }
    
    func setUpCell(){
        guard let indexPath = indexPath else {return}
        millilitreLabel.text = String(viewModel.addedWaterArray[indexPath].millilitre)
        
        guard let hour = viewModel.addedWaterArray[indexPath].date else {return}
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "Hh:mm"
        var hourString = dateFormatter.string(from: hour)
        
        hourLabel.text = hourString

    }
}
