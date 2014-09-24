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

class FilesViewController: UIViewController {

    var files: [NSURL]?

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        // Set delegate and datasource
        tableView.delegate = self
        tableView.dataSource = self
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = false
        }
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        // Navigation bar
        if let navigation = navigationController {
            navigation.navigationBarHidden = true
        }
    }

}

// MARK: - TableViewProtocol

extension FilesViewController: TableViewProtocol
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        if let filesList = files
        {
            return filesList.count
        }
        else
        {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cellRow = UITableViewCell()

        if let filesList = files
        {
            if let cell = tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell? {
                if let label = cell.textLabel {
                    label.text = filesList[indexPath.row].absoluteString!
                    cellRow = cell
                }
            }
        }
        return cellRow
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {

    }
}