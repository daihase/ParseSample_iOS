//
//  ListViewController.swift
//  ParseSampleApp
//
//  Created by Libra Studio, Inc. on 2016/01/25.
//  Copyright © 2016年 Libra Studio, Inc. All rights reserved.
//

import UIKit
import Parse
import SVProgressHUD

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private var mTableView: UITableView!
    private var mQuery: [PFObject] = []
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = UIColor.whiteColor()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarSystemItem.History, tag: 2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidAppear(animated: Bool) {
        mQuery = []
        // API実行.
        requestGetApi()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 画面コンテンツ生成.
    func setTableViewCellContents(){
        // TableView作成.
        mTableView = UITableView(frame: CGRectMake(0, 0, self.view.frame.width, self.view.frame.height))
        mTableView.registerClass(ListViewCell.self, forCellReuseIdentifier: "listViewCell")
        mTableView.dataSource = self
        mTableView.delegate = self
        mTableView.rowHeight = 100
        
        self.view.addSubview(mTableView)
    }
    
    // Cellの数.
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int  {
        return self.mQuery.count
    }
    
    // Cellに値を設定.
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) ->  UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("listViewCell", forIndexPath: indexPath) as! ListViewCell
        
        // 名前セット.
        cell.mNameLabel.text = mQuery[indexPath.row]["name"] as? String
        // 年齢セット.
        let age = (mQuery[indexPath.row])["age"]
        cell.mAgeLabel.text = String(age)
        // 血液型セット.
        cell.mBloodTypeLabel.text = mQuery[indexPath.row]["blood"] as? String
        
        return cell
    }
    
    // Cellが選択された際に呼ばれる.
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath:NSIndexPath) {
        //var text: String = texts[indexPath.row]
        print("touched")
    }
    
    // 非同期でAPI実行.
    func requestGetApi(){
        SVProgressHUD.showWithStatus("Loading...")
        let query = PFQuery(className: "TestObject")
        query.findObjectsInBackgroundWithBlock {
            (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                // 成功.
                SVProgressHUD.dismiss()
                // Parseから取得した値がnilでないなら取得した数だけ繰り返す.
                if let objects = objects {
                    for object in objects {
                        self.mQuery.append(object)
                    }
                }
                // TableViewCellを生成.
                self.setTableViewCellContents()
                
            } else {
                // 失敗.
                SVProgressHUD.showErrorWithStatus("Failed.")}
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

