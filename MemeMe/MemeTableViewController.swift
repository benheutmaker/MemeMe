//
//  MemeTableViewController.swift
//  MemeMe
//
//  Created by Benji on 4/8/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController {
    
    var memes: [Meme]?
    
    let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add a '+' button to rightBarButtonItem
        let newMemeButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "newMeme")
        self.navigationItem.rightBarButtonItem = newMemeButton
        
        //Add an 'Edit' Button to leftBarButtonItem
        self.navigationItem.leftBarButtonItem = self.editButtonItem()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.memes = applicationDelegate.memes
        
        self.tableView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
        
        if self.memes?.isEmpty == true {
            if applicationDelegate.shouldShowNewMeme == true {
                newMeme()
                applicationDelegate.shouldShowNewMeme = false
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Instantiate a new Meme
    func newMeme() {
        let memeDetailNavVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNavigationController") as! UINavigationController
        
        let memeDetailVC = memeDetailNavVC.viewControllers.first as! MemeEditorViewController
        memeDetailVC.setCancelButton()
        
        self.presentViewController(memeDetailNavVC, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes!.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell

        let meme = self.memes?[indexPath.row]
        
        cell.imageView?.image = meme?.memedImage
        cell.textLabel?.text = meme?.topText
        cell.detailTextLabel?.text = meme?.bottomText

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let memeDetailVC = self.storyboard?.instantiateViewControllerWithIdentifier("MemeViewerControllerViewController") as! MemeViewerControllerViewController
        
        memeDetailVC.setStartingView(indexPath.row)
        
        memeDetailVC.tabBarController?.hidesBottomBarWhenPushed
        
        self.navigationController?.pushViewController(memeDetailVC, animated: true)
    }
    

    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            self.memes?.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            
            tableView.reloadData()
        }
    }

}
