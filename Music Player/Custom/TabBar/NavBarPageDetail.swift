//
//  NavBarPageDetail.swift
//  Music Player
//
//  Created by Mac on 13/06/21.
//

import UIKit

class NavBarPageDetail: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    private let background = UIView()
    private let buttonClose = UIButton()
    private let labelTitle = UILabel()
    
    var doAction:(() -> ())? = nil
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        addLayout()
        addConstraints()
    }
    
    private func addLayout() {
        addBackground()
        addAboutButon()
        addTitle()
    }
    
    private func addConstraints() {
        let views:[String:Any] = ["background":background,"buttonAbout":buttonClose,"labelTitle":labelTitle]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        
        let hBackground = "H:|-0.8-[background]-0.8-|"
        let vBackground = "V:|-0-[background]-0.8-|"
        
        background.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hBackground, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vBackground, options: .alignAllLeading, metrics: metrix, views: views)
        
        
        let hButtonAbout_title = "H:|-10-[buttonAbout]-5-[labelTitle]-10-|"
        let vButtonAbout = "V:|-1-[buttonAbout]-1-|"
        let vTitle = "V:|-1-[buttonAbout]-1-|"
        
        buttonClose.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hButtonAbout_title, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vButtonAbout, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTitle, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: buttonClose, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 2/9, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addBackground() {
        background.backgroundColor = .white
        self.addSubview(background)
    }
    
    private func addAboutButon() {
        buttonClose.setTitle("Close", for: .normal)
        buttonClose.setTitleColor(.black, for: .normal)
        buttonClose.addTarget(self, action: #selector(displayAboutDev), for: .touchDown)
        background.addSubview(buttonClose)
    }
    
    private func addTitle() {
        labelTitle.text = ""
        background.addSubview(labelTitle)
    }
    
    @objc private func displayAboutDev() {
        doAction?()
    }
    
    func setTextButtonClose(text:String) {
        buttonClose.setTitle(text, for: .normal)
    }
    
    
    func addTite(text:String) {
        labelTitle.text = text
    }

}
