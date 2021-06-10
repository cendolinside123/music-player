//
//  HomeViewController.swift
//  Music Player
//
//  Created by Mac on 09/04/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    static var minHeight: CGFloat {
        return DeviceType.current.isIphoneXClass ? 83 : 50
    }
    static var maxHeight: CGFloat {
        return DeviceType.current.isIphoneXClass ? 125 : 100
    }
    
    private let navigationBar = NavigationBar()
    private let scrollView = UIScrollView()
    private let homeStackView:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.distribution = .fill
        stack.alignment = .fill
        stack.spacing = 12
        stack.layoutMargins.left = 10
        stack.layoutMargins.right = 10
        stack.isLayoutMarginsRelativeArrangement = true
        return stack
    }()
    
    private let contentGallowParkers = SubContent()
    private let contentGallowTooVirgin = SubContent()
    private let content_nZk = SubContent()
    let viewInfo = ViewInfo()
    private let emptyView = UIView()
    
    private lazy var musicPlayerView:UIViewController = {
        let musicVC = MusicPlayerViewController()
        
        if let dt = coreDataStack {
            musicVC.addCoreDataStack(coreData: dt)
        }
        
        
        
        return musicVC
    }()
    
    private var coreDataStack: CoreDataStack? = nil
    
    
    private var queue:Queue? = nil
    var updateSongInfo: (()->())? = nil
    
    private var presenter:HomeViewPresenter? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        // Do any additional setup after loading the view.
        
        presenter = HomeViewPresenter(view: self)
        
        addLayout()
        addConstraints()
        contentGallowParkers.setContent(data: Repo.gallow_ParkestAlbum)
        contentGallowTooVirgin.setContent(data: Repo.gallow_TooVirginAlbum)
        content_nZk.setContent(data: Repo.nZk_BestOfVocalWorks2Album)
        
        contentGallowParkers.setTitle(title: "Gallow: Parkers")
        contentGallowTooVirgin.setTitle(title: "Gallow: To Virgint!!")
        content_nZk.setTitle(title: "SawanoHiroyuki[nZk]: BEST OF VOCAL WORKS [nZk] 2")
        
        contentGallowParkers.addImageUrl(url: "https://i1.sndcdn.com/artworks-000513975783-35fqbz-t500x500.jpg")
        contentGallowTooVirgin.addImageUrl(url: "https://img.discogs.com/LUtxLPZMtlsaBfTY0UlBCV6WK8I=/fit-in/384x379/filters:strip_icc():format(webp):mode_rgb():quality(90)/discogs-images/R-13986286-1565521150-4543.jpeg.jpg")
        content_nZk.addImageUrl(url: "https://images.genius.com/86bb485f11d08b9afcd9da32504cac18.1000x1000x1.jpg")
        
        
        contentGallowParkers.clickedSong = { [weak self] listSong in
            
            
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.contentGallowParkers.getImageURL() ?? "")
            
            self?.presenter?.updateViewInfo()
        }
        
        contentGallowTooVirgin.clickedSong = { [weak self] listSong in
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.contentGallowTooVirgin.getImageURL() ?? "")
            
            self?.presenter?.updateViewInfo()
        }
        
        content_nZk.clickedSong = { [weak self] listSong in
            for lagu in listSong {
                print("title: \(lagu.title) , artist: \(lagu.artist)")
            }
            
            self?.addToQueue(music: listSong)
            self?.setImage(image:self?.content_nZk.getImageURL() ?? "")
            
            self?.presenter?.updateViewInfo()
        }
        
        configureMusicPlayer()
        
        
        updateSongInfo = { [weak self] in
            
            
            self?.presenter?.updateQueue()
            (self?.musicPlayerView as? MusicPlayerViewController)?.doUpdate?()
            
        }
        
        (musicPlayerView as? MusicPlayerViewController)?.doUpdateQueue = { [weak self] in
            self?.presenter?.updateQueue()
        }
        
        
        updateSongInfo?()
        
        
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
        addNavigationBar()
        addScrollView()
        addContentGallowParkers()
        addContentGallowTooVirgin()
        addContent_nZk()
        addEmptyView()
        addHomeStackView()
        addViewInfo()
        
    }
    
    private func addConstraints() {
        let views = ["scrollView":scrollView,"homeStackView":homeStackView,"viewInfo":viewInfo,"navigationBar":navigationBar]
        let metrix:[String:Any] = ["view_width":self.view.frame.width]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: scrollView & navigationBar constraints
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        navigationBar.translatesAutoresizingMaskIntoConstraints = false
        let hScrollView = "H:|-0-[scrollView]-0-|"
        let vScrollView = "V:|-[navigationBar]-0-[scrollView]-0-|"
        
        let hNavigationBar = "H:|-0-[navigationBar]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hNavigationBar, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hScrollView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vScrollView, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: navigationBar, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 0.8/9, constant: 0)]
        
        //MARK: homeStackView constraints
        homeStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let hHomeStackView = "H:|-0-[homeStackView(view_width)]-0-|"
        let vHomeStackView = "V:|-30-[homeStackView]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hHomeStackView, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vHomeStackView, options: .alignAllLeading, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: homeStackView, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)]
        
        //MARK: contentGallowParkers , contentGallowTooVirgin , and content_nZk
        contentGallowParkers.translatesAutoresizingMaskIntoConstraints = false
        contentGallowTooVirgin.translatesAutoresizingMaskIntoConstraints = false
        content_nZk.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: contentGallowParkers, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 350)]
        constraints += [NSLayoutConstraint(item: contentGallowTooVirgin, attribute: .height, relatedBy: .equal, toItem: contentGallowParkers, attribute: .height, multiplier: 1, constant: 0)]
        constraints += [NSLayoutConstraint(item: content_nZk, attribute: .height, relatedBy: .equal, toItem: contentGallowParkers, attribute: .height, multiplier: 1, constant: 0)]
        
        //MARK: viewInfo and emptyView constraints
        viewInfo.translatesAutoresizingMaskIntoConstraints = false
        emptyView.translatesAutoresizingMaskIntoConstraints = false
        
        let hViewInfo = "H:|-0-[viewInfo]-0-|"
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hViewInfo, options: .alignAllBottom, metrics: metrix, views: views)
        constraints += [NSLayoutConstraint(item: viewInfo, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)]
        
        let isAlreadyShow = UserDefaults.standard.value(forKey: "viewInfo") as? Bool ?? false
        
        var constraintBottom:NSLayoutConstraint? = nil
        var constraintEmptyView:NSLayoutConstraint? = nil
        
        
        constraintBottom = self.presenter?.setupViewInfo(item: viewInfo)
        
        constraintEmptyView = NSLayoutConstraint(item: emptyView, attribute: .height, relatedBy: .equal, toItem: view, attribute: .height, multiplier: 1/9, constant: 0)
        
        constraintBottom!.identifier = "viewInfo_constraintBottom"
        constraints += [constraintBottom!]
        
        constraintEmptyView!.identifier = "constraintEmptyView_height"
        constraints += [constraintEmptyView!]
        
        NSLayoutConstraint.activate(constraints)
        
    }
    private func addNavigationBar() {
        //navigationBar.backgroundColor = .blue
        view.addSubview(navigationBar)
    }
    
    private func addScrollView() {
        view.addSubview(scrollView)
    }
    
    private func addHomeStackView() {
        homeStackView.addArrangedSubview(contentGallowParkers)
        homeStackView.addArrangedSubview(contentGallowTooVirgin)
        homeStackView.addArrangedSubview(content_nZk)
        homeStackView.addArrangedSubview(emptyView)
        scrollView.addSubview(homeStackView)
    }
    
    private func addContentGallowParkers() {
        scrollView.addSubview(contentGallowParkers)
    }
    
    private func addContentGallowTooVirgin() {
        scrollView.addSubview(contentGallowTooVirgin)
    }
    
    private func addContent_nZk() {
        scrollView.addSubview(content_nZk)
    }
    
    private func addEmptyView() {
        
        emptyView.isHidden = self.presenter!.setupEmptyView()
        
        scrollView.addSubview(emptyView)
    }
    
    private func addViewInfo() {
        viewInfo.backgroundColor = .white
        let gesture = UITapGestureRecognizer(target: self, action: #selector(showMusicPlayer))
        viewInfo.addGestureRecognizer(gesture)
        viewInfo.addImage(url: UserDefaults.standard.string(forKey: "nowPlayingImage") ?? "")
        view.addSubview(viewInfo)
    }
    
    
    private func configureMusicPlayer() {
        view.addSubview(musicPlayerView.view)
        
        //view.bringSubviewToFront(view)
    }

}

