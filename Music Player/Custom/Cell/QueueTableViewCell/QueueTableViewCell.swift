//
//  QueueTableViewCell.swift
//  Music Player
//
//  Created by Mac on 21/04/21.
//

import UIKit

class QueueTableViewCell: UITableViewCell {
    
    let labelTitle = UILabel()
    let labelArtist = UILabel()
    let imageArtist = UIImageView()
    private let stackViewContent:UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        return stack
    }()
    
    private let containerContent:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 10
        return stack
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup() {
        self.backgroundColor = .white
        addLayout()
        addConstraints()
    }
    
    private func addLayout() {
        addImage()
        addLabelTitle()
        addLabelArtist()
        addStackView()
    }
    
    private func addConstraints() {
        let views = ["containerContent":containerContent]
        let metrix:[String:Any] = [:]
        
        var constraints = [NSLayoutConstraint]()
        
        //MARK: stackViewContent constraints
        
        containerContent.translatesAutoresizingMaskIntoConstraints = false
        
        let hContainerContent = "H:|-10-[containerContent]-10-|"
        let vContainerContent = "V:|-0-[containerContent]-0-|"
        
        constraints += NSLayoutConstraint.constraints(withVisualFormat: hContainerContent, options: .alignAllTop, metrics: metrix, views: views)
        constraints += NSLayoutConstraint.constraints(withVisualFormat: vContainerContent, options: .alignAllCenterX, metrics: metrix, views: views)
        
        //MARK: labelTitle and labelArtist constraints
        labelTitle.translatesAutoresizingMaskIntoConstraints = false
        labelArtist.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: labelTitle, attribute: .height, relatedBy: .equal, toItem: labelArtist, attribute: .height, multiplier: 5/3, constant: 0)]
        
        //MARK: imageArtist constraint
        imageArtist.translatesAutoresizingMaskIntoConstraints = false
        
        constraints += [NSLayoutConstraint(item: imageArtist, attribute: .width, relatedBy: .equal, toItem: contentView, attribute: .width, multiplier: 1/9, constant: 0)]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addLabelTitle() {
        labelTitle.text = "Title"
        labelTitle.textColor = .black
        self.contentView.addSubview(labelTitle)
    }
    
    private func addLabelArtist() {
        labelArtist.text = "Artist"
        labelArtist.textColor = .darkGray
        self.contentView.addSubview(labelArtist)
    }
    
    private func addImage() {
        imageArtist.image = #imageLiteral(resourceName: "musicDefault")
        self.contentView.addSubview(imageArtist)
    }
    
    private func addStackView() {
        stackViewContent.addArrangedSubview(labelTitle)
        stackViewContent.addArrangedSubview(labelArtist)
        
        self.contentView.addSubview(stackViewContent)
        
        containerContent.addArrangedSubview(imageArtist)
        containerContent.addArrangedSubview(stackViewContent)
        
        self.contentView.addSubview(containerContent)
    }

}

extension QueueTableViewCell {
    func setData(music:Music) {
        labelArtist.text = music.artist
        labelTitle.text = music.title
        imageArtist.setImage(url: UserDefaults.standard.string(forKey: "nowPlayingImage") ?? "")
    }
    
    func returnImageArtist_Property() -> UIImageView {
        return imageArtist
    }
    
}
