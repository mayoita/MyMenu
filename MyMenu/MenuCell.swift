//
//  MenuCell.swift
//  MyMenu
//
//  Created by Massimo Moro on 25/02/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

import UIKit
protocol EraseCell {
    func eraseAtIndex(indice : NSIndexPath)
}

class MenuCell: UITableViewCell {

    @IBOutlet weak var prezzo: UILabel!
    @IBOutlet weak var nome: UILabel!
    var indice:NSIndexPath!
    var delegateForErase:EraseCell?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let panGesture = UISwipeGestureRecognizer(target: self, action:Selector("handlePan"))
        panGesture.direction = UISwipeGestureRecognizerDirection.Left
        self.addGestureRecognizer(panGesture)
    }
    
    func handlePan () {
        
        nome.text = ""
        prezzo.text = ""
        delegateForErase?.eraseAtIndex(indice)
    }
    
}
