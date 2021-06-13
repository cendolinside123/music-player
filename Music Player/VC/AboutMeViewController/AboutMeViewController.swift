//
//  AboutMeViewController.swift
//  Music Player
//
//  Created by Mac on 10/06/21.
//

import UIKit

class AboutMeViewController: UIViewController {
    
    private let navBar = NavBarPageDetail()
    private let imagePP = UIImageView()
    private let nameLabel = UILabel()
    private let emailLabel = UILabel()
    private let gitHubLabel = UILabel()
    private let labelStackView:UIStackView = {
        let stack = UIStackView()
        stack.alignment = .fill
        stack.axis = .vertical
        stack.distribution = .fill
        return stack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        addLayout()
        addConstraints()
        setImageToCircle()
        navBar.addTite(text: "About Me")
        navBar.doAction = {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func addLayout() {
        addTabBar()
        addImagePP()
        addNameLabel()
        addEmailLabel()
        addGitHubLabel()
        addStackViewLabel()
    }
    
    private func addConstraints() {
        let views = ["navBar":navBar,"imagePP":imagePP,"nameLabel":nameLabel,"emailLabel":emailLabel,"gitHubLabel":gitHubLabel,"labelStackView":labelStackView]
        
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        
        //MARK: navBar , imagePP and labelStackView constraints
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        imagePP.translatesAutoresizingMaskIntoConstraints = false
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let vTabRar_Content = "V:|-[navBar]-10-[imagePP]-20-[labelStackView]"
        let hTabBar = "H:|-0-[navBar]-0-|"
        let hLabelStackView = "H:|-5-[labelStackView]-5-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTabRar_Content, options: .alignAllCenterX, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTabBar, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hLabelStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: imagePP, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: navBar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.8/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: labelStackView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: imagePP, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 2/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: imagePP, attribute: .height, relatedBy: .equal, toItem: imagePP, attribute: .width, multiplier: 1, constant: 0)]
        
        
        //MARK: nameLabel , emailLabel , and gitHubLabel
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        gitHubLabel.translatesAutoresizingMaskIntoConstraints = false
        
        //constraints += [NSLayoutConstraint(item: nameLabel, attribute: .height, relatedBy: .equal, toItem: emailLabel, attribute: .height, multiplier: 3/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: emailLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)]
        
        constraints += [NSLayoutConstraint(item: emailLabel, attribute: .height, relatedBy: .equal, toItem: gitHubLabel, attribute: .height, multiplier: 1, constant: 0)]
        
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addTabBar() {
        view.addSubview(navBar)
    }
    
    private func addImagePP() {
        imagePP.image = #imageLiteral(resourceName: "pp")
        view.addSubview(imagePP)
    }
    
    private func addNameLabel() {
        nameLabel.text = "Jan Sebastian Tatang"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
    }
    
    private func addEmailLabel() {
        emailLabel.text = "jnsbstn391@gmail.com"
        emailLabel.numberOfLines = 0
        emailLabel.textAlignment = .center
        emailLabel.textColor = .black
        view.addSubview(emailLabel)
    }
    
    private func addGitHubLabel() {
        gitHubLabel.text = "https://github.com/cendolinside123"
        gitHubLabel.numberOfLines = 0
        gitHubLabel.textAlignment = .center
        gitHubLabel.textColor = .black
        view.addSubview(gitHubLabel)
    }
    
    private func addStackViewLabel() {
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(emailLabel)
        labelStackView.addArrangedSubview(gitHubLabel)
        view.addSubview(labelStackView)
    }
    
    private func setImageToCircle() {
        imagePP.layoutIfNeeded()
        imagePP.clipsToBounds = true
        imagePP.layer.cornerRadius = imagePP.bounds.width / 2
    }
    
}
