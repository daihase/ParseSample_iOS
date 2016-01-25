//
//  TopViewController.swift
//  ParseSampleApp
//
//  Created by Libra Studio, Inc. on 2016/01/25.
//  Copyright © 2016年 Libra Studio, Inc. All rights reserved.
//

import UIKit
import SVProgressHUD
import Parse

class TopViewController: UIViewController, UITextFieldDelegate, CustomPickerDelegate {
    
    private var mTotalHeight: CGFloat = 0.0
    private var mNameTextField: UITextField!
    private var mAgeTextField: UITextField!
    private var mBloodType: UIButton!
    private var mPickerView: CustomPickerView!
    private var mSubmitButton: UIButton!
    private var mSelectedRowNumber = 0
    private let mList = ["A", "B", "O", "AB"]
    private var isPickerShowing: Bool!
    
    init() {
        super.init(nibName: nil, bundle: nil)

        self.view.backgroundColor = UIColor.whiteColor()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.Search, tag: 1)
    }

    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // カスタムPickerView出現制御のためのフラグ.
        isPickerShowing = false

        // 画面外タップでキーボードをさげる.
        let tap = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)

        // 名前.
        let name = UILabel(frame: CGRectMake(0, 0, 100, 60))
        name.text = "名前 :"
        name.layer.position = CGPoint(x: name.frame.size.width / 2, y: 100)
        mNameTextField = UITextField(frame: CGRectMake(0, 0, 220, 30))
        mNameTextField.tag = 1
        mNameTextField.delegate = self
        mNameTextField.borderStyle = UITextBorderStyle.RoundedRect
        mNameTextField.clearButtonMode = UITextFieldViewMode.Always
        mNameTextField.layer.position = CGPoint(x: mNameTextField.frame.size.width / 2 + name.frame.size.width / 2, y: 100)

        // 年齢.
        let age = UILabel(frame: CGRectMake(0, 0, 100, 60))
        age.text = "年齢 :"
        age.layer.position = CGPoint(x: age.frame.size.width / 2, y: 150)
        mAgeTextField = UITextField(frame: CGRectMake(0, 0, 100, 30))
        mAgeTextField.tag = 2
        mAgeTextField.delegate = self
        mAgeTextField.keyboardType = .NumberPad
        mAgeTextField.borderStyle = UITextBorderStyle.RoundedRect
        mAgeTextField.clearButtonMode = UITextFieldViewMode.WhileEditing
        mAgeTextField.layer.position = CGPoint(x: age.frame.size.width / 2 + mAgeTextField.frame.size.width / 2, y: 150)

        // 血液型.
        let blood = UILabel(frame: CGRectMake(0, 0, 100, 60))
        blood.text = "血液型 :"
        blood.layer.position = CGPoint(x: blood.frame.size.width / 2, y: 200)
        mBloodType = UIButton(frame: CGRectMake(0, 0, 30, 60))
        mBloodType.setTitle("A", forState: UIControlState.Normal)
        mBloodType.setTitleColor(UIColor.blackColor(), forState: .Normal)
        mBloodType.layer.position = CGPoint(x: blood.frame.origin.x + blood.frame.size.width / 2 + mBloodType.frame.size.width, y: 200)
        mBloodType.addTarget(self, action: "selectBloodType:", forControlEvents: .TouchUpInside)

        // Submitボタン.
        mSubmitButton = UIButton(frame: CGRectMake(0, 0, 200, 60))
        mSubmitButton.setTitle("Parseへ転送", forState: UIControlState.Normal)
        mSubmitButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        mSubmitButton.setTitle("Parseへ転送", forState: UIControlState.Highlighted)
        mSubmitButton.setTitleColor(UIColor.blackColor(), forState: .Highlighted)
        mSubmitButton.layer.borderColor = UIColor.redColor().CGColor
        mSubmitButton.layer.borderWidth = 2
        mSubmitButton.layer.masksToBounds = true
        mSubmitButton.layer.cornerRadius = 10.0
        mSubmitButton.layer.position = CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height - 200)
        mSubmitButton.addTarget(self, action: "executeAPI", forControlEvents: .TouchUpInside)

        // Viewに追加.
        self.view.addSubview(name)
        self.view.addSubview(mNameTextField)
        self.view.addSubview(age)
        self.view.addSubview(mAgeTextField)
        self.view.addSubview(blood)
        self.view.addSubview(mBloodType)
        self.view.addSubview(mSubmitButton)
    }

    // 血液型をPickerから選択する.
    func selectBloodType(sender: AnyObject) {

        if isPickerShowing == false {
            isPickerShowing = true
            mPickerView = CustomPickerView(frame: CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 200), dataList: mList, index: mSelectedRowNumber)
            mPickerView.delegate = self
            self.view.addSubview(mPickerView)

            //アニメーションしながら表示.
            UIView.animateWithDuration(NSTimeInterval(CGFloat(0.1)), animations: {
                () -> Void in
                self.mPickerView.center = CGPoint(x: self.view.frame.width / 2, y: self.view.frame.height - (self.mPickerView.frame.height - 80))
            }, completion: {
                (Bool) -> Void in
            })
        }
    }

    // 各フィールドに入力した値をParseへ転送.
    func executeAPI() {
        SVProgressHUD.showWithStatus("Loading...")
        // 名前.
        let name = (mNameTextField.text)!
        let age = (mAgeTextField.text)!
        let blood = mList[self.mSelectedRowNumber]
        // ParseのTestObject生成.
        let object = PFObject(className: "TestObject")

        // Parseオブジェクトに各入力内容をセット.
        object["name"] = name

        if age == "" {
            object["age"] = 0
        } else {
            object["age"] = Int(age)!
        }

        object["blood"] = blood

        // ParseにINSERT.
        object.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // 成功.
                SVProgressHUD.dismiss()
            } else {
                // 失敗.
                SVProgressHUD.showErrorWithStatus("Failed.")
            }
        }
    }

    // delegate. 選択した血液型をセット.
    func setChengedParameter(rowNum: Int) {
        self.mBloodType.setTitle(mList[rowNum], forState: .Normal)
        let index = mList.indexOf(mList[rowNum])
        self.mSelectedRowNumber = index!
    }

    // 血液型PickerViewでキャンセルを押下.
    func onCancelButtonClick() {
        isPickerShowing = false
    }

    // 血液型PickerViewで完了を押下.
    func onCompleteButtonClick() {
        isPickerShowing = false
    }

    // delegate. 各テキストフィールドの文字数制限.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {

        // 文字数最大を決める.
        var maxLength: Int = 0

        switch (textField.tag) {
        case 1: // 名前テキストフィールドの文字数.
            maxLength = 10
        case 2: // 年齢テキストフィールドの文字数.
            maxLength = 3
        default:
            break
        }

        // 名前テキストフィールドが0以上の時のみ.
        if textField.tag == 1 && (mNameTextField.text! as NSString).length > 0 {
            var tmpStr = mNameTextField.text! as NSString
            tmpStr = tmpStr.stringByReplacingCharactersInRange(range, withString: string)

            if tmpStr.length > maxLength {
                return false
            }
        }

        // 年齢テキストフィールドが0以上の時のみ.
        if textField.tag == 2 && (mAgeTextField.text! as NSString).length > 0 {
            var tmpStr = mAgeTextField.text! as NSString
            tmpStr = tmpStr.stringByReplacingCharactersInRange(range, withString: string)

            if tmpStr.length > maxLength {
                return false
            }
        }

        // テキストフィールドを更新する.
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // キーボードを閉じる
        view.resignFirstResponder()

        return true
    }

    // 画面外タップでキーボードをさげる.
    func DismissKeyboard() {
        view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

