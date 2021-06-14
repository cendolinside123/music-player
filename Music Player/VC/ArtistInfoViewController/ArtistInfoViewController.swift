//
//  ArtistInfoViewController.swift
//  Music Player
//
//  Created by Mac on 10/06/21.
//

import UIKit

class ArtistInfoViewController: UIViewController {
    
    private let navBar = NavBarPageDetail()
    private let imageArtist = UIImageView()
    private let nameLabel = UILabel()
    private let viewDetail = UIScrollView()
    private let labelDetailArtist = UILabel()
    private let contentView = UIView()
    
    private var artistName:String = ""
    private var presenter: ArtistInfoViewPresenterRule? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .white
        
        addLayout()
        addConstraints()
        setImageToCircle()
        
        navBar.setButtonCloseText(text: "X")
        navBar.addTite(text: "Detail Artist")
        navBar.doAction = {
            self.dismiss(animated: true, completion: {
                
            })
        }
        presenter = ArtistInfoViewPresenter(view: self)
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
        addNavBar()
        addImageArtist()
        addNameLabel()
        addViewDetail()
        addLabelDetailArtist()
    }
    
    private func addConstraints() {
        let views = ["navBar":navBar,"imageArtist":imageArtist,"nameLabel":nameLabel,"viewDetail":viewDetail,"labelDetailArtist":labelDetailArtist,"contentView":contentView]
        
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: navBar , imageArtist , nameLabel and viewDetail constraints
        
        navBar.translatesAutoresizingMaskIntoConstraints = false
        imageArtist.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        viewDetail.translatesAutoresizingMaskIntoConstraints = false
        
        let vTabBar_Content = "V:|-[navBar]-10-[imageArtist]-20-[nameLabel]-10-[viewDetail]-0-|"
        let hTabBar = "H:|-0-[navBar]-0-|"
        let hNameLabel = "H:|-5-[nameLabel]-5-|"
        let hViewDetail = "H:|-0-[viewDetail]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vTabBar_Content, options: .alignAllCenterX, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hTabBar, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hNameLabel, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hViewDetail, options: .alignAllTop, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: imageArtist, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: navBar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.8/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: imageArtist, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 2/9, constant: 0)]
        constraints += [NSLayoutConstraint(item: imageArtist, attribute: .height, relatedBy: .equal, toItem: imageArtist, attribute: .width, multiplier: 1, constant: 0)]
        
        //MARK: labelDetailArtist and contentView constraints
        
        labelDetailArtist.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        let vContentView = "V:|-0-[contentView]-0-|"
        let hContentView = "H:|-0-[contentView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContentView, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContentView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: contentView, attribute: .width, relatedBy: .equal, toItem: view, attribute: .width, multiplier: 1, constant: 0)]
        
        let vLabelDetailArtist = "V:|-0-[labelDetailArtist]|"
        let hLabelDetailArtist = "H:|-[labelDetailArtist]-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vLabelDetailArtist, options: .alignAllCenterX, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hLabelDetailArtist, options: .alignAllTop, metrics: metrix, views: views)
        
        //constraints += [NSLayoutConstraint(item: labelDetailArtist, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1, constant: 0)]
        //constraints += [NSLayoutConstraint(item: labelDetailArtist, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)]
        
        
        
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func addNavBar() {
        view.addSubview(navBar)
    }
    
    private func addImageArtist() {
        imageArtist.image = #imageLiteral(resourceName: "musicDefault")
        view.addSubview(imageArtist)
    }
    
    private func addNameLabel() {
        nameLabel.text = "aaaaa"
        nameLabel.numberOfLines = 0
        nameLabel.font = UIFont.boldSystemFont(ofSize: 28)
        nameLabel.textAlignment = .center
        nameLabel.textColor = .black
        view.addSubview(nameLabel)
    }
    
    private func addViewDetail() {
        contentView.backgroundColor = .white
        viewDetail.showsHorizontalScrollIndicator = false
        viewDetail.isDirectionalLockEnabled = true
        view.addSubview(viewDetail)
        viewDetail.addSubview(contentView)
    }
    
    private func addLabelDetailArtist() {
        labelDetailArtist.numberOfLines = 0
        labelDetailArtist.textAlignment = .justified
        labelDetailArtist.lineBreakMode = .byClipping
        contentView.addSubview(labelDetailArtist)
    }
}

extension ArtistInfoViewController {
    
    func setArtist(name:String) {
        artistName = name
        nameLabel.text = artistName
    }
    
    func getArtistName() -> String {
        return artistName
    }
    
    func setArtistDetail(text: String) {
        imageArtist.setImage(url: UserDefaults.standard.string(forKey: "nowPlayingImage") ?? "")
        labelDetailArtist.text = text
    }
    
    private func setImageToCircle() {
        imageArtist.layoutIfNeeded()
        imageArtist.clipsToBounds = true
        imageArtist.layer.cornerRadius = imageArtist.bounds.width / 2
    }
    
    
}

extension ArtistInfoViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        viewDetail.contentOffset.x = 0
    }
}
