//
//  UIBaseViewController.swift
//  Coliseu
//
//  Created by Ricardo Pereira on 02/10/2014.
//  Copyright (c) 2014 Ricardo Pereira. All rights reserved.
//

import UIKit

class UIBaseViewController: UIViewController
{
    unowned let appCtrl: AppController

    required init(nibName nibNameOrNil: String?, appCtrl: AppController)
    {
        self.appCtrl = appCtrl
        super.init(nibName: nibNameOrNil, bundle: nil)
    }

    required init(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}