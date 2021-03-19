//
//  XYTextCustomColorSelectView.swift
//  XYVivaEditor
//
//  Created by yitezh on 2021/2/1.
//

import UIKit
import SnapKit

@objcMembers
@objc public class XYTextCustomColorSelectView: UIView {
    
    public var finishSelectBlock:((_ color:UIColor) ->Void)?
    
    public var changeColorBlock:((_ color:UIColor) ->Void)?
    
    public var cancelBlock:(() ->Void)?
    
    private var selectColor:UIColor = UIColor.white
    
    private var HUEColor:UIColor = UIColor.red
    
    private var HUEPercent:CGFloat = 0
    private var xRate:CGFloat = 0
    private var yRate:CGFloat = 0
    
    lazy var colorMediator:XYHSVColorMediator = {
        var colorMediator = XYHSVColorMediator ()
        return colorMediator
    }()
    
    @objc public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = self.bounds
        let maskPath = UIBezierPath.init(roundedRect: bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 12, height: 12))
        shapeLayer.path = maskPath.cgPath
        self.layer.mask = shapeLayer
        self.initSubView();
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initSubView (){
        var safeBottom:CGFloat = 0;
        if #available(iOS 11.0, *) {
            if let keyWindow =  UIApplication.shared.keyWindow {
                safeBottom = keyWindow.safeAreaInsets.bottom;
            }
        } else {
            safeBottom =  0;
        }
        
        self.addSubview(self.titeLabel)
        self.titeLabel.snp.makeConstraints { (maker) in
            maker.centerX.equalTo(self)
            maker.top.equalTo(self).offset(25)
            
        }
    
        
        self.addSubview(self.doneButton)
        self.doneButton.snp.makeConstraints { (maker) in
            maker.centerY.equalTo(self.titeLabel)
            maker.trailing.equalTo(self).offset(-16)
        }
        
        self.addSubview(self.colorDetailView)
        self.colorDetailView.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.top.equalTo(self).offset(56+12)
            make.bottom.equalTo(self).offset(-(64+safeBottom))
        }
        self.colorDetailView.backgroundColor = .red
        
        
        self.addSubview(self.colorSlider)
        self.colorSlider.snp.makeConstraints { (make) in
            make.leading.equalTo(self).offset(16)
            make.trailing.equalTo(self).offset(-16)
            make.top.equalTo(self.colorDetailView.snp.bottom).offset(20)
            make.height.equalTo(20)
        }
        
        self.colorSlider.percentChangedBlock = {  [weak self] (percent)in
            self?.updateChangeHUEColor(HUE: percent)
            self?.caculateSelectColor()
        }
        
        self.colorSlider.percentFinishBlock = {  [weak self] (percent)in
            self?.callBackChange()
        }
        
        self.colorDetailView.changePositionBlock = {  [weak self] (xRate,yRate)in
            self?.xRate = xRate
            self?.yRate = yRate
            self?.caculateSelectColor()
            self?.callBackChange()
        }
    }
    
   public func updateSelectColor(color:UIColor?)  {
        if let selectColor = color {
            self.selectColor = selectColor
            self.titeLabel.textColor = selectColor
            let HSV:(H:CGFloat,S:CGFloat,V:CGFloat) = self.colorMediator.getHSVData(color: selectColor)
            var sliderPercent = HSV.H
            if(sliderPercent == 1) {
                sliderPercent = 0
            }
            self.colorSlider.updateSelectPosition(percent: sliderPercent)
            self.updateChangeHUEColor(HUE: sliderPercent)
            
            let xRate = HSV.S
            let yRate = 1 - HSV.V
            self.colorDetailView.updateSelectPosition(xRate:xRate, yRate:yRate)
            
        }
    }
    
    func updateChangeHUEColor(HUE:CGFloat) {
        self.HUEPercent = HUE
        self.caculateMainColor()
        self.colorDetailView.fillColor = self.HUEColor
        self.colorSlider.updateMainColor(color: self.HUEColor)
    }
    
    
    func caculateMainColor()  {
        self.HUEColor = self.colorMediator.getHueColor(percent: self.HUEPercent)
    }
    
    func caculateSelectColor () {
        self.selectColor =  self.colorMediator.getHSVColor(xrate: self.xRate, yrate: yRate, mainColor: self.HUEColor)
        self.titeLabel.textColor = selectColor
    }
    
    func callBackChange()  {
        self.changeColorBlock?(self.selectColor)
    }
    
    
    func dealDetailChange(color:UIColor)  {
        self.changeColorBlock?(color)
    }
    
    @objc private func cancelClicked() {
        self.removeFromSuperview()
        self.cancelBlock?()
    }
    
    @objc private func doneClicked() {
        self.removeFromSuperview()
        self.finishSelectBlock?(self.selectColor)
    }
    
    //MARK: - lazy Load
    private lazy var titeLabel:UILabel = {
        var label  = UILabel()
        label.textColor = UIColor.black
        label.text  = "选色器"
        return label
    }()
    
    
    private lazy var doneButton:UIButton = {
        var doneButton  = UIButton()
        doneButton.setTitle("done", for: .normal)
        doneButton.setTitleColor(.black, for: .normal)
        doneButton.addTarget(self, action: #selector(doneClicked), for:.touchUpInside)
        return doneButton
    }()
    
    private lazy var colorDetailView: XYTextCustomColorDetailView = {
        var colorDetailView  = XYTextCustomColorDetailView()
        colorDetailView.layer.cornerRadius = 4
        return colorDetailView
    }()
    
    private lazy var colorSlider: XYTextCustomColorSlider = {
        var colorSlider  = XYTextCustomColorSlider(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.self.width - 16*2, height: 20))
        return colorSlider
    }()
    
}