extension HomeViewController {
    func updateConstraints_ViewInfo() {
        
        UserDefaults.standard.set(true, forKey: "viewInfo")
        
        
        var constraints = view.constraints
        NSLayoutConstraint.deactivate(constraints)
        
        let viewInfo_constraintBottom = constraints.firstIndex(where: { (constraint) -> Bool in
            constraint.identifier == "viewInfo_constraintBottom"
        })
        
        let constraintEmptyView_height = constraints.firstIndex(where: { (constraint) -> Bool in
            constraint.identifier == "constraintEmptyView_height"
        })
        
        constraints[viewInfo_constraintBottom!] = NSLayoutConstraint(item: viewInfo, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        constraints[viewInfo_constraintBottom!].identifier = "viewInfo_constraintBottom"
        
        
        emptyView.isHidden = false
        
        NSLayoutConstraint.activate(constraints)
        
        
    }
    
    @objc private func showMusicPlayer() {
        (musicPlayerView as? MusicPlayerViewController)?.maximizePanelController(animated: true, duration: 0.5, completions: nil)
    }
    
    private func setImage(image:String) {
        if image != "" {
            UserDefaults.standard.setValue(image, forKey: "nowPlayingImage")
            
        }
        
        viewInfo.addImage(url: image)
    }
    
}

extension HomeViewController {
    
    func addCoreDataStack(coreData: CoreDataStack) {
        coreDataStack = coreData
        
        if (musicPlayerView as? MusicPlayerViewController)?.returnCoreDataStack() == nil {
            (musicPlayerView as? MusicPlayerViewController)?.addCoreDataStack(coreData: coreDataStack!)
        }
        
    }
    
    func returnCoreDataStack() -> CoreDataStack? {
        return self.coreDataStack
    }
    
    private func addToQueue(music:[Music]) {
        
        self.presenter?.addQueue(music: music)
        
    }
}

