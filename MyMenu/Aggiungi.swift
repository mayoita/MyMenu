//
//  Aggiungi.swift
//  MyMenu
//
//  Created by Massimo Moro on 10/03/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

import UIKit
protocol aggiornaArrayDelegate {
    func aggiungiPiatto (nome:NSString, prezzo:NSString)
}

class Aggiungi: UIViewController,AKMaskFieldDelegate, UITextFieldDelegate {
  
    var delegate:aggiornaArrayDelegate! = nil

   @IBOutlet var indicators: [UIView]!
    @IBOutlet weak var ilNome: UITextField!
    @IBOutlet weak var ilPrezzo: AKMaskField!
    override func viewDidLoad() {
        super.viewDidLoad()
      
        self.ilPrezzo.events = self
        // Draw indicators
        for indicator in indicators {
            indicator.layer.cornerRadius    = 10
        }
    }

    // Hide on click out the field
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.ilPrezzo.resignFirstResponder()
       self.ilNome.resignFirstResponder()
        self.view.endEditing(true)
    }
    
    func maskField(maskField: AKMaskField, madeEvent: String, withText oldText: String, inRange oldTextRange: NSRange, withText newText: String) {
        
        // Status animation
        var statusColor: UIColor?
        switch maskField.maskStatus {
        case "Clear":
            statusColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        case "Incomplete":
            statusColor = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        case "Complete":
            statusColor = UIColor(red: 0/255, green: 219/255, blue: 86/255, alpha: 1.0)
        default:
            statusColor = UIColor.clearColor()
        }
        UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.indicators[maskField.tag].backgroundColor = statusColor
            
            }, completion: nil)
        
        // Event animation
        var eventColor: UIColor?
        switch madeEvent {
        case "Insert":
            eventColor = UIColor(red: 241/255, green: 241/255, blue: 241/255, alpha: 1.0)
        case "Replace":
            eventColor = UIColor(red: 140/255, green: 190/255, blue: 178/255, alpha: 0.5)
        case "Delete":
            eventColor = UIColor(red: 243/255, green: 181/255, blue: 98/255, alpha: 0.5)
        default:
            eventColor = UIColor(red: 231/255, green: 76/255, blue: 60/255, alpha: 0.5)
        }
        
        UIView.animateWithDuration(0.05, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            maskField.backgroundColor = eventColor
            
            }) { (Bool) -> Void in
                
                UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    maskField.backgroundColor = UIColor.clearColor()
                    
                    }, completion: nil)
        }
    }


    @IBAction func chiudi(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func aggiungi(sender: AnyObject) {
        if ilNome.text.isEmpty {
            let alertController = UIAlertController(title: "NOME", message:
                "Il nome non può essere vuoto !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "CHIUDI", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        if ilPrezzo.text.isEmpty {
            let alertController = UIAlertController(title: "PREZZO", message:
                "Il prezzo non può essere vuoto !", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "CHIUDI", style: UIAlertActionStyle.Default,handler: nil))
            
            self.presentViewController(alertController, animated: true, completion: nil)
            return
        }
        
        
        self.dismissViewControllerAnimated(true, completion: {
            
             self.delegate!.aggiungiPiatto(self.ilNome.text, prezzo: self.ilPrezzo.text)
        })
       

    }
}
