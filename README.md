# WaterProgressBar

How to use
## Getting Start

Just Drage and drop file WaterProgressView.swift to your project 
Add a uiview to your storyboard or xib or by code 
Add WaterProgressView as its class name 
Change properties in project utility area 

Make a instance 

```swift
 @IBOutlet weak var progressBar: WaterProgressView!
 ```
 set progress to progress bar the vale should be between 0 and 1 

say 0.5 means 50%

```swift
progressBar.progressValue(value: 0.4)
 ```

