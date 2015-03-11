//
//  GestisciMenu.swift
//  MyMenu
//
//  Created by Massimo Moro on 06/03/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

import UIKit



class GestisciMenu: UIViewController,UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UIPopoverPresentationControllerDelegate, aggiornaArrayDelegate {
    
    var noteObjects: NSMutableArray! = NSMutableArray()
    var searchingDataArray:NSMutableArray!
    var is_searching:Bool!   // It's flag for searching
    var categoria:Int = 0
    var saved:Bool = false
    var added:Bool = false
    var loaded:Bool = false
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    func aggiungiPiatto (nome:NSString, prezzo:NSString) {
        var piatto = PFObject(className: "ListMenu")
        piatto["Categoria"]=categoria
        piatto["Nome"]=nome
        piatto["Price"]="€ " + prezzo
        piatto["Sede"]="CN"
        
        noteObjects.insertObject(piatto, atIndex: 0)
        searchBar(mySearchBar, selectedScopeButtonIndexDidChange: categoria)
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        is_searching = false
        searchingDataArray = []
        
      
    }
    
    override func viewDidAppear(animated: Bool) {
        
        
        self.fetchAllObjectsFromLocalDatastore()
       // self.fetchAllObjects()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.mySearchBar.resignFirstResponder()
        self.view.endEditing(true)
    }
    //SearchBar
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String){
        if searchBar.text.isEmpty{
            is_searching = false
            self.tableView.reloadData()
        } else {

            is_searching = true
            searchingDataArray.removeAllObjects()
            for var index = 0; index < noteObjects.count; index++
            {
                var currentString = noteObjects.objectAtIndex(index)["Nome"] as String
                if currentString.lowercaseString.rangeOfString(searchText.lowercaseString)  != nil {
                    searchingDataArray.addObject(noteObjects.objectAtIndex(index))
                    
                }
            }
            tableView.reloadData()
        }
    }
    func searchBar(searchBar: UISearchBar,
        selectedScopeButtonIndexDidChange selectedScope: Int) {
            categoria=selectedScope
            filtraArrayPerCategoria(selectedScope)
            tableView.reloadData()
    
    }
    
    func filtraArrayPerCategoria (selectedScope : Int) {
        is_searching = true
        searchingDataArray.removeAllObjects()
        for var index = 0; index < noteObjects.count; index++
        {
            
            if noteObjects.objectAtIndex(index)["Categoria"] as Int  == selectedScope {
                searchingDataArray.addObject(noteObjects.objectAtIndex(index))
                
            }
        }
       
    }
    

    
    func fetchAllObjects() {
    
        // if (parseReachable.isParseReachable() && (self.noteObjects.count == 0)) {
        //  PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
        
        var query: PFQuery = PFQuery(className: "ListMenu")
        query.orderByAscending("Nome")
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil) {
                
                PFObject.pinAllInBackground(objects, block: nil)
                
                self.fetchAllObjectsFromLocalDatastore()
                
                
            }else {
                
                
                println(error.userInfo)
                
            }
            
        }
        // }
    }
    
    func fetchAllObjectsFromLocalDatastore() {
        
        var query: PFQuery = PFQuery(className: "ListMenu")
         query.orderByAscending("Nome")
      //  query.fromLocalDatastore()
        
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil) {
                self.loaded = true
                var temp: NSArray = objects as NSArray
                
                self.noteObjects = temp.mutableCopy() as NSMutableArray
                self.filtraArrayPerCategoria(0)
                self.tableView.reloadData()
                
                
            }else {
                
                println(error.userInfo)
                
            }
            
        }
        
    }
    
    //tableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if is_searching == true{
            return searchingDataArray.count
        }else{
            return noteObjects.count  //Currently Giving default Value
        }
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("gestisciCell") as MenuCell
        
        if is_searching == true{
            cell.nome?.text = searchingDataArray[indexPath.row]["Nome"] as? String
            cell.prezzo?.text = searchingDataArray[indexPath.row]["Price"] as? String
        }else{
            cell.nome?.text = noteObjects[indexPath.row]["Nome"] as? String
            cell.prezzo?.text = noteObjects[indexPath.row]["Price"] as? String
        }
        
        
        
        return cell
        
    }

    @IBAction func closeView(sender: AnyObject) {
    
        if !saved && added {
            let alertController = UIAlertController(title: "ATTENZIONE", message: "IL LAVORO NON È STATO SALVATO. SALVARLO ORA?", preferredStyle: .Alert)
            
            let cancelAction = UIAlertAction(title: "NO", style: .Cancel) { (action) in
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(cancelAction)
            
            let OKAction = UIAlertAction(title: "SI", style: .Default) { (action) in
                self.uploadData(self)
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            alertController.addAction(OKAction)
            
            self.presentViewController(alertController, animated: true) {
                // ...
            }
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    
    @IBAction func aggiungi(sender: AnyObject) {
        if loaded {
        added = true
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        let vc = storyboard.instantiateViewControllerWithIdentifier("AggiungiPiatto") as Aggiungi
        vc.delegate = self
      
        if NSProcessInfo().isOperatingSystemAtLeastVersion(NSOperatingSystemVersion(majorVersion: 8, minorVersion: 0, patchVersion: 0))
        {
            self.providesPresentationContextTransitionStyle = true;
            self.definesPresentationContext = true;
            vc.view.backgroundColor = UIColor.clearColor()
            vc.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext
        } else {
            self.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        }

         //vc.view.backgroundColor = UIColor.clearColor()

       // vc.view.backgroundColor = UIColor.clearColor()
        self.presentViewController(vc, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "ATTENDI", message:
                "Attendi.I dati non sono ancora stati scaricati...", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
             self.presentViewController(alertController, animated: true, completion: nil)
        }
        
    }
    @IBAction func uploadData(sender: AnyObject) {
        if loaded {
        saved = true
        var object: PFObject
        for object  in noteObjects {
            object.saveInBackgroundWithBlock(nil)
        }
        } else {
            let alertController = UIAlertController(title: "ATTENDI", message:
                "Attendi.I dari non sono ancora stati scaricati...", preferredStyle: UIAlertControllerStyle.Alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default,handler: nil))
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }

}
