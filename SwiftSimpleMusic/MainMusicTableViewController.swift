  //
  //  MainMusicTableViewController.swift
  //  SwiftSimpleMusic
  //
  //  Created by David Rynn on 9/13/16.
  //  Copyright © 2016 David Rynn. All rights reserved.
  //
  
  import UIKit
  import MediaPlayer
  
  class MainMusicTableViewController: UITableViewController {
    
    var viewModel: MainMusicViewModelProtocol!
    var searchController: UISearchController!
    fileprivate var player: MusicPlayer!
    fileprivate var currentSort: MediaSortType!
    lazy var players: [String] = {
        var temporaryPlayers = [String]()
        temporaryPlayers.append("John Doe")
        return temporaryPlayers
    }()
    var arraySetOutsideClass: [String]? {
        didSet {
            if let stringArray = arraySetOutsideClass {
                players = stringArray
            }
        }
    }
    
    fileprivate var sortButton: UIButton = UIButton(type: UIButtonType.custom)
    @IBOutlet weak var loopButton: UIBarButtonItem!
    @IBOutlet weak var shuffleButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        assertDependencies()
        setupSortButton()
        setupSearchBar()
        
        self.tableView.sectionIndexColor = UIColor.red
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.setPlayerQueue(sortType: currentSort)
    }
    
    func setupSortButton(){
        let buttonView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        sortButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30);
        sortButton.setTitle(MediaSortType.songs.description, for: UIControlState())
        currentSort = MediaSortType.songs
        sortButton.backgroundColor = UIColor(red: 253/255, green: 227/255, blue: 167/255, alpha: 1.0 )
        sortButton.setTitleColor(UIColor.black, for: .normal)
        sortButton.layer.borderColor = UIColor.lightGray.cgColor
        sortButton.layer.borderWidth = 1
        sortButton.layer.cornerRadius = 10
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        sortButton.dropShadow()
        buttonView.addSubview(sortButton)
        self.navigationItem.titleView = buttonView
    }
    
    func setupSearchBar(){
        searchController = UISearchController(searchResultsController: nil)
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        
        searchController.searchBar.sizeToFit()
        tableView.tableHeaderView = searchController.searchBar
        
        // Sets this view controller as presenting view controller for the search interface
        definesPresentationContext = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel.numberOfSections(sortType: currentSort)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsForSection(sortType: currentSort, section: section)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return viewModel.sectionIndexTitles(sortType: currentSort)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.titleForSection(sortType: currentSort, section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MusicTableViewCell else { fatalError("Wrong cell type") }
        guard let cellLabel = cell.textLabel else { return cell }
        guard let cellImageView = cell.imageView else { return cell }
        let tuple = viewModel.cellLabelText(sortType: currentSort, indexPath: indexPath)
        cellLabel.text = tuple?.title ?? ""
        if let cellDetail = cell.detailTextLabel {
            cellDetail.text = tuple?.detail ?? ""
        }
        
        cellImageView.image = viewModel.cellImage(sortType: currentSort, indexPath: indexPath)
        cell.cellModifier = 0.85
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if currentSort == MediaSortType.songs || viewModel.isSearching {
            viewModel.didSelectSongAtRowAt(indexPath: indexPath, sortType: currentSort)
        } else {
            performSegue(withIdentifier: "toSubMediaVC", sender: self)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSubMediaVC" {
            if let index = tableView.indexPathForSelectedRow, let dVC = segue.destination as? SubMediaTableViewController {
                let newViewModel = self.viewModel.getSubViewModel(sortType: currentSort, indexPath: index)
                dVC.inject(newViewModel)
            }
        }
    }
    
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
        if player.repeatMode == .none {
            player.repeatMode = .all
            loopButton.image = #imageLiteral(resourceName: "loop3")
        }
        else if player.repeatMode == .all {
            player.repeatMode = .one
            loopButton.image = #imageLiteral(resourceName: "loop2")
        }
        else if player.repeatMode == .one {
            player.repeatMode = .none
            loopButton.image = #imageLiteral(resourceName: "loop1")
        }
        navigationController?.reloadInputViews()
    
    }
    
    func sortButtonTapped(sender: UIButton) {
        //get switch off vc
        guard let titleLabel = sender.titleLabel else { return }
        guard let text = titleLabel.text else { return }
        let type = MediaSortType.getNextTypeFromText(text)
        sender.setTitle(String(describing: type), for: .normal)
        currentSort = type
        view.reloadInputViews()
        tableView.reloadData()
    }
  }
  
  extension MainMusicTableViewController: Injectable {
    
    func inject(_ item: MusicPlayer) {
        player = item
        viewModel = MainMusicViewModel(player: item)
    }
    
    func assertDependencies() {
        assert(player != nil)
    }
  }
  extension MainMusicTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            viewModel.searchMedia(searchText: searchText)
            tableView.reloadData()
        }
    }
  }
  extension MainMusicTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.isSearching = false
        tableView.reloadData()
    }
  }
  
  extension MainMusicTableViewController: PopUpViewButtonDelegate {
    func artistButtonTapped() {
        self.currentSort = MediaSortType.artists
        performSegue(withIdentifier: "toSubMediaVC", sender: self)
    }
    func albumButtonTapped() {
        self.currentSort = .albums
        performSegue(withIdentifier: "toSubMediaVC", sender: self)
    }
  }
