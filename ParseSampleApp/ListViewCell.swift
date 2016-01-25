//
// Created by Libra Studio, Inc. on 2016/01/25.
// Copyright (c) 2016 Libra Studio, Inc. All rights reserved.
//

import UIKit
import Parse

class ListViewCell : UITableViewCell {
    
    var mIconImage: UIImageView!
    var mNameLabel: UILabel!
    var mAgeLabel: UILabel!
    var mBloodTypeLabel: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setTableViewCellContents()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Cellの中身を生成.
    private func setTableViewCellContents(){
        
        // 画像.
        mIconImage = UIImageView(frame: CGRectMake(10, 20, 70, 70))
        mIconImage.backgroundColor = UIColor.blueColor()
        
        self.addSubview(mIconImage)
        
        // 名前.
        mNameLabel = UILabel(frame: CGRectMake(mIconImage.frame.size.width + 20, 20, 200, 20))
        mNameLabel.font =  UIFont(name: "HiraKakuProN-W6", size: 14)
        mNameLabel.textColor = UIColor.blackColor()
        mNameLabel.text = ""
        self.addSubview(mNameLabel)
        
        // 年齢.
        mAgeLabel = UILabel(frame: CGRectMake(mIconImage.frame.size.width + 20, mNameLabel.frame.size.height + 20, 50, 20))
        mAgeLabel.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        mAgeLabel.textColor = UIColor.blackColor()
        mAgeLabel.text = ""
        
        self.addSubview(mAgeLabel)
        
        //血液型.
        mBloodTypeLabel = UILabel(frame: CGRectMake(mIconImage.frame.size.width + 20, mNameLabel.frame.size.height + mAgeLabel.frame.size.height + 20 , 50, 20))
        mBloodTypeLabel.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        mBloodTypeLabel.textColor = UIColor.blackColor()
        mBloodTypeLabel.text = ""
        
        self.addSubview(mBloodTypeLabel)
    }
}

