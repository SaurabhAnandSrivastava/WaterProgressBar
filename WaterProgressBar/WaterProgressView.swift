//
//  WaterProgressView.swift
//  Tutorial
//
//  Created by Saurabh Srivastav on 06/02/22.
//
// MARK: - Created by SaS

import UIKit
@IBDesignable
class WaterProgressView: UIView {
    
    // MARK: - Variables
    var BubbleTimer:Timer?
    var isOff = false
    private weak var displayLink: CADisplayLink?
    private weak var displayLink1: CADisplayLink?
    public var progress = CGFloat(1.0)
    public var progressLbl = UILabel()
    private var startTime: CFTimeInterval = 0
    private var defaultTidalHeight: CGFloat = 0.95
    private let saveSpeedFactor = CGFloat.random(in: 4 ... 8)
    private let maxAmplitude: CGFloat = 0.05
    private let maxTidalVariation: CGFloat = 0.1
    private let amplitudeOffset = CGFloat.random(in: -0.5 ... 0.5)
    private let amplitudeChangeSpeedFactor = CGFloat.random(in: 4 ... 8)
    private var subContentView: UIView!
    private var height = 0.0
    private var targetHeight = 0.0
    private var lblColor = UIColor.red
    private var waterColor = UIColor.yellow
    private let shapeLayer: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        shapeLayer.strokeColor = UIColor.yellow.cgColor
        shapeLayer.fillColor = UIColor.yellow.cgColor
        shapeLayer.lineWidth = 0
        
