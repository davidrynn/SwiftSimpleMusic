//
//  TopViewController.swift
//  SwiftSimpleMusic
//
//  Created by David Rynn on 9/10/16.
//  Copyright © 2016 David Rynn. All rights reserved.
//

import UIKit
import MediaPlayer
import SwiftUI

class TopViewController: UIViewController {
    @IBOutlet weak var forwardButton: NSLayoutConstraint!
    
    @IBOutlet weak var playButton: PlayButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var playbackControlView: UIView!
    
    private let popUpViewController = PopUpViewController()
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    lazy var popUpViewY: CGFloat = {
        
        return self.view.frame.size.height*4/5
        
    }()
    var player: MusicPlayer?
    var forwardVM = ForwardButtonViewModel()
    /// Captured from the embed segue. The embed segue fires while this view is still
    /// loading, before the player exists, so dependencies are injected later in `loadDependencies()`.
    private(set) weak var mainMusicVC: MainMusicTableViewController?
    private let loadingView = LoadingView()
    /// Fills the home-indicator strip under the playback controls so the pop-up doesn't show through.
    private let bottomFillView = UIView()
    /// Pop-up position state, so layout passes don't snap it back to collapsed.
    private var isPopUpExpanded = false
    private var isDraggingPopUp = false

    override func viewDidLoad() {

        super.viewDidLoad()

        setupBottomFillView()
        showLoadingView()
        Task { [weak self] in
            await self?.loadDependencies()
        }
    }

