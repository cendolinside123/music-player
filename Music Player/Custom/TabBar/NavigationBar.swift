//
//  NavigationBar.swift
//  Music Player
//
//  Created by Mac on 10/06/21.
//

import UIKit

class NavigationBar: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    private let background = UIView()
    private let buttonAbout = UIButton()
    
    
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
    }
    
    private func addConstraints() {
        let views:[String:Any] = ["background":background,"buttonAbout":buttonAbout]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        
        let hBackground = "H:|-0.8-[background]-0.8-|"
        let vBackground = "V:|-0-[background]-0.8-|"
        
        background.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hBackground, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vBackground, options: .alignAllLeading, metrics: metrix, views: views)
        
        
        let hButtonAbout = "H:[buttonAbout]-10-|"
        let vButtonAbout = "V:|-1-[buttonAbout]-1-|"
        
        buttonAbout.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hButtonAbout, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vButtonAbout, options: .alignAllTrailing, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: buttonAbout, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 2/9, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addBackground() {
        background.backgroundColor = .white
        self.addSubview(background)
    }
    
    private func addAboutButon() {
        buttonAbout.setTitle("About", for: .normal)
        buttonAbout.setTitleColor(.black, for: .normal)
        background.addSubview(buttonAbout)
    }
    

}