        return shapeLayer
    }()
    private let shapeLayer1: CAShapeLayer = {
        let shapeLayer = CAShapeLayer()
        let color = UIColor.yellow
        let new = color.withAlphaComponent(0.5)
        shapeLayer.strokeColor = new.cgColor
        shapeLayer.fillColor = new.cgColor
        shapeLayer.lineWidth = 0
        return shapeLayer
    }()
    
    // MARK: - Config
    @IBInspectable
    var circular: Bool {
        get {
            return false
        }
        set {
            
            if newValue {
                layer.cornerRadius = bounds.height/2
            }
            else{
                layer.cornerRadius = 0
            }
            
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var borderColor:UIColor {
        
        get {
            
            return .clear
        }
        set {
            
            layer.borderColor = newValue.cgColor
        }
        
    }
    
    
    @IBInspectable var waveColor:UIColor {
        
        get {
            
            return .yellow
        }
        set {
            
            waterColor = newValue
        }
        
    }
    
    
    @IBInspectable var progressLblColor:UIColor {
        
        get {
            
            return .red
        }
        set {
            
            lblColor = newValue
        }
        
    }

    // MARK: - Init Fun
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        
        if newWindow == nil {
            // UIView disappear
            BubbleTimer?.invalidate()
            stopeEqualizer()
        } else {
            shapeLayer.strokeColor = waterColor.cgColor
            shapeLayer.fillColor = waterColor.cgColor
            let color = waterColor
            let new = color.withAlphaComponent(0.5)
            shapeLayer1.strokeColor = new.cgColor
            shapeLayer1.fillColor = new.cgColor
            progressLbl.textColor = lblColor
            
        }
    }
    
    
    func commonInit(){
        
        self.clipsToBounds = true
        
        subContentView = UIView()
        targetHeight = self.bounds.height
        height = targetHeight * (1/100)
        subContentView.frame = CGRect(x: 0, y: self.bounds.height - height, width: self.bounds.width, height: height)
        subContentView.backgroundColor = .clear
        self.addSubview(subContentView)
        progressLbl.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
        progressLbl.text = ""
        progressLbl.textColor = .red
        progressLbl.textAlignment = .center
        progressLbl.font = UIFont(name: progressLbl.font.fontName, size: 55)
        startEquilizer()
        BubbleTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(startB), userInfo: nil, repeats: true)
        // 2.                            // 3.
        
    }
    
    
    // MARK: - Class Fun
    
    @objc private func startB(){
        startBubble(view: subContentView)
    }
    
    
    public func progressValue(value:CGFloat){
        
        progressLbl.text = "\(Int(value * 100))%"
        
        height = targetHeight * value
        UIView.animate(withDuration: 3,
                       delay: 0.1,
                       options: UIView.AnimationOptions.curveEaseIn,
                       animations: { [self] () -> Void in
            
            subContentView.frame = CGRect(x: 0, y: self.bounds.height - height, width: subContentView.frame.width, height:height)
            
            
        }, completion: { (finished) -> Void in
            
            
        })
    }
    
    public func startEquilizer(){
        stopDisplayLink()
        shapeLayer.removeFromSuperlayer()
        shapeLayer1.removeFromSuperlayer()
        subContentView.layer.addSublayer(shapeLayer1)
        subContentView.layer.addSublayer(shapeLayer)
        startDisplayLink()
    }
    
    public func stopeEqualizer(){
        stopDisplayLink()
    }
    
    /// Start the display link
    
    private func startDisplayLink() {
        startTime = CACurrentMediaTime()
        self.displayLink?.invalidate()
        self.displayLink1?.invalidate()
        
        let displayLink = CADisplayLink(target: self, selector:#selector(handleDisplayLink(_:)))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
        
        let displayLink1 = CADisplayLink(target: self, selector:#selector(handleDisplayLink1(_:)))
        displayLink1.add(to: .main, forMode: .common)
        self.displayLink1 = displayLink1
        
    }
    
    /// Stop the display link
    
    private func stopDisplayLink() {
        displayLink?.invalidate()
        displayLink1?.invalidate()
    }
    
    
    
    
    
    @objc func handleDisplayLink(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime
        
        shapeLayer.path = wave(at: elapsed)?.cgPath
    }
    
    @objc func handleDisplayLink1(_ displayLink: CADisplayLink) {
        let elapsed = CACurrentMediaTime() - startTime - 0.5
        
        shapeLayer1.path = wave(at: elapsed)?.cgPath
    }
    
    
    
    
    
    func wave(at elapsed: Double) -> UIBezierPath? {
        guard bounds.width > 0, bounds.height > 0 else { return nil }
        
        func f(_ x: CGFloat) -> CGFloat {
            let elapsed = CGFloat(elapsed)
            let amplitude = maxAmplitude * abs(fmod(elapsed / 2, 3) - 1.5)
            let variation = sin((elapsed + amplitudeOffset) / amplitudeChangeSpeedFactor) * maxTidalVariation
            let value = sin((elapsed / saveSpeedFactor + x) * 4 * .pi)
            return value * amplitude / 2 * bounds.height + (defaultTidalHeight + variation) * bounds.height
        }
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
        
        let count = Int(bounds.width / 10)
        
        for step in 0 ... count {
            let dataPoint = CGFloat(step) / CGFloat(count)
            let x = dataPoint * bounds.width + bounds.minX
            let y = bounds.maxY - f(dataPoint)
            let point = CGPoint(x: x, y: y)
            path.addLine(to: point)
        }
        path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
        path.close()
        return path
    }
    
    
    @objc func startBubble(view:UIView) ->Void{
        
        let bubbleImageView = UIImageView()
        
        let intRandom = self.generateIntRandomNumber(min: 1, max: 5)
        
        if intRandom % 2 == 0{
            bubbleImageView.backgroundColor = UIColor.customOrangeColor
        }else{
            bubbleImageView.backgroundColor = UIColor.customBlueColor
        }
        let size = self.randomFloatBetweenNumbers(firstNum: 9, secondNum: 40)
        
        let randomOriginX = self.randomFloatBetweenNumbers(firstNum: view.frame.minX, secondNum: view.frame.maxX)
        let originy = view.frame.maxY + 10
        
        
        bubbleImageView.frame = CGRect(x: randomOriginX, y: originy, width: CGFloat(size), height: CGFloat(size))
        bubbleImageView.alpha = 1.0
        bubbleImageView.layer.cornerRadius = bubbleImageView.frame.size.height / 2
        bubbleImageView.clipsToBounds = true
        view.addSubview(bubbleImageView)
        
        let zigzagPath: UIBezierPath = UIBezierPath()
        let oX: CGFloat = bubbleImageView.frame.origin.x
        let oY: CGFloat = bubbleImageView.frame.origin.y
        let eX: CGFloat = oX
        let eY: CGFloat = oY - (self.randomFloatBetweenNumbers(firstNum: view.frame.midY, secondNum: view.frame.maxY))
        let t = self.randomFloatBetweenNumbers(firstNum: 20, secondNum: 100)
        var cp1 = CGPoint(x: oX - t, y: ((oY + eY) / 2))
        var cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        let r = arc4random() % 2
        if (r == 1){
            let temp:CGPoint = cp1
            cp1 = cp2
            cp2 = temp
        }
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({() -> Void in
            
            UIView.transition(with: bubbleImageView, duration: 0.1, options: .transitionCrossDissolve, animations: {() -> Void in
                bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }, completion: {(_ finished: Bool) -> Void in
                bubbleImageView.removeFromSuperview()
            })
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 3.5
        pathAnimation.path = zigzagPath.cgPath
        
        pathAnimation.fillMode = CAMediaTimingFillMode.forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
        
    }
    
    func generateIntRandomNumber(min: Int, max: Int) -> Int {
        let randomNum = Int(arc4random_uniform(UInt32(max) - UInt32(min)) + UInt32(min))
        return randomNum
    }
    
    func randomFloatBetweenNumbers(firstNum: CGFloat, secondNum: CGFloat) -> CGFloat{
        return CGFloat(arc4random()) / CGFloat(UINT32_MAX) * abs(firstNum - secondNum) + min(firstNum, secondNum)
    }
    
}

extension UIColor{
    static let customOrangeColor = UIColor.init(red:255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 1.0)
    static let customBlueColor = UIColor.init(red:255.0/255.0, green: 255.0/255.0, blue: 255/255.0, alpha: 0.5)
}


