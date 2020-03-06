//
//  ListTableViewCell.swift
//  Sph
//
//  Created by 青天揽月1 on 2020/3/6.
//  Copyright © 2020 wenjuu. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {
    
    lazy var labelTop = { () -> UILabel in
        let label = UILabel.init()
        label.textColor = UIColor.black
        label.frame = CGRect(x: 20, y: 10, width: 100, height: 20)
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var labDesc = { () -> UILabel in
        let lab = UILabel.init()
        lab.textColor = UIColor.gray
        lab.frame = CGRect(x: 20, y: 30, width: 300, height: 20)
        lab.font = UIFont.systemFont(ofSize: 13)
        return lab
    }()
    
    lazy var btnImg = { () -> UIButton in
        let btn = UIButton.init()
        btn.setImage(UIImage(named: "icon-img"), for: .normal)
        let leftSpace = UIScreen.main.bounds.size.width-60
        btn.frame = CGRect(x:leftSpace , y: 5, width: 50, height: 50)
        btn.isHidden = true
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        return btn
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.addUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addUI() {
        self.addSubview(self.labelTop)
        self.addSubview(self.labDesc)
        self.addSubview(self.btnImg)
    }
    
    
    func updata(info:[String : Any], lastInfo:[String : Any]) {
        if info.count > 0 {
            self.labelTop.text = info["quarter"] as? String
            self.labDesc.text = info["volume_of_mobile_data"] as? String
            if lastInfo.count > 0 {
                let lastStr : String = (lastInfo["volume_of_mobile_data"] as? String)!
                let lastValue = Float(lastStr)!
                let str : String = (info["volume_of_mobile_data"] as? String)!
                let value = Float(str)!
                if (lastValue > value) {
                    self.btnImg.isHidden = false;
                }else{
                    self.btnImg.isHidden = true;
                }
            }
        }
    }
    @objc func btnAction() {
        let hub = MBProgressHUD.showAdded(to:UIApplication.shared.keyWindow!, animated: true)
        hub.mode = MBProgressHUDMode.text
        hub.label.text = "这个季度数据下降"
        hub.hide(animated: true, afterDelay: 1.5)
    }
}
