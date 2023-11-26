//
//  CustomCell.swift
//  TodoApp
//
//  Created by 정종원 on 11/22/23.
//

import UIKit

protocol CheckTableViewCellDelegate: AnyObject {
  func checkTableViewCell(_ cell: CustomCell, didChagneCheckedState checked: Bool)
}

class CustomCell: UITableViewCell {
    
    
    //    @IBOutlet weak var checkButton: Checkbox!
    @IBOutlet weak var checkButton: CustomCheckbox!
    @IBOutlet weak var todoLabel: UILabel!
    
    weak var delegate: CheckTableViewCellDelegate?
    
    var checkboxTapped: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func set(title: String, checked: Bool) {
        todoLabel.text = title
        set(checked: checked)
    }
    
    func set(checked: Bool) {
        checkButton.checked = checked
        updateChecked()
    }
    
    private func updateChecked() {
        let attributedString = NSMutableAttributedString(string: todoLabel.text!)
        
        if checkButton.checked {
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        } else {
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        
        todoLabel.attributedText = attributedString
    }
    
    
    @IBAction func checked(_ sender: Any) {
        updateChecked()
        delegate?.checkTableViewCell(self, didChagneCheckedState: checkButton.checked)
    }
    
    
}
