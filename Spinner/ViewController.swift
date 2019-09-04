//
//  ViewController.swift
//  Spinner
//
//  Adapted from: https://medium.com/@pratheeshdhayadev/spinner-wheel-animation-swift-f9a1c16e6ca7
//
//  Created by David Lane on 8/6/19.
//  Copyright © 2019 David Lane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var spinnerContainer: UIView!
    //@IBOutlet weak var fieldsChanger: UITextField!
    @IBOutlet weak var challengeFunSelector: UISegmentedControl!

    
    var challengeFun = 0
    
    var spinnerFields: [UIView] = []
    var numSpinnerFields: Double? = 0
    var currentField: Int = 0
    
    var kArcCentreX: CGFloat = 0
    var kArcCentreY: CGFloat = 0
    var kArcRadius: CGFloat = 0
    
    var spinnerWidth: CGFloat = 0
    var spinnerHeight: CGFloat = 0
    
    var spinnerFieldWidth: CGFloat = 0
    
    var kBoxViewCornerRadius: CGFloat = 0
    
    let kSpinnerDuration = 1.0

    override func viewDidLoad() {
        super.viewDidLoad()
        //configureTextFields()
        //sets size of spinner according to device
        let spinnerSize: CGFloat = self.spinnerContainer.frame.size.width/2
        //let spinnerX
        //print(spinnerSize)
        kArcCentreX = spinnerSize/2
        kArcCentreY = spinnerSize/2
        kArcRadius = spinnerSize/2
        spinnerWidth = spinnerSize
        spinnerHeight = spinnerSize
        spinnerFieldWidth = spinnerSize
        kBoxViewCornerRadius = spinnerSize/2
        numSpinnerFields = 8
        drawSpinner(withBase: spinnerContainer, numFields: numSpinnerFields!, withColor1: UIColor.red, withColor2: UIColor.green)
    }
    
    internal func drawSpinner(withBase baseView:UIView, numFields: Double, withColor1 color1:UIColor, withColor2 color2:UIColor) {
        //Create the frame of the spinner, a CGRect object
        let frame = CGRect(x: Double(kArcCentreX), y: Double(kArcCentreY), width: Double(spinnerWidth), height: Double(spinnerHeight))
        
        /*//boxView just contains the middle of the spinner (deprecated)
        let boxView = UIView(frame: frame)
        boxView.backgroundColor = UIColor.clear
        boxView.tag = 55
        boxView.layer.borderWidth = CGFloat(spinnerWidth)
        //Corner radius should be half of spinner height
        boxView.layer.cornerRadius = CGFloat(kBoxViewCornerRadius)
        boxView.layer.borderColor = UIColor.brown.cgColor
        baseView.addSubview(boxView)*/
        
        var i: Double = 0
        while i < numFields {
            //top field is not offset properly for even numbers modulo 4 = 0
            let circlePath = UIBezierPath(arcCenter: CGPoint(x: kArcCentreX, y: kArcCentreY), radius: CGFloat(kArcRadius), startAngle: CGFloat(Double.pi*2*i/numFields + Double.pi/numFields), endAngle: CGFloat(Double.pi*2*i/numFields + Double.pi*2/numFields + Double.pi/numFields), clockwise: true)

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            if Int(i) % 2 == 0 {
                shapeLayer.strokeColor = color1.cgColor
            }
            else {
                shapeLayer.strokeColor = color2.cgColor
            }
            shapeLayer.lineWidth = CGFloat(spinnerFieldWidth)
            shapeLayer.strokeEnd = 1
            
            let boxView2 = UIView(frame: frame)
            boxView2.backgroundColor = UIColor.clear
            boxView2.tag = 55
            boxView2.layer.borderWidth = CGFloat(spinnerFieldWidth)
            boxView2.layer.cornerRadius = CGFloat(kBoxViewCornerRadius)
            boxView2.layer.borderColor = UIColor.clear.cgColor
            
            boxView2.layer.addSublayer(shapeLayer)
            
            spinnerFields.append(boxView2)
            
            baseView.addSubview(boxView2)
            
            i += 1
        }
        
        //let circlePath = UIBezierPath(arcCenter: CGPoint(x: kArcCentreX, y: kArcCentreY), radius: CGFloat(kArcRadius), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi/2), clockwise: true)
        /*let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = CGFloat(kBoxViewBorderWidth)
        shapeLayer.strokeEnd = 1*/
        /*boxView2 = UIView(frame: frame)
        boxView2.backgroundColor = UIColor.clear
        boxView2.tag = 55
        boxView2.layer.borderWidth = CGFloat(kBoxViewBorderWidth)
        boxView2.layer.cornerRadius = CGFloat(kBoxViewCornerRadius)
        boxView2.layer.borderColor = UIColor.clear.cgColor
        boxView2.layer.addSublayer(shapeLayer)
        baseView.addSubview(boxView)
        baseView.addSubview(boxView2)
        //baseView.bringSubviewToFront(boxView2)*/
        
    }

    private func rotateView(targetView: UIView) -> Int {
        var duration = Int.random(in: 2*Int(numSpinnerFields!) ... ((3*Int(numSpinnerFields!))-1))
        let spins = duration
        let rotation = 2*Double.pi/self.numSpinnerFields!
        while duration > 0 {
            if duration == 1 {
                UIView.animate(
                    withDuration: TimeInterval(spins)*0.1,
                    delay: 0.0,
                    options: .curveEaseOut,
                    animations: {targetView.transform = targetView.transform.rotated(by: CGFloat(rotation))},
                    completion: {_ in self.presentFieldAlert(spins: self.currentField)})
            } else {
                UIView.animate(
                    withDuration: TimeInterval(spins)*0.1,
                    delay: 0.0,
                    options: .curveEaseOut,
                    animations: {targetView.transform = targetView.transform.rotated(by: CGFloat(rotation))})
            }
            duration = duration - 1
        }
        return spins
    }
    
    func presentFieldAlert(spins: Int) {
        print(spins)
        let alert = UIAlertController(title: "Alert", message: String(spins), preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Click", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func spinWheel(_ sender: Any) {
        let rotations = rotateView(targetView: spinnerContainer)
        //cover spin button with clear view
        currentField = (currentField + rotations) % Int(numSpinnerFields!)
        //print(currentField)
        /*for i in spinnerFields {
            rotateView(targetView: i, duration: kSpinnerDuration)
        }*/
    }
    
    @IBAction func switchChallengeFun(_ sender: Any) {
        //print(challengeFunSelector.selectedSegmentIndex)
        if challengeFunSelector.selectedSegmentIndex == 0 {
            destroySpinner()
            drawSpinner(withBase: spinnerContainer, numFields: 8, withColor1: UIColor.red, withColor2: UIColor.green)
            challengeFun = 0
        }
        if challengeFunSelector.selectedSegmentIndex == 1 {
            destroySpinner()
            drawSpinner(withBase: spinnerContainer, numFields: 8, withColor1: UIColor.blue, withColor2: UIColor.yellow)
            challengeFun = 1
            //print("hi")
        }
    }
    
    
    
    private func destroySpinner() {
        for i in spinnerFields {
            i.removeFromSuperview()
            spinnerFields.removeLast()
        }
    }
    
    
    /*private func configureTextFields() {
     fieldsChanger.delegate = self
     }*/
    
    /*@IBAction func changeNumFields(_ sender: Any) {
        //Use ifs to do this conversion better
        numSpinnerFields = Double(fieldsChanger.text!)
        if let unwrapped = numSpinnerFields {
            destroySpinner()
            drawSpinner(withBase: spinnerContainer, numFields: unwrapped)
        }
        currentField = 0
        
    }*/
    
}

/*extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}*/
