# WaterProgressBar
very easy and readable class 

![ezgif com-gif-maker](https://user-images.githubusercontent.com/17967553/153465459-9681d046-e51b-44e0-956b-dbda699e50ee.gif)


How to use  
## Getting Start

#### Just Drage and drop file WaterProgressView.swift to your project 

<img width="500" alt="Screenshot 2022-02-10 at 10 39 23 PM" src="https://user-images.githubusercontent.com/17967553/153464596-c381f43d-91a8-4a00-8c15-4e6c582023cb.png">



#### Add a uiview to your storyboard or xib or by code  and make  WaterProgressView as its class name 

<img width="500" alt="Screenshot 2022-02-10 at 10 39 51 PM" src="https://user-images.githubusercontent.com/17967553/153464729-c1d26121-a07a-4a3e-b96d-1d50b3268211.png">



#### Change properties in project utility area 


<img width="500" alt="Screenshot 2022-02-10 at 11 05 53 PM" src="https://user-images.githubusercontent.com/17967553/153464764-6add79a5-99db-416d-acf4-2950f1b43158.png">


Make a instance 

```swift
 @IBOutlet weak var progressBar: WaterProgressView!
 ```
 set progress to progress bar the vale should be between 0 and 1 

say 0.5 means 50%

```swift
progressBar.progressValue(value: 0.4)
 ```
Tips:
- Download the Repo and run the sample project
- Read classes for better understanding how to use 


