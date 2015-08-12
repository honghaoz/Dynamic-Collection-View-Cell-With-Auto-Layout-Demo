# Dynamic-Collection-View-Cell-With-Auto-Layout-Demo

Demo for Collection View on iOS with auto layout in UICollectionViewCell to create cells with dynamic heights

Works on iOS7 and iOS8

## Updated

For off screen cells, there's a new dynamic collection view which will handle it gracefully. Check it out!
[ZHDynamicCollectionView](https://github.com/honghaoz/ZHDynamicCollectionView)

## Explanation

Cell is created in xib file, can be also created in code.

Cell is a basic cell with a title label and a content label. Title label has 1 line text and content label has multiple lines text.

### Interface builder

There are totally 7 constraints for two labels:

![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/Screenshots/cell.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL1NjcmVlbnNob3RzL2NlbGwucG5nIiwiZXhwaXJlcyI6MTQxMjQ1NTM5NX0%3D--9553b945bbfa038d86f226060b3bdb7fcb1424d1)

For title label, there are top, leading, trailing spacing with superView.
For content label, there are botton, leading, trailing spacing with superView.
And there is a fixed vertical spacing between bottom of title label with top of content label

All of these 7 constraints have 1000 priority

For two labels, set their Content Hugging Priority and Content Compression Resistance Priority same as following pic:

Title label
![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/Screenshots/titleCell.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL1NjcmVlbnNob3RzL3RpdGxlQ2VsbC5wbmciLCJleHBpcmVzIjoxNDEyNDU1NjYwfQ%3D%3D--055be4ca8a998efa8ca3a65b187817c1f6516711)

Content label
![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/Screenshots/contentCell.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL1NjcmVlbnNob3RzL2NvbnRlbnRDZWxsLnBuZyIsImV4cGlyZXMiOjE0MTI0NTU2NzJ9--181cc53d91087c5d51527ee2f4c21acb1b965e17)

### In code

#### UICollectionViewCell

Subclassing this UICollectionViewCell

In `awakeFromNib()`, for iOS7 remember to set

```
self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidth
```

and in `layoutSubviews()`

Set `contentLabel.preferredMaxLayoutWidth` to a prefered value, like `contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets`

You may also need a configure function, make sure in this function, call `self.setNeedsLayout()` and `self.layoutIfNeeded()`

#### View Controller of UICollectionView

In collectionView's view controller, two key delegate methods are `collectionView:layout:sizeForItemAtIndexPath:` and `cellForItemAtIndexPath:`

Since `collectionView:layout:sizeForItemAtIndexPath:` is called before `cellForItemAtIndexPath:`, so we need to initialize a cell and let system use auto layout to calculate height for us. To avoid memeory leak, we use a dictionary to cache the cells that are off screen (not shown on screen)

The dictionary variable is `var offscreenCells = Dictionary<String, UICollectionViewCell>()`

In `collectionView:layout:sizeForItemAtIndexPath:`, first create or retrieve a cell

```
var cell: MyCollectionViewCell? = self.offscreenCells[reuseIdentifier] as? MyCollectionViewCell
if cell == nil {
    cell = NSBundle.mainBundle().loadNibNamed("MyCollectionViewCell", owner: self, options: nil)[0] as? MyCollectionViewCell
    self.offscreenCells[reuseIdentifier] = cell
}
```
Once a cell is initialized, its size is determined by size in xib file, thus, we need configure texts in cell and layoutSubviews, this will let system recalculate the size of cell

```
// Config cell and let system determine size
cell!.configCell(titleData[indexPath.item], content: contentData[indexPath.item], titleFont: fontArray[indexPath.item] as String, contentFont: fontArray[indexPath.item] as String)
// Cell's size is determined in nib file, need to set it's width (in this case), and inside, use this cell's width to set label's preferredMaxLayoutWidth, thus, height can be determined, this size will be returned for real cell initialization
cell!.bounds = CGRectMake(0, 0, targetWidth, cell!.bounds.height)
cell!.contentView.bounds = cell!.bounds
        
// Layout subviews, this will let labels on this cell to set preferredMaxLayoutWidth
cell!.setNeedsLayout()
cell!.layoutIfNeeded()
```

Once cell is updated, call `var size = cell!.contentView.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)` to get the size for this cell.

In `cellForItemAtIndexPath:`, cell also need configured and layout its subviews


## Screen shots
![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/iOS%20Simulator%20Screen%20Shot1.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL2lPUyBTaW11bGF0b3IgU2NyZWVuIFNob3QxLnBuZyIsImV4cGlyZXMiOjE0MTI0NTQ1NTR9--22eb7f8d1e6f45646ad1e043034f0603ca1329ba)


![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/iOS%20Simulator%20Screen%20Shot2.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL2lPUyBTaW11bGF0b3IgU2NyZWVuIFNob3QyLnBuZyIsImV4cGlyZXMiOjE0MTI0NTQ2MDl9--438f993f9a552dba2ceddb1836005d7b464d9ccf)

## The MIT License (MIT)

Copyright (c) 2014 Honghao Zhang

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/honghaoz/dynamic-collection-view-cell-with-auto-layout-demo/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

