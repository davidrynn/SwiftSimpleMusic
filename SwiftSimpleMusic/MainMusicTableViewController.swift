  //
  //  MainMusicTableViewController.swift
  //  SwiftSimpleMusic
  //
  //  Created by David Rynn on 9/13/16.
  //  Copyright © 2016 David Rynn. All rights reserved.
  //
  
  import UIKit
  import MediaPlayer
  
  /// Everything the main list needs; only constructed once the async player is ready.
  struct MainMusicDependencies {
    let player: MusicPlayerProtocol
    let viewModel: MainMusicViewModelProtocol
  }
  
  final class MainMusicTableViewController: UITableViewController {
    
    var viewModel: MainMusicViewModelProtocol?
    var searchController: UISearchController!
    fileprivate var player: MusicPlayerProtocol?
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
    
      fileprivate var sortButton: UIButton = UIButton(type: UIButton.ButtonType.custom)
    @IBOutlet weak var loopButton: UIBarButtonItem!
    @IBOutlet weak var shuffleButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // assertDependencies()  <-- Removed as per instructions
        setupSortButton()
        setupSearchBar()
        
        self.tableView.sectionIndexColor = UIColor.red
        updateEnabledState()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.setPlayerQueue(sortType: currentSort)
    }
    
    func setupSortButton(){
        let buttonView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 150, height: 30))
        
        sortButton.frame = CGRect(x: 0, y: 0, width: 150, height: 30);
        sortButton.setTitle(MediaSortType.songs.description, for: UIControl.State())
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
        searchController.obscuresBackgroundDuringPresentation = false
        
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
        return viewModel?.numberOfSections(sortType: currentSort) ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsForSection(sortType: currentSort, section: section) ?? 0
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        
        return viewModel?.sectionIndexTitles(sortType: currentSort)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.titleForSection(sortType: currentSort, section: section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? MusicTableViewCell else { fatalError("Wrong cell type") }
        guard let cellLabel = cell.textLabel else { return cell }
        guard let cellImageView = cell.imageView else { return cell }
        guard let viewModel else { return cell }
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
        //1.set selected song// representative song
        viewModel?.setSelectedItem(sortType: currentSort, indexPath: indexPath)
        guard let viewModel else { return }

        //if song toggle play
        if (currentSort == .songs && viewModel.appState != .isSearching) || (currentSort == .audiobooks) || (viewModel.appState == .isSearching && SearchSection.typeForSection(indexPath.section) == .songs) {
            viewModel.togglePlayingSelectedSong()
            return
        }
        //Otherwise segue appropriately
        performSegue(withIdentifier: "toSubMediaVC", sender: self)

    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "toSubMediaVC" {
            if let index = tableView.indexPathForSelectedRow, let viewModel, let dVC = segue.destination as? SubMediaTableViewController {
                
                switch viewModel.appState {
                case .isSearching:
                    let searchSection = SearchSection.typeForSection(index.section)
                    let newViewModel = viewModel.getSubViewModelFromSearch(section: searchSection, indexPath: index)
                    dVC.inject(newViewModel)
                case .isShowingPopUp:
                    guard let item = player?.currentSong else { return }
                    let newViewModel = viewModel.getSubViewModel(sortType: currentSort, item: item)
                    dVC.inject(newViewModel)
                case .normal:
                    let newViewModel = viewModel.getSubViewModelFromSelectedRow(sortType: currentSort)
                    dVC.inject(newViewModel)                    
                }
                
            }
        }
    }
    
    //    MARK: - Actions
    @IBAction func shuffleButtonTapped(_ sender: UIBarButtonItem) {
        player?.toggleShuffleMode(shuffleButton: sender)
        navigationController?.reloadInputViews()
    }
    
    
    @IBAction func loopButtonTapped(_ sender: UIBarButtonItem) {
        player?.toggleLoopMode(loopButton: sender)
        navigationController?.reloadInputViews()
        
    }
    
    @objc func sortButtonTapped(sender: UIButton) {
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
  
extension MainMusicTableViewController: @MainActor Injectable {
    
    /// Called by `TopViewController` once the async player and view model are ready.
    /// May arrive before or after the view has loaded/appeared.
    func inject(_ item: MainMusicDependencies) {
        player = item.player
        viewModel = item.viewModel
        guard isViewLoaded else { return }
        updateEnabledState()
        // viewWillAppear may already have run with no view model, so set the queue now.
        viewModel?.setPlayerQueue(sortType: currentSort)
        tableView.reloadData()
    }
    
    func assertDependencies() {
        assert(player != nil && viewModel != nil)
    }
    
    /// Keep controls inert until dependencies arrive.
    fileprivate func updateEnabledState() {
        let isReady = viewModel != nil
        shuffleButton?.isEnabled = isReady
        loopButton?.isEnabled = isReady
        sortButton.isEnabled = isReady
        searchController?.searchBar.isUserInteractionEnabled = isReady
    }
  }
  extension MainMusicTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            viewModel?.searchMedia(searchText: searchText)
            tableView.reloadData()
        }
    }
  }
  extension MainMusicTableViewController: UISearchControllerDelegate {
    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel?.appState = .normal
        tableView.reloadData()
    }
  }
  
extension MainMusicTableViewController: @MainActor PopUpViewButtonDelegate {
    func artistButtonTapped() {
        self.currentSort = MediaSortType.artists
        performSegue(withIdentifier: "toSubMediaVC", sender: self)
    }
    func albumButtonTapped() {
        self.currentSort = .albums
        performSegue(withIdentifier: "toSubMediaVC", sender: self)
    }
  }
  
  extension MusicListViewProtocol {
  }
