//
//  CreaMenu.swift
//  MyMenu
//
//  Created by Massimo Moro on 20/02/15.
//  Copyright (c) 2015 MassimoMoro. All rights reserved.
//

import UIKit
import MessageUI

class CreaMenu: UIViewController, UITableViewDataSource, UITableViewDelegate, UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate {

    let sectionMenu = ["ANTIPASTI", "PRIMI PIATTI", "SECONDI PIATTI", "DESSERT"]
    var currentCell : UITableViewCell?
    var rowInPicker = 0
    var noteObjects: NSMutableArray! = NSMutableArray()
    var pickerDataSource = []
    var menuData: [[String]] = [["","","","","",""],["","","","","",""],["","","","","",""],["","","","","",""]]
    var currentIndexPath: NSIndexPath?
    let parseReachable = ReachParse()
    let tapGestureForView : UIGestureRecognizer?
    let idCaNogheraInParseMenuTable = "k5xjqXyLe7"
    
    @IBOutlet weak var pickerTesto: UIPickerView!
    @IBOutlet weak var antipastiTableView: UITableView!
    @IBOutlet weak var dataInizio: UIDatePicker!
    @IBOutlet weak var dataFine: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action:Selector("pickerTap"))
        
        tapGesture.delegate = self
        
        tapGesture.numberOfTapsRequired = 2
        pickerTesto.addGestureRecognizer(tapGesture)
        
        self.antipastiTableView.registerClass(MenuCell.self, forCellReuseIdentifier: "cell")
        
        //DatePicker
        dataInizio.addTarget(self, action: Selector("datePickerChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        parseReachable.monitorReachability()
        dataInizio.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        dataFine.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.6)
        antipastiTableView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
    }
    
    override func viewDidAppear(animated: Bool) {

            
            self.fetchAllObjectsFromLocalDatastore()
            self.fetchAllObjects()
  
    }
    
    func fetchAllObjects() {
        println(self.self.noteObjects.count)
       // if (parseReachable.isParseReachable() && (self.noteObjects.count == 0)) {
          //  PFObject.unpinAllObjectsInBackgroundWithBlock(nil)
            
            var query: PFQuery = PFQuery(className: "ListMenu")
            
            
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
        
        query.fromLocalDatastore()
        
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            
            if (error == nil) {
                
                var temp: NSArray = objects as NSArray
                
                self.noteObjects = temp.mutableCopy() as NSMutableArray
                self.antipastiTableView.reloadData()
           
                
            }else {
                
                println(error.userInfo)
                
            }
            
        }
        
    }
    
    func datePickerChanged(datePicker:UIDatePicker) {
        var myData = dataInizio.date
        myData = myData.dateByAddingTimeInterval(7*24*60*60)
        dataFine.date = myData
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    
    @IBAction func closeView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    //tableView delegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3;
    }

    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = self.antipastiTableView.dequeueReusableCellWithIdentifier("MenuCell") as MenuCell
        
       
        cell.nome?.text = menuData[indexPath.section][indexPath.row * 2]
        cell.prezzo?.text = menuData[indexPath.section][indexPath.row * 2 + 1]
        
        return cell
      
    }
    
    //Section
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionMenu.count
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var fontLabel = sectionMenu[section]
        
        return sectionMenu[section]
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let tapGestureForView2 = UITapGestureRecognizer(target: self, action: Selector("hidePicker:"))
      
        self.view.addGestureRecognizer(tapGestureForView2)
        pickerTesto.selectRow(0, inComponent: 0, animated: false)
        rowInPicker = 0
        pickerTesto.hidden = false
        currentCell = tableView.cellForRowAtIndexPath(indexPath)
        var cell = self.antipastiTableView.cellForRowAtIndexPath(indexPath)!
        
        var helper : CGPoint = cell.convertPoint(view.frame.origin, toView: nil)
        var convertedTextFieldLowerPoint: CGPoint = view.convertPoint(cell.center, toView: nil)
        currentIndexPath = indexPath
        
        var categoryPredicate = NSPredicate(format: "Categoria = %d", indexPath.section)
        pickerDataSource = self.noteObjects.filteredArrayUsingPredicate(categoryPredicate!) as NSArray
        pickerTesto.reloadAllComponents()
   
        UIView.animateWithDuration(0.2, animations:  {
            self.pickerTesto.center = CGPointMake(convertedTextFieldLowerPoint.x, helper.y + cell.frame.size.height/2)
            println(self.pickerTesto.frame)
        })
       
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let myLabel = UILabel()
        myLabel.frame = CGRectMake(0, 2, tableView.frame.size.width, 28)
        myLabel.font = UIFont(name: "Georgia-Bold", size: 22)
        myLabel.textAlignment = NSTextAlignment.Center;
        let text = NSMutableAttributedString(string: self.tableView(antipastiTableView, titleForHeaderInSection: section)!)
        text.addAttribute(NSUnderlineStyleAttributeName, value: NSUnderlineStyle.StyleSingle.rawValue, range: NSMakeRange(0, text.length))
        myLabel.attributedText = text
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        
        return headerView
    }
    
    
    
    //pickerView
    

    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerDataSource.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        var object: PFObject = pickerDataSource.objectAtIndex(row ) as PFObject
        return object["Nome"] as? String
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
   
        rowInPicker = row
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var object: PFObject = pickerDataSource.objectAtIndex(row ) as PFObject
        return NSAttributedString(string: object["Nome"] as String, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    func pickerTap() {
        pickerTesto.hidden = true
         var object: PFObject = pickerDataSource.objectAtIndex(rowInPicker) as PFObject
        var currentRow = currentIndexPath!.row
        menuData[currentIndexPath!.section][currentRow * 2] = object["Nome"] as String
        menuData[currentIndexPath!.section][(currentRow * 2) + 1] = object["Price"] as String
        antipastiTableView.reloadData()
       // currentCell?.textLabel?.text = object["Nome"] as? String
    }
    
    func hidePicker(tap: UIGestureRecognizer) {
        pickerTesto.hidden = true
        self.view.removeGestureRecognizer(tap)
    }
    @IBAction func uploadData(sender: AnyObject) {
       
//        var query = PFQuery(className:"Menu")
//        query.getObjectInBackgroundWithId("25WSnGlEDW") {
//            (menu: PFObject!, error: NSError!) -> Void in
//            if error != nil {
//                NSLog("%@", error)
//                
//            } else {
//                
//                menu["StartDate"] = self.dataInizio.date
//                menu["EndDate"] = self.dataFine.date
//                menu["Starters"] = self.menuData[0]
//                menu["FirstCourse"] = self.menuData[1]
//                menu["SecondCourse"] = self.menuData[2]
//                menu["Dessert"] = self.menuData[3]
//               
//                menu.saveInBackgroundWithBlock(nil)
//            }
//        }
        sendMail()
       
    }
    func sendMail () {
        if (MFMailComposeViewController.canSendMail()) {
            
            let dateFormatter = NSDateFormatter()//3
            
            var theDateFormat = NSDateFormatterStyle.ShortStyle //5
            
            dateFormatter.dateStyle = theDateFormat//8
            
            var emailTitle = "Menu dal " + dateFormatter.stringFromDate(dataInizio.date) + " al " + dateFormatter.stringFromDate(dataFine.date)
            var messageBody = writeMenu()
            var toRecipents = ["mmoro@casinovenezia.it"]
            
            var mc:MFMailComposeViewController = MFMailComposeViewController()
            
            mc.mailComposeDelegate = self
            mc.setSubject(emailTitle)
            
            mc.setMessageBody(messageBody, isHTML: false)
            
            mc.setToRecipients(toRecipents)
            
            
            self.presentViewController(mc, animated: true, completion: nil)
            
        }else {
            
            println("No email account found")
            
        }
    }
    
    func writeMenu() -> String {
        var str = ""
        for (index, value) in enumerate(menuData) {
            str = str + sectionMenu[index] + "\n\n"
            for (index, valueNew) in enumerate(value) {
                if (index % 2 == 0) {
                    str = str + valueNew + "   "
                } else {
                    str = str + valueNew + "\n"
                }
                if (index == value.count - 1) {
                    str = str + "\n"
                }
                
                
            }
        }
        return str
    }
    
    func mailComposeController(controller: MFMailComposeViewController!, didFinishWithResult result: MFMailComposeResult, error: NSError!) {
        
        switch result.value {
            
        case MFMailComposeResultCancelled.value:
            println("Mail Cancelled")
        case MFMailComposeResultSaved.value:
            println("Mail Saved")
        case MFMailComposeResultSent.value:
            println("Mail Sent")
        case MFMailComposeResultFailed.value:
            println("Mail Failed")
        default:
            break
            
        }
        
        self.dismissViewControllerAnimated(false, completion: nil)
        
    }
}
