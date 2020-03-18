//
//  ViewController.swift
//  Sph
//
//  Created by 青天揽月1 on 2020/3/5.
//  Copyright © 2020 wenjuu. All rights reserved.
//

import UIKit
import Alamofire
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    var tableview : UITableView?
    let cellid : String = "cellid"
    lazy var dataSource : NSMutableArray = NSMutableArray.init()
    lazy var yearArray : NSMutableArray = NSMutableArray.init()
    lazy var allData: NSMutableArray = NSMutableArray.init()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell : ListTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath) as! ListTableViewCell
        if cell.isEqual(nil) {
            cell = ListTableViewCell(style: .default, reuseIdentifier: cellid)
        }
        let lastInfo : [String : Any]
        if (indexPath.row == 0) {
            lastInfo = ["volume_of_mobile_data":"0"]
        }else{
            lastInfo = self.dataSource[indexPath.row-1] as! [String : Any]
        }
        if (indexPath.row < self.dataSource.count){
            cell.updata(info: self.dataSource[indexPath.row] as! [String : Any], lastInfo: lastInfo)
        }
        return cell
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        self.getTheWebData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.title = "SPH"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "年份", style: .plain, target: self, action: #selector(btnAction))
               
        tableview = UITableView(frame: self.view.frame, style: .plain)
        tableview?.dataSource = self
        tableview?.delegate = self
        tableview?.backgroundColor = UIColor.white
        tableview?.tableFooterView = UIView()
        tableview?.rowHeight = 60
        tableview?.register(ListTableViewCell.self, forCellReuseIdentifier: cellid)
        self.view.addSubview(tableview!)
    }
    
    @objc func btnAction() {
        let yesa = showSelectYear.init(frame: UIScreen.main.bounds)
        yesa.show(data: self.yearArray as! Array) { (year) in
            self.makeSelectData(yearObjec: year!)
        }
    }
    func getTheWebData() {
        let hub = MBProgressHUD.showAdded(to: self.view, animated: true)
       
        let config = URLSessionConfiguration.default
        config.protocolClasses = [sphProtocol.self]
        
        let alamfir = Session.init(configuration: config)
        
        alamfir.request("https://data.gov.sg/api/action/datastore_search?resource_id=a807b7ab-6cad-4aa6-87d0-e283a7353a0f").responseJSON { (dataResponse) in
            DispatchQueue.main.async {
                hub.hide(animated: true)
                switch dataResponse.result{
                case .success(let value):
                    if let dict = value as? [String:Any] , let success = dict["success"] as? Int{
                        if "\(success)" == "1"{
                            let result :[String :Any] = dict["result"] as! [String : Any]
                            let tem : Array = result["records"] as! Array<Any>
                            DbManager.sharedAdapter().saveData(tem)
                            self.makeData(data: tem)
                        }else{
                            print("接口错误描述")
                        }
                    }else{
                        print("数据格式问题")
                    }
                case .failure(let error):
                    print(error)
                    let tem : Array = DbManager.sharedAdapter().getLocalData()
                    self.makeData(data: tem)
                }
            }
        }
    }
    
    func makeData(data : Array<Any>) {
        if self.dataSource.count > 0 {
            self.dataSource.removeAllObjects()
        }
        var lastYear = ""
        for (index,item) in data.enumerated() {
            self.allData.add(item)
            let dict = item as! [String :Any]
            let quarte :String = dict["quarter"] as! String
            if quarte.count > 4 {
                let year: String = String(quarte.prefix(4))
                if(!self.yearArray.contains(year)){
                    self.yearArray.add(year)
                }
                
                if (index == 0) {
                    self.dataSource.add(item)
                    lastYear = year
                }else{
                    if (lastYear == year) {
                        self.dataSource.add(item)
                    }
                }
            }
        }
        if (self.dataSource.count > 0) {
            self.tableview?.reloadData()
        }
    }
    func makeSelectData(yearObjec :String) {
        if self.dataSource.count > 0 {
            self.dataSource.removeAllObjects()
        }
        for item in self.allData {
            let dict = item as! [String :Any]
            let quarte :String = dict["quarter"] as! String
            if quarte.count > 4 {
                let year: String = String(quarte.prefix(4))
                if yearObjec ==  year{
                    self.dataSource.add(item)
                }
            } 
        }
        if (self.dataSource.count > 0) {
            self.tableview?.reloadData()
        }
    }

}

