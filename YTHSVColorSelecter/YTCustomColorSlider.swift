//
//  XYTextCustomColorSlider.swift
//  XYVivaEditor
//
//  Created by yitezh on 2021/2/1.
//

import UIKit

class YTCustomColorSlider: UIView {
    let moveSpace:CGFloat = 8
    @objc public var percentChangedBlock:((_ percent:CGFloat)-> Void)?
    @objc public var percentFinishBlock:((_ percent:CGFloat)-> Void)?

    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.initSubView();
    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        var bounds = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        let widthDelta:CGFloat = 20.0;
        let heightDelta:CGFloat = 20.0;
        bounds = bounds.insetBy(dx: (-0.5)*widthDelta, dy: (-0.5)*heightDelta)
        return bounds.contains(point)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateMainColor(color:UIColor)  {
        self.dotView.backgroundColor = color
    }
    
    func initSubView (){
        self.addSubview(self.colorBgView)
        self.colorBgView.frame = CGRect(x: 8, y: 6, width: self.frame.size.width-16, height: self.frame.size.height-12);
        
        self.addSubview(self.dotView)
        self.dotView.frame = CGRect(x: moveSpace, y:0 , width: 16, height: 20)
        self.dotView.center = CGPoint(x: self.dotView.center.x, y: self.bounds.size.height/2)
        let colorList:[CGColor] = [UIColor.red.cgColor, UIColor.yellow.cgColor,UIColor.green.cgColor,UIColor.cyan.cgColor,UIColor.blue.cgColor,
                                 UIColor.magenta.cgColor,UIColor.red.cgColor]
        self.addBackgroundGradientColors(colorsArray: colorList)
    }
    
    func addBackgroundGradientColors(colorsArray:[CGColor])  {
        let gradientLayer = CAGradientLayer()
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.colors = colorsArray
        gradientLayer.frame = self.colorBgView.bounds
        self.colorBgView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
        self.callBackChanged()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let p = touches.first?.location(in: self) else { return  }
        self.moveAction(point: p)
        self.callBackChanged()
        self.callBackChangeEnd()
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.callBackChangeEnd()
    }
    
    func moveAction(point:CGPoint)  {
        let x = point.x
        var moveX = min(x, self.colorBgView.frame.size.width+moveSpace)
        moveX = max(moveSpace, moveX)
        self.dotView.center = CGPoint(x: moveX, y: self.dotView.center.y)
    }
    
    func updateSelectPosition(percent:CGFloat)  {
        self.layoutIfNeeded()
        var centerPosition = self.colorBgView.frame.size.width * percent + moveSpace
        centerPosition = min(centerPosition, self.colorBgView.frame.size.width+moveSpace)
        centerPosition = max(moveSpace, centerPosition)
        self.dotView.center = CGPoint(x: centerPosition, y: self.dotView.center.y)
    }
    
    func callBackChanged()  {
        let percent = (self.dotView.center.x / self.colorBgView.frame.size.width)
        self.percentChangedBlock?(percent)
    }
    
    func callBackChangeEnd()  {
        let percent = (self.dotView.center.x / self.colorBgView.frame.size.width)
        self.percentFinishBlock?(percent)
    }
    

    private lazy var colorBgView: UIView = {
        var colorBgView  = UIView()
        colorBgView.layer.cornerRadius = 4
        colorBgView.layer.masksToBounds = true
        return colorBgView
    }()
    
    private lazy var dotView: UIView = {
        var dotView  = UIView()
        dotView.backgroundColor = .red
        dotView.layer.cornerRadius = 8
        dotView.layer.borderWidth = 3
        dotView.layer.borderColor = UIColor.white.cgColor
        return dotView
    }()
     
    
}
