//
//  UpcomingEventsTableViewController.swift
//  Remindinator
//
//  Created by Pruthvi Parne on 12/5/16.
//  Copyright © 2016 Parne,Pruthivi R. All rights reserved.
//

import UIKit

class UpcomingEventsTableViewController: PFQueryTableViewController {

    var sharedToCurrentUser:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        loadObjects()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        let query = UserEvent.queryForUpcomingEvents()!
        return query
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        var cell:DashboardEventTableViewCell
        
        let event = object as! UserEvent
        self.sharedToCurrentUser = false
        
        event.getSharedContacts()?.forEach({ (user) in
            if PFUser.currentUser()!.objectId == user.objectId {
                self.sharedToCurrentUser = true
                return
            }
        })
        
        cell = tableView.dequeueReusableCellWithIdentifier("pendingCell", forIndexPath: indexPath) as! DashboardEventTableViewCell
        
//        if event.user.objectId?.compare((PFUser.currentUser()?.objectId)!) == .OrderedSame || self.sharedToCurrentUser {
//            cell = tableView.dequeueReusableCellWithIdentifier("UserEventCell", forIndexPath: indexPath) as! DashboardEventTableViewCell
//        } else {
//            cell = tableView.dequeueReusableCellWithIdentifier("PublicEventCell", forIndexPath: indexPath) as! DashboardEventTableViewCell
//        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        if let userImageFile = event.user["image"] as? PFFile {
            userImageFile.getDataInBackgroundWithBlock {
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        cell.userImage.image = UIImage(data:imageData)
                    }
                    print("Successfully fetched image from the Backend.")
                } else {
                    if let error = error {
                        print("Something has gone wrong when getting the userImage from the background: \(error.localizedDescription)")
                    }
                }
            }
        } else {
            let image = UIImage(named: "Gender Neutral User Filled-100")
            let imageData = UIImagePNGRepresentation(image!)
            let imageFile = PFFile(name: event.user.username, data: imageData!)
            
            event.user["image"] = imageFile
            
            event.user.saveInBackground()
            cell.userImage.image = image
        }
        
        cell.eventName.text = event.eventName
        cell.objectId = event.objectId
        cell.eventReminderTime.text = dateFormatter.stringFromDate(event.eventDueDate)
        cell.user = event.user
//        cell.addOrEditButton.tag = indexPath.row
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
