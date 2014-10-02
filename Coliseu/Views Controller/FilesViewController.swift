//
//  FileViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class FilesViewController: UIViewController
{
    private let cellIdentifier = "Cell"

    var files: [AudioFile]?
    var player: AudioPlayer?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Register cell
        let cellNib = UINib(nibName: "FilesViewCell", bundle: nil)
        tableView.registerNib(cellNib!, forCellReuseIdentifier: cellIdentifier)
        // Without Nib
        //tableView.registerClass(FilesViewCell.self, forCellReuseIdentifier: cellIdentifier)

        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self

        // Configure
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension

        // ?
        player!.audioList = files
    }


    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }
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

extension FilesViewController: TableViewProtocol
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
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as FilesViewCell? {
                let audioFile = filesList[indexPath.row]
                cellRow = cell.configure(audioFile.title, audioFile.fileName)
            }
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        if player == nil {
            return
        }
        player!.playAudio(indexPath.row);
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}