  //
//  MainMusicTableViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/13/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
//
//  MusicTableViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
import MediaPlayer

enum sortDisplay: CustomStringConvertible {
    case songs, albums, artists, genres, playlists
    
    var description: String {
        switch self {
        // Use Internationalization, as appropriate.
        case .songs: return "Songs"
        case .albums: return "Albums"
        case .artists: return "Artists"
        case .genres: return "Genres"
        case .playlists: return "Playlists"
        }
    }
    
}

class MainMusicTableViewController: UITableViewController {
    
    fileprivate var player: MusicPlayer!
    fileprivate var collection: MediaCollection!
    fileprivate var viewModel: MainMusicViewModel!
    fileprivate var sectionStructs: [SectionStruct]!
    fileprivate var musicLists: MusicLists!
    fileprivate var currentSort: String!
    
    fileprivate var sortButton: UIButton = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var loopButton: UIBarButtonItem!
    @IBOutlet weak var shuffleButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setupSortButton()
    }
    
    func setupSortButton(){
        let buttonView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 30))
        
        sortButton.frame = CGRect(x: 0, y: 0, width: 100, height: 30);
        sortButton.setTitle(sortDisplay.songs.description, for: UIControlState())
        currentSort = sortDisplay.songs.description
        sortButton.layer.borderColor = UIColor.lightGray.cgColor
        sortButton.layer.borderWidth = 1
        sortButton.layer.cornerRadius = 10
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        buttonView.addSubview(sortButton)
        self.navigationItem.titleView = buttonView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        
        return sectionStructs.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows

        let sectionStruct: SectionStruct = sectionStructs[section]
        
        return sectionStruct.songs.count
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        var indexArray: [String] = []
        for section in sectionStructs {
            indexArray.append(section.letter)
        }
        return indexArray
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionStructs[section].letter
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let sectionStruct = sectionStructs[(indexPath as NSIndexPath).section]
        
        let item = sectionStruct.songs[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = item.title
        let cellImage: UIImage?
        let imageViewModifier = CGFloat(0.25)
        let cellImageSize = CGSize(width: cell.imageView!.size.width*imageViewModifier, height: cell.imageView!.size.height*imageViewModifier)
        if let itemImage = item.artwork {
            cellImage = itemImage.image(at: cellImageSize)
        } else {
            cellImage = UIImage(named: "noteSml.png")
        }
        cell.imageView!.image = cellImage
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sectionStruct = sectionStructs[(indexPath as NSIndexPath).section]
        let item = sectionStruct.songs[(indexPath as NSIndexPath).row]
        
        if let nowPlayingItem = player.currentSong {
            
            if (nowPlayingItem.title == item.title){
                if player.currentPlaybackState() == MPMusicPlaybackState.playing {
                    player.pause()
                } else {
                    player.playItem(item)
                }
                
            } else {
                player.stop()
                player.playItem(item)
            }
        } else {
            player.playItem(item)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
//    MARK: - Actions
    

    @IBAction func shuffleButtonTapped(_ sender: AnyObject) {
        
        if (player.shuffleMode == MPMusicShuffleMode.off || player.shuffleMode.rawValue == 0) {
        player.shuffleMode = MPMusicShuffleMode.songs
            shuffleButton.image = UIImage(named: "shuffle2")
        }
        else if (player.shuffleMode == MPMusicShuffleMode.songs || player.shuffleMode.rawValue == 2) {
            player.shuffleMode = MPMusicShuffleMode.off
            shuffleButton.image = UIImage(named: "shuffle1")
        }
        navigationController?.reloadInputViews()
    }
    

    @IBAction func loopButtonTapped(_ sender: AnyObject) {
        
    }
    
    func sortButtonTapped(sender: UIButton) {
        
        guard let titleLabel = sender.titleLabel else { return }
        guard let text = titleLabel.text else { return }
        switch text {
        case sortDisplay.albums.description:
            sender.setTitle(sortDisplay.artists.description, for: UIControlState.normal)
            sectionStructs = musicLists.artists
        case sortDisplay.artists.description:
            sender.setTitle(sortDisplay.genres.description, for: UIControlState.normal)
            sectionStructs = musicLists.genres
        case sortDisplay.genres.description:
            sender.setTitle(sortDisplay.playlists.description, for: UIControlState.normal)
            sectionStructs = musicLists.playlists
        case sortDisplay.playlists.description:
            sender.setTitle(sortDisplay.songs.description, for: UIControlState.normal)
            sectionStructs = musicLists.songs
        case sortDisplay.songs.description:
            sender.setTitle(sortDisplay.albums.description, for: UIControlState.normal)
            sectionStructs = musicLists.albums
        default:
            sender.setTitle(sortDisplay.songs.description, for: UIControlState.normal)
            sectionStructs = musicLists.songs
        }
        
        view.reloadInputViews()
        tableView.reloadData()
    }
    
}
extension MainMusicTableViewController: Injectable {
    
    func inject(_ item: MusicPlayer) {
        player = item
        collection = item.collection
        viewModel = MainMusicViewModel(collection: collection)
        musicLists = viewModel.fullCollections()
        sectionStructs = musicLists.songs
    }
    
    func assertDependencies() {
        assert(player != nil)
    }
    
}

