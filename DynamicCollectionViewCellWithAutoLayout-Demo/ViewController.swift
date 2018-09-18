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
    
    var exampleTitle: String = "Steve Jobs, BMW & eBay"
    
    var exampleContent: String = "And you know what? He’s right.\nThe world doesn’t need another Dell or HP.  It doesn’t need another manufacturer of plain, beige, boring PCs.  If that’s all we’re going to do, then we should really pack up now.\nBut we’re lucky, because Apple has a purpose.  Unlike anyone in the industry, people want us to make products that they love.  In fact, more than love.  Our job is to make products that people lust for.  That’s what Apple is meant to be.\nWhat’s BMW’s market share of the auto market?  Does anyone know?  Well, it’s less than 2%, but no one cares.  Why?  Because either you drive a BMW or you stare at the new one driving by.  If we do our job, we’ll make products that people lust after, and no one will care about our market share.\nApple is a start-up.  Granted, it’s a startup with $6B in revenue, but that can and will go in an instant.  If you are here for a cushy 9-to-5 job, then that’s OK, but you should go.  We’re going to make sure everyone has stock options, and that they are oriented towards the long term.  If you need a big salary and bonus, then that’s OK, but you should go.  This isn’t going to be that place.  There are plenty of companies like that in the Valley.  This is going to be hard work, possibly the hardest you’ve ever done.  But if we do it right, it’s going to be worth it.\n"
    
    var numberOfSections = 1
    var numberOfCells = 3
    var titleData = [String]()
    var contentData = [String]()
    var fontArray = UIFont.familyNames

    // A dictionary of offscreen cells that are used within the sizeForItemAtIndexPath method to handle the size calculations. These are never drawn onscreen. The dictionary is in the format:
    // { NSString *reuseIdentifier : UICollectionViewCell *offscreenCell, ... }
    var offscreenCells = Dictionary<String, UICollectionViewCell>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cells
        collectionView.dataSource = self
        collectionView.delegate = self
        let myCellNib = UINib(nibName: "MyCollectionViewCell", bundle: nil)
        collectionView.register(myCellNib, forCellWithReuseIdentifier: kCellIdentifier)
        
        for _ in 0..<3 {
            self.addNewOne()
        }
    }
    
    func addNewOne() {
        var randomNumber1 = Int(arc4random_uniform(UInt32(exampleContent.count)))
        var randomNumber2 = Int(arc4random_uniform(UInt32(exampleContent.count)))
        let range1 = NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2))
        var text = (exampleContent as NSString).substring(with: range1)
        contentData.append(text)
        
        randomNumber1 = Int(arc4random_uniform(UInt32(exampleTitle.count)))
        randomNumber2 = Int(arc4random_uniform(UInt32(exampleTitle.count)))
        let range2 = NSRange(location: min(randomNumber1, randomNumber2), length: abs(randomNumber1 - randomNumber2))
        text = (exampleTitle as NSString).substring(with: range2)
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: MyCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: kCellIdentifier, for: indexPath) as! MyCollectionViewCell
        
        cell.configCell(title: titleData[indexPath.item], content: contentData[indexPath.item], titleFont: fontArray[indexPath.item], contentFont: fontArray[indexPath.item])
        
        // Make sure layout subviews
        cell.layoutIfNeeded()
        return cell
    }
    
    // MARK: - UICollectionViewFlowLayout Delegate
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // Set up desired width
        let targetWidth: CGFloat = (self.collectionView.bounds.width - 3 * kHorizontalInsets) / 2
        
        // Use fake cell to calculate height
        let reuseIdentifier = kCellIdentifier
        var cell: MyCollectionViewCell? = self.offscreenCells[reuseIdentifier] as? MyCollectionViewCell
        if cell == nil {
            if let cells = Bundle.main.loadNibNamed("MyCollectionViewCell", owner: self, options: nil), let c = cells[0] as? MyCollectionViewCell {
                cell = c
                self.offscreenCells[reuseIdentifier] = c
            }
        }
        
        // Config cell and let system determine size
        cell!.configCell(title: titleData[indexPath.item], content: contentData[indexPath.item], titleFont: fontArray[indexPath.item], contentFont: fontArray[indexPath.item])
        
        // Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
        cell!.bounds = CGRect(x: 0, y: 0, width: targetWidth, height: cell!.bounds.height)
        cell!.contentView.bounds = cell!.bounds
        
        // Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
        cell!.setNeedsLayout()
        cell!.layoutIfNeeded()
        
        var size = cell!.contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        // Still need to force the width, since width can be smalled due to break mode of labels
        size.width = targetWidth
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: kVerticalInsets, left: kHorizontalInsets, bottom: kVerticalInsets, right: kHorizontalInsets)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kHorizontalInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return kVerticalInsets
    }

    @discardableResult
    func shuffle<T>( _ list: inout Array<T>) -> Array<T> {
        for i in 0..<list.count {
            let j = Int(arc4random_uniform(UInt32(list.count - i))) + i
            list.insert(list.remove(at: j), at: i)
        }
        return list
    }
    
    // Adds a new cell
    @IBAction func add(_ sender: AnyObject) {
        addNewOne()
        self.shuffle(&fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    // Deletes a cell
    @IBAction func deleteOne(_ sender: AnyObject) {
        if titleData.count > 0 { titleData.removeLast() }
        if contentData.count > 0 { contentData.removeLast() }
        self.shuffle(&fontArray)
        collectionView.reloadData()
        collectionView.collectionViewLayout.invalidateLayout()
    }
    
    // MARK: - Rotation
    // iOS7
    override func willRotate(to toInterfaceOrientation: UIInterfaceOrientation, duration: TimeInterval) {
        collectionView.collectionViewLayout.invalidateLayout()
        }
    
    // iOS8
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

