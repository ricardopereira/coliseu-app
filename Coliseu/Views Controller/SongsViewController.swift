//
//  SongsViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class SongsViewController: UIBaseViewController
{
    private let cellSongIdentifier = "CellSong"
    // Files list
    private var files: [AudioFile]!

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Register cell
        let cellNib = UINib(nibName: "SongViewCell", bundle: nil)
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellSongIdentifier)

        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self

        // Configure
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }

        files = appCtrl.data.getLocalFiles()
    }

    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.hidesBarsOnSwipe = true
        }
    }

    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.hidesBarsOnSwipe = false
        }
    }

    override func viewDidDisappear(animated: Bool)
    {
        super.viewDidDisappear(animated)
        // At this instance theres no Navigation bar!
    }
}

// MARK: - TableViewProtocol

extension SongsViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filesList = files {
            return filesList.count
        }
        else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        if let filesList = files {
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellSongIdentifier) as SongViewCell? {
                let audioFile = filesList[indexPath.row]
                cellRow = cell.configure(audioFile.title, audioFile.fileName)
            }
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        appCtrl.player.playSong(indexPath.row, songsList: files)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}