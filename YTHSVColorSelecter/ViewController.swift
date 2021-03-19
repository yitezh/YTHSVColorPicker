//
//  ViewController.swift
//  YTHSVColorSelecter
//
//  Created by yitezh on 2021/3/19.
//

import UIKit
import SnapKit
class ViewController: UIViewController {
    private var selectColor = UIColor.white
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .black
        
        self.view.addSubview(self.showButton)
        showButton.snp.makeConstraints { (maker) in
            maker.center.equalTo(self.view)
        }
        
        
        
        
    }
    
    @objc func showColorView (){
        let height:CGFloat = 284 + 48 + 20;
        let selectView = YTCustomColorSelectView(frame: CGRect(x:0.0,y:100.0,width:self.view.bounds.size.width,height: height))
        self.view.addSubview(selectView)
        selectView.snp.makeConstraints { (maker) in
            maker.leading.trailing.equalTo(self.view)
            maker.height.equalTo(height)
            maker.centerX.equalTo(self.view)
        }
        
        selectView.updateSelectColor(color: selectColor)
        selectView.changeColorBlock =  {  [weak self](color)   in
            self?.selectColor = color
        }
    }

    private lazy var showButton:UIButton = {
        var doneButton  = UIButton()
        doneButton.setTitle("show", for: .normal)
        doneButton.addTarget(self, action: #selector(showColorView), for:.touchUpInside)
        return doneButton
    }()
    
    
}

