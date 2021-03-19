//
//  XYTextCustomColorDetailView.swift
//  XYVivaEditor
//
//  Created by yitezh on 2021/2/2.
//

import UIKit
import SnapKit

class XYTextCustomColorDetailView: UIView {
    public var changePositionBlock:((_ xRate:CGFloat,_ yRate:CGFloat) ->Void)?
    public var selectColor = UIColor.white
    private var currentPosition:CGPoint = CGPoint(x: 0, y: 0)
    
    @objc public var fillColor:UIColor? {
        didSet {
            self.colorBgView.backgroundColor = fillColor
        }
    }
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    
    func initSubView (){
        self.addSubview(self.colorBgView)
        self.addSubview(self.maskImageView)
        
        self.colorBgView.backgroundColor = .red
        self.colorBgView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.maskImageView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        self.addSubview(self.dotView)
        
        self.fillColor = UIColor.init(red: 1, green: 0, blue: 0, alpha: 1)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
        self.callBackRate()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
 
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
  
    }
    
    
    func updateSelectPosition(xRate:CGFloat,yRate:CGFloat)  {
        self.layoutIfNeeded()
        let center_x = self.colorBgView.frame.size.width * xRate
        let center_y = self.colorBgView.frame.size.height * yRate
        self.dotView.center = CGPoint(x: center_x, y: center_y)
    }
    
   private  func moveAction(point:CGPoint)  {
        let x = point.x
        let y = point.y
        var position_x = min(x, self.bounds.width)
        position_x = max(position_x, 0)
        var position_y = min(y, self.bounds.height)
        position_y = max(position_y, 0)
        let center = CGPoint(x: position_x, y: position_y)
        self.dotView.center = center
        self.currentPosition = center
    }
    
    func callBackRate()  {
        let xrate = currentPosition.x / self.frame.size.width;
        let yrate = 1 - currentPosition.y / self.frame.size.height;
        self.changePositionBlock?(xrate,yrate)
    }

    private lazy var colorBgView: UIView = {
        var colorBgView  = UIView()
        colorBgView.layer.cornerRadius = 4
        colorBgView.layer.masksToBounds = true
        return colorBgView
    }()
    
    private lazy var maskImageView: UIImageView = {
        var maskImageView  = UIImageView()
        maskImageView.image = UIImage.init(named: "edit_text_color_select_mask")
        maskImageView.layer.cornerRadius = 4
        maskImageView.layer.masksToBounds = true
        return maskImageView
    }()
    
    
    private lazy var dotView: UIView = {
        var view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        view.layer.borderWidth = 3
        view.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    
}

