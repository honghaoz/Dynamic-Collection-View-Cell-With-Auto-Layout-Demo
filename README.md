# Dynamic-Collection-View-Cell-With-Auto-Layout-Demo

Demo for Collection View on iOS with auto layout in UICollectionViewCell to create cells with dynamic heights

Works on iOS7 and iOS8

## Explanation

Cell is created in xib file, can be also created in code.

Cell is a basic cell with a title label and a content label. Title label has 1 line text and content label has multiple lines text.

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

Subclassing this UICollectionViewCell

In `awakeFromNib()`, for iOS7 remember to set

```
self.contentView.autoresizingMask = UIViewAutoresizing.FlexibleHeight | UIViewAutoresizing.FlexibleWidt
```

and in `layoutSubviews()`

add `contentLabel.preferredMaxLayoutWidth = self.bounds.width - 2 * kLabelHorizontalInsets`



## Screen shots
![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/iOS%20Simulator%20Screen%20Shot1.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL2lPUyBTaW11bGF0b3IgU2NyZWVuIFNob3QxLnBuZyIsImV4cGlyZXMiOjE0MTI0NTQ1NTR9--22eb7f8d1e6f45646ad1e043034f0603ca1329ba)


![](https://raw.githubusercontent.com/honghaoz/Dynamic-Collection-View-Cell-With-Auto-Layout-Demo/master/iOS%20Simulator%20Screen%20Shot2.png?token=3926785__eyJzY29wZSI6IlJhd0Jsb2I6aG9uZ2hhb3ovRHluYW1pYy1Db2xsZWN0aW9uLVZpZXctQ2VsbC1XaXRoLUF1dG8tTGF5b3V0LURlbW8vbWFzdGVyL2lPUyBTaW11bGF0b3IgU2NyZWVuIFNob3QyLnBuZyIsImV4cGlyZXMiOjE0MTI0NTQ2MDl9--438f993f9a552dba2ceddb1836005d7b464d9ccf)
