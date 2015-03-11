//
//  ViewController.swift
//  MyMenu
//
//  Created by Massimo Moro on 23/02/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func openCreaMenu(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("CreaMenu") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }

    @IBAction func gestisciMenu(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewControllerWithIdentifier("GestisciMenu") as UIViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
}

