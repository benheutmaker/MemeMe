//
//  MemeViewerControllerViewController.swift
//  MemeMe
//
//  Created by Benji on 4/15/15.
//  Copyright (c) 2015 Ben Heutmaker. All rights reserved.
//

import UIKit

class MemeViewerControllerViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet var scrollView: UIScrollView!
    
    var pageViews: [UIImageView?] = []
    
    var pageImages: [Meme] = []
    
    var currentMeme: Meme!
    
    var startingViewIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.delegate = self
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .Edit, target: self, action: "editMeme")
        self.navigationItem.rightBarButtonItem = editButton
        
        let applicationDelegate = (UIApplication.sharedApplication().delegate as! AppDelegate)
        self.pageImages = applicationDelegate.memes
        
        let pageCount = pageImages.count
        
        for _ in 0..<pageCount {
            pageViews.append(nil)
        }
        
        scrollView.frame.size.width = self.view.frame.width + 1
        let pagesScrollViewSize = scrollView.frame.size
        scrollView.contentSize = CGSize(width: self.view.frame.width * CGFloat(pageImages.count), height: pagesScrollViewSize.height)
        
        self.scrollView.setContentOffset(CGPoint(x: (scrollView.frame.size.width * CGFloat(startingViewIndex)), y: 0), animated: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        loadVisiblePages()
    }
    
    func loadPage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // 1
        if let pageView = pageViews[page] {
            // Do nothing. The view is already loaded.
        } else {
            // 2
            var frame = scrollView.bounds
            frame.origin.x = frame.size.width * CGFloat(page)
            frame.origin.y = 0.0
            frame = CGRectInset(frame, 10.0, 0.0)
            
            // 3
            let newPageView = UIImageView(image: pageImages[page].memedImage)
            newPageView.contentMode = .ScaleAspectFit
            newPageView.frame = frame
            scrollView.addSubview(newPageView)
            
            // 4
            pageViews[page] = newPageView
        }
        
        currentMeme = pageImages[page]
    }
    
    func purgePage(page: Int) {
        if page < 0 || page >= pageImages.count {
            // If it's outside the range of what you have to display, then do nothing
            return
        }
        
        // Remove a page from the scroll view and reset the container array
        if let pageView = pageViews[page] {
            pageView.removeFromSuperview()
            pageViews[page] = nil
        }
    }
    
    func loadVisiblePages() {
        // First, determine which page is currently visible
        let pageWidth = scrollView.frame.size.width
        let page = Int(floor((scrollView.contentOffset.x * 2.0 + pageWidth) / (pageWidth * 2.0)))
        
        // Work out which pages you want to load
        let firstPage = page - 1
        let lastPage = page + 1
        
        // Purge anything before the first page
        for var index = 0; index < firstPage; ++index {
            purgePage(index)
        }
        
        // Load pages in our range
        for index in firstPage...lastPage {
            loadPage(index)
        }
        
        // Purge anything after the last page
        for var index = lastPage+1; index < pageImages.count; ++index {
            purgePage(index)
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Load the pages that are now on screen
        loadVisiblePages()
    }
    
    func setStartingView(page: Int) {
        self.startingViewIndex = page
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func editMeme() {
        self.performSegueWithIdentifier("editMeme", sender: self)
    }
    
    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "editMeme" {
            let memeEditorNavVC = segue.destinationViewController as! UINavigationController
            
            let memeEditorVC = memeEditorNavVC.childViewControllers[0] as! MemeEditorViewController
            
            memeEditorVC.setMeme(currentMeme!)
            memeEditorVC.setCancelButton()
            
            memeEditorVC.hidesBottomBarWhenPushed = false
        }
    }

}
