//
//  MyCollectionViewCell.swift
//  DynamicCollectionViewCellWithAutoLayout-Demo
//
//  Created by Honghao Zhang on 2014-09-26.
//  Copyright (c) 2014 HonghaoZ. All rights reserved.
//

import UIKit

// Check System Version
let isIOS7: Bool = !isIOS8
let isIOS8: Bool = floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1

class MyCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    let kLabelVerticalInsets: CGFloat = 8.0
    let kLabelHorizontalInsets: CGFloat = 8.0
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if isIOS7 {
            // Need set autoresizingMask to let contentView always occupy this view's bounds, key for iOS7
            self.contentView.autoresizingMask = [.FlexibleHeight, .FlexibleWidth]
        }
        self.layer.masksToBounds = true
    }
    
    // In layoutSubViews, need set preferredMaxLayoutWidth for multiple lines label
    override func layoutSubviews() {
        super.layoutSubviews()
        // Set what preferredMaxLayoutWidth you want
        contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets
    }
    
    func configCell(title: String, content: String, titleFont: String, contentFont: String) {
        titleLabel.text = title
        contentLabel.text = content
        
        titleLabel.font = UIFont(name: titleFont, size: 18)
        contentLabel.font = UIFont(name: contentFont, size: 16)
        self.setNeedsLayout()
        self.layoutIfNeeded()
    }

}