    private func loadDependencies() async {
        let player: MusicPlayer
        do {
            player = try await MusicPlayer()
        } catch {
            loadingView.showError(message(for: error))
            presentInitializationError(error)
            return
        }
        self.player = player

        // Only build the view model once the player is ready, then hand both to the main VC.
        let viewModel = MainMusicViewModel(player: player)
        mainMusicVC?.inject(MainMusicDependencies(player: player, viewModel: viewModel))

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playbackStateDidChange),
            name: .MPMusicPlayerControllerPlaybackStateDidChange,
            object: nil
        )
        let forwardHostingController = UIHostingController(rootView: ForwardButtonSUI(viewModel: forwardVM))

        addChild(forwardHostingController)
        addChild(popUpViewController)
        view.addSubview(popUpViewController.view)
        popUpViewController.didMove(toParent: self)

        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(detectPan(_:)))
        popUpViewController.view.gestureRecognizers = [panRecognizer]
        popUpViewController.player = player
        popUpViewController.updateArtworkImage()
        let popUpView = popUpViewController.view as? PopUpView
        popUpView?.popUpScrollDelegate = self as PopUpScrollDelegate
        popUpView?.delegate = mainMusicVC

        hideLoadingView()
    }

    private func setupBottomFillView() {
        bottomFillView.backgroundColor = playbackControlView.backgroundColor
        bottomFillView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bottomFillView)
        NSLayoutConstraint.activate([
            bottomFillView.topAnchor.constraint(equalTo: playbackControlView.bottomAnchor),
            bottomFillView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomFillView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bottomFillView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func showLoadingView() {
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: containerView.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
    }

    private func hideLoadingView() {
        UIView.animate(withDuration: 0.2, animations: {
            self.loadingView.alpha = 0
        }, completion: { _ in
            self.loadingView.removeFromSuperview()
        })
    }
    
    //put viewdidlayout so that we know everything else is formatted correctly before subviews are layed out.
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        // Layout can run at any time (rotation, safe area, nav bar updates), so place the
        // pop-up from its state instead of always collapsing it, and leave it alone mid-drag.
        if !isDraggingPopUp {
            popUpViewController.view.frame = CGRect(x: 0, y: isPopUpExpanded ? 0 : self.popUpViewY, width: self.view.frame.size.width, height: self.view.height)
        }
        (popUpViewController.view as? PopUpView)?.bottomOverlapHeight = view.bounds.height - playbackControlView.frame.minY
        self.view.bringSubviewToFront(playbackControlView)
        self.view.bringSubviewToFront(bottomFillView)
        
    }
    
    
    func setupButtons(){
        //        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(TopViewController.backButtonTapped(_:))  //Tap function will call when user tap on button
        //        let longGesture = UILongPressGestureRecognizer(target: self, action: "Long") //Long function will call when user long press on button.
        //        tapGesture.numberOfTapsRequired = 1
        //        .addGestureRecognizer(tapGesture)
        //        btn.addGestureRecognizer(longGesture)
    }
    
    
    //    MARK: Actions
    
    @objc func detectPan(_ recognizer: UIPanGestureRecognizer){
        guard let popUpView = popUpViewController.view as? PopUpView else {
            return
        }
        let translation = recognizer.translation(in: self.view)
        switch recognizer.state {
        case .began:
            isDraggingPopUp = true
            lastLocation = popUpView.center
        case .ended, .cancelled, .failed:
            isDraggingPopUp = false
            animateView(direction: translation.y)
        default:
            break
        }
        if isDraggingPopUp {
            popUpView.center.y = lastLocation.y + translation.y
        }
        
        fadeTopBarWithDrag()

        
    }
    
    func fadeTopBarWithDrag() {
        guard let popUpView = popUpViewController.view as? PopUpView else {
            return
        }
        let fadeStartY: CGFloat = self.view.height/2
        if popUpView.y < fadeStartY {
            popUpViewController.topBarOpacity = CGFloat(popUpView.y/fadeStartY)
        } else {
            popUpViewController.topBarOpacity = 1.0
        }
    }
    
    func animateView(direction: CGFloat) {
        guard let popUpView = popUpViewController.view as? PopUpView else {
            return
        }
        if direction < 0 {
            //if direction up
            isPopUpExpanded = popUpView.y <= self.view.height*3/4
        } else {
            //if direction down
            isPopUpExpanded = popUpView.y < self.view.height/15
        }
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [], animations: {
            if self.isPopUpExpanded {
                popUpView.centerVerticallyInSuperview()
            } else {
                popUpView.y = self.popUpViewY
            }
            self.fadeTopBarWithDrag()
        }, completion: nil)
        
    }
    
    
    
    @objc private func playbackStateDidChange() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.playButton.isPlaying = self.player?.currentPlaybackState() == .playing
        }
    }

    @IBAction func playButtonTapped(_ sender: AnyObject) {
        guard let player = player else { return }
        if player.currentPlaybackState() == MPMusicPlaybackState.playing {
            player.pause()
        } else {
            player.play()
        }
    }
    
    @IBAction func forwardButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state == .ended {
            player?.endSeeking()
        }
        if sender.state == .began {
            player?.beginSeekingForward()
        }
    }
    @IBAction func forwardButtonTapped(_ sender: UITapGestureRecognizer) {
        player?.skipToNextItem()
    }
    
    func forwardButtonTappedSUI() {
        
    }
    
    @IBAction func backButtonLongPressed(_ sender: UILongPressGestureRecognizer) {
        sender.minimumPressDuration = 1.0
        if sender.state == .ended {
            player?.endSeeking()
        }
        if sender.state == .began {
            player?.beginRewind()
        }
        
    }
    
    
    @IBAction fileprivate func backButtonTapped(_ sender: UITapGestureRecognizer) {
        player?.playPreviousItem()
    }
    
    
    
    //    MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toMusicTableViewController" {
            let navController = segue.destination as? UINavigationController
            mainMusicVC = navController?.topViewController as? MainMusicTableViewController
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory warning dude")
        // Dispose of any resources that can be recreated.
    }
    
    private func message(for error: Error) -> String {
        if let mpError = error as? MusicPlayerError, let description = mpError.errorDescription {
            return description
        }
        return error.localizedDescription
    }

    private func presentInitializationError(_ error: Error) {
        let alert = UIAlertController(title: "Unable to Access Music Library", message: message(for: error), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alert, animated: true)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        popUpViewController.willMove(toParent: nil)
        popUpViewController.removeFromParent()
    }
    
    
    
    
}

extension TopViewController: @MainActor PopUpScrollDelegate {
    func scrollPopUpView() {
        self.animateView(direction: -1)
    }
}

