//
// Created by Libra Studio, Inc. on 2016/01/25.
// Copyright (c) 2016 Libra Studio, Inc. All rights reserved.
//

import UIKit

protocol CustomPickerDelegate {
    func setChengedParameter(index: Int)

    func onCancelButtonClick()

    func onCompleteButtonClick()
}

class CustomPickerView: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    var pickerList: [String]
    var delegate: CustomPickerDelegate?

    init(frame: CGRect, dataList: Array<String>, index: Int) {
        self.pickerList = dataList

        super.init(frame: frame)

        let pickerView = UIPickerView()
        pickerView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height)
        pickerView.backgroundColor = UIColor.whiteColor()

        self.addSubview(pickerView)

        pickerView.delegate = self
        pickerView.dataSource = self

        pickerView.selectRow(index, inComponent: 0, animated: true)

        // 各ボタンを包む枠.
        let headerBar = UIView(frame: CGRectMake(0, 0, frame.size.width, 30))
        headerBar.backgroundColor = UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1.0)
        self.addSubview(headerBar)

        // Pickerを閉じるボタン(Cancel).
        let cancelButton = UIButton(frame: CGRectMake(0, 0, 100, 30))
        cancelButton.setTitle("キャンセル", forState: UIControlState.Normal)
        cancelButton.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        cancelButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        cancelButton.addTarget(self, action: "onCancelButtonClick:", forControlEvents: .TouchUpInside)
        self.addSubview(cancelButton)

        // Pickerを閉じるボタン(OK).
        let completeButton = UIButton(frame: CGRectMake(0, 0, 100, 30))
        completeButton.layer.position.x = frame.width - 20
        completeButton.setTitle("完了", forState: UIControlState.Normal)
        completeButton.titleLabel?.font = UIFont(name: "HiraKakuProN-W6", size: 14)
        completeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        completeButton.addTarget(self, action: "onCompleteButtonClick:", forControlEvents: .TouchUpInside)
        self.addSubview(completeButton)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }

    // データ数.
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }

    // pickerに表示する値を返すデリゲートメソッド.
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerList[row] as String
    }

    // Pickerの各列が選択された時.
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("selected: \(row), \(pickerList[row])")

        delegate?.setChengedParameter(row)
    }

    // delegate. カスタムPickerViewのキャンセルが押されるとこちらが呼ばれる.
    func onCancelButtonClick(sender: UIButton){
        self.removeFromSuperview()
        delegate?.onCancelButtonClick()
    }

    // delegate. カスタムPickerViewの完了が押されるとこちらが呼ばれる.
    func onCompleteButtonClick(sender: UIButton){
        self.removeFromSuperview()
        delegate?.onCompleteButtonClick()
    }
}

