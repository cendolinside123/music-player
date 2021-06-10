//
//  QueueViewPresenter.swift
//  Music Player
//
//  Created by Mac on 21/04/21.
//

import Foundation
import UIKit

class QueueViewPresenter:NSObject {
    private var view: QueueViewController? = nil
    
    private var nowPlaying: Music? = nil
    private var listQueue = [Music]()
    private var queue: Queue? = nil
    private var musicPlayerCoreData: CoreDataMusicProtocol? = nil
    
    private var doReload: (()->())? = nil
    override init() {
        super.init()
    }
    
    convenience init(view:QueueViewController) {
        self.init()
        self.view = view
        
        self.view?.getTable().register(QueueTableViewCell.self, forCellReuseIdentifier: "queueCell")
        self.view?.getTable().delegate = self
        self.view?.getTable().dataSource = self
        self.view?.getTable().allowsMultipleSelection = false
        queue = Queue(coreData: (self.view?.returnCoreDataStack())!)
        musicPlayerCoreData = CoreDataMusic()
        
        self.nowPlaying = QueueTemp.queue[0]
        var temp = QueueTemp.queue
        temp.remove(at: 0)
        self.listQueue = temp
        
        
    }
    
}


extension QueueViewPresenter {
    private func reSetupCoreDataQueue(getCliced: Music) {
        self.view?.returnCoreDataStack()?.doInBackground(managedContext: { [weak self] context in
            self?.musicPlayerCoreData?.deleteAllSong(managedContext: context, success: {
                self?.musicPlayerCoreData?.addAllSong(managedContext: context, musics: QueueTemp.queue, success: {
                    print("success update urutan queue")
                    
                    self?.nowPlaying = QueueTemp.queue[0]
                    var temp = QueueTemp.queue
                    temp.remove(at: 0)
                    self?.listQueue = temp
                    
                    DispatchQueue.main.async {
                        self?.view?.getTable().reloadData()
                        self?.view?.getClickedSong?(getCliced)
                    }
                }, failed: {
                    print("gagal update urutan queue")
                })
            }, failed: {
                print("failed update queue")
            })
        })
    }
}

extension QueueViewPresenter:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return listQueue.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "queueCell", for: indexPath) as? QueueTableViewCell else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        
        if indexPath.section == 0 {
            if let play = nowPlaying {
                cell.setData(music: play)
            }
        } else {
            cell.setData(music: listQueue[indexPath.row])
        }
        
        
        
        return cell
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Now Playing"
        } else {
            return "Queue"
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section != 0 {
            
            let getOldNowPlaying = nowPlaying!
            
            let getCliced = listQueue[indexPath.row]
            
            
            var temp = QueueTemp.queue
            let getNew = temp.firstIndex(where: { $0.title == getCliced.title })!
            let element = temp.remove(at: getNew)
            temp.insert(element, at: 0)
            let getOld = temp.firstIndex(where: { $0.title == getOldNowPlaying.title })!
            let element2 = temp.remove(at: getOld)
            temp.insert(element2, at: temp.count)
            QueueTemp.queue = temp
            
            reSetupCoreDataQueue(getCliced: getCliced)
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


