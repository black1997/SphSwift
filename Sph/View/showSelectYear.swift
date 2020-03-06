//
//  showSelectYear.swift
//  Sph
//
//  Created by 青天揽月1 on 2020/3/6.
//  Copyright © 2020 wenjuu. All rights reserved.
//

import UIKit


typealias selectBlock = (String?) -> Void

class showSelectYear: UIView,UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid, for: indexPath)
        if cell.isEqual(nil) {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: cellid)
        }
        if indexPath.row < self.dataSource.count {
            cell.textLabel?.text = self.dataSource[indexPath.row] as? String
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.closeView()
        if indexPath.row < self.dataSource.count {
            let Str :String = self.dataSource[indexPath.row] as! String
            if block != nil{
                block!(Str)
            }
        }
    }
    
    
    
    private var _aplview:UIView!
    var _customview:UIView!
    var _tableview:UITableView!
    lazy var dataSource : NSMutableArray = NSMutableArray.init()
    var block : selectBlock?
    let cellid = "cllids"

    override init(frame: CGRect = UIScreen.main.bounds) {
        super.init(frame: frame)
        
        _aplview = UIView.init(frame: frame)
        _aplview.backgroundColor = UIColor.black
        _aplview.alpha = 0
        _aplview.isUserInteractionEnabled = true
        _aplview.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction)))
        
        _customview = UIView.init(frame: CGRect(x: 0, y: 0, width: SCR_W-80, height: SCR_H-200))
        _customview.center = self.center
        _customview.backgroundColor = UIColor.white
        
        _tableview = UITableView.init(frame:CGRect(x: 0, y: 0, width: SCR_W-80, height: SCR_H-200), style: .plain)
        _tableview.dataSource = self
        _tableview.delegate = self
        _tableview.tableFooterView = UIView()
        _tableview.backgroundColor = UIColor.white
        _tableview.register(UITableViewCell.self, forCellReuseIdentifier: cellid)
        _customview.addSubview(_tableview)
        
        self.addSubview(_aplview)
        self.addSubview(_customview)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func show(
        data : Array<Any>,
        selectBlock:@escaping selectBlock){
        for item in data {
            self.dataSource.add(item)
        }
        block = selectBlock
        _tableview.reloadData()
        UIApplication.shared.keyWindow?.addSubview(self)
        _customview.transform = CGAffineTransform(scaleX: 1.21, y: 1.21)
        _customview.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
            self._customview.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            self._customview.alpha = 1
            self._aplview.alpha = 0.57
        }, completion: nil)
    }
    
    @objc func tapAction() {
        self.closeView()
    }
    
    func closeView() {
        UIView.animate(withDuration: 0.3, animations: {
            self._customview.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            self._customview.alpha = 0
            self._aplview.alpha = 0
        }) { (res) in
            self._customview.removeFromSuperview()
            self._aplview.removeFromSuperview()
            self.removeFromSuperview()
        }
    }
}
