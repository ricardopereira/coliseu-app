//
//  FileViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 23/09/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

protocol TableViewProtocol: UITableViewDelegate, UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
}

class FilesViewController: UIViewController
{
    private let cellIdentifier = "Cell"

    var files: [NSURL]?

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

        if let filesList = files{
            if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as FilesViewCell? {
                cellRow = cell.configure("MP3 - " + indexPath.item.description, filesList[indexPath.row].absoluteString!)
            }
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    //func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat

    //func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
}