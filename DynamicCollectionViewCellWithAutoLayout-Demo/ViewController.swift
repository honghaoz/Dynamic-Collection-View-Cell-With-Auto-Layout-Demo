//
//  ViewController.swift
//  DynamicCollectionViewCellWithAutoLayout-Demo
//
//  Created by Honghao Zhang on 2014-09-25.
//  Copyright (c) 2014 HonghaoZ. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    
    let kCellIdentifier = "MyCell"
    
    let kHorizontalInsets: CGFloat = 10.0
    let kVerticalInsets: CGFloat = 10.0
    
    var exampleTitle: NSString = "Steve Jobs, BMW & eBay"
    
    var exampleContent: NSString = "And you know what? He’s right.\nThe world doesn’t need another Dell or HP.  It doesn’t need another manufacturer of plain, beige, boring PCs.  If that’s all we’re going to do, then we should really pack up now.\nBut we’re lucky, because Apple has a purpose.  Unlike anyone in the industry, people want us to make products that they love.  In fact, more than love.  Our job is to make products that people lust for.  That’s what Apple is meant to be.\nWhat’s BMW’s market share of the auto market?  Does anyone know?  Well, it’s less than 2%, but no one cares.  Why?  Because either you drive a BMW or you stare at the new one driving by.  If we do our job, we’ll make products that people lust after, and no one will care about our market share.\nApple is a start-up.  Granted, it’s a startup with $6B in revenue, but that can and will go in an instant.  If you are here for a cushy 9-to-5 job, then that’s OK, but you should go.  We’re going to make sure everyone has stock options, and that they are oriented towards the long term.  If you need a big salary and bonus, then that’s OK, but you should go.  This isn’t going to be that place.  There are plenty of companies like that in the Valley.  This is going to be hard work, possibly the hardest you’ve ever done.  But if we do it right, it’s going to be worth it.\n"
    
    var numberOfSections = 1
    var numberOfCells = 3
    var titleData = [NSString]()
    var contentData = [NSString]()
    var fontArray = UIFont.familyNames()

    // A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen. The dictionary is in the format:
    // { NSString *reuseIdentifier : UICollectionViewCell *offscreenCell, ... }
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cells
        collectionView.dataSource = self
        collectionView.delegate = self
        var myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.registerNib(myCellNib, forCellWithReuseIdentifier: kCellIdentifier)
        
        for i in 0..<3 {
            self.addNewOne()
        }
    }
    
    func addNewOne() {
        var randomNumber1 = Int(arc4random_uniform(UInt32(exampleContent.length)))
        var randomNumber2 = Int(arc4random_uniform(UInt32(exampleContent.length)))
        var text = exampleContent.substringWithRange(NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2)))
        contentData.append(text)
        
        randomNumber1 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        randomNumber2 = Int(arc4random_uniform(UInt32(exampleTitle.length)))
        text = exampleTitle.substringWithRange(NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2)))
        titleData.append(text)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UICollectionViewDataSource
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell: MyCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(kCellIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        cell.configCell(titleData[indexPath.item] as! String, content: contentData[indexPath.item] as! String, titleFont: fontArray[indexPath.item] as! String, contentFont: fontArray[indexPath.item] as! String)
        
        // Make sure layout subviews
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (self.collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        
        // Use fake cell to calculate height
        let reuseIdentifier = kCellIdentifier
        var cell: MyCollectionViewCell? = self.offscreenCells[reuseIdentifier] as? MyCollectionViewCell
        if cell == nil {
            cell = NSBundle.mainBundle().loadNibNamed("MyCollectionViewCell", owner: self, options: nil)[0] as? MyCollectionViewCell
            self.offscreenCells[reuseIdentifier] = cell
        }
        
        // Config cell and let system determine size
        cell!.configCell(titleData[indexPath.item] as! String, content: contentData[indexPath.item] as! String, titleFont: fontArray[indexPath.item] as! String, contentFont: fontArray[indexPath.item] as! String)
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRectMake(0, 0, targetWidth, cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.setNeedsLayout()
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(kVerticalInsets, kHorizontalInsets, kVerticalInsets, kHorizontalInsets)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kHorizontalInsets
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return kVerticalInsets
    }
    
    func shuffle<T>(var list: Array<T>) -> Array<T> {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.removeAtIndex(j), atIndex: i)
        }
        return list
    }
    
    @IBAction func add(sender: AnyObject) {
        addNewOne()
        self.shuffle(fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    @IBAction func deleteOne(sender: AnyObject) {
        if titleData.count > 0 { titleData.removeLast() }
        if contentData.count > 0 { contentData.removeLast() }
        self.shuffle(fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Rotation
    // iOS7
    override func willRotateToInterfaceOrientation(toInterfaceOrientation: UIInterfaceOrientation, duration: NSTimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // iOS8
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

