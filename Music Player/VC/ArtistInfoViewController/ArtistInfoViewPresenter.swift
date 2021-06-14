//
//  ArtistInfoViewPresenter.swift
//  Music Player
//
//  Created by Mac on 10/06/21.
//

import Foundation


class ArtistInfoViewPresenter {
    
    private var view: ArtistInfoViewController? = nil
    
    init(view:ArtistInfoViewController) {
        self.view = view
        displaySongInfo()
    }
    
    
}

extension ArtistInfoViewPresenter: ArtistInfoViewPresenterRule {
    func displaySongInfo() {
        if let namaArtist = self.view?.getArtistName() {
            
            if let getArtistInfo = Repo.artistInfo.first(where: { $0.name == namaArtist}) {
                self.view?.setArtist(name: namaArtist)
                self.view?.setArtistDetail(text: getArtistInfo.detail)
            }
        }
    }
    
    
}
