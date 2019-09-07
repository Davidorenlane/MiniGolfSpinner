//
//  ViewController.swift
//  Spinner
//
//
//  Created by David Lane on 8/6/19.
//  Copyright © 2019 David Lane. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //"Mini Golf Spinner"
    @IBOutlet weak var titleLabel: UILabel!
    //Blocks button presses while spinner spins
    //use this to end spin animation and present UIAlert when user taps while spinner is spinning
    @IBOutlet weak var touchBlocker: UIButton!
    //UIView in which spinner is drawn
    @IBOutlet weak var spinnerContainer: UIView!
    //Spins spinner when tapped
    @IBOutlet weak var spinButton: UIButton!
    //Used to switch game mode
    @IBOutlet weak var challengeFunSelector: UISegmentedControl!

    //Current game mode. Challenge = 0, Fun = 1.
    var challengeOrFun = 0
    //Challenge color = red, Fun color = blue
    let cAndFColors: [UIColor] = [UIColor.red, UIColor.blue]
    //Texts for the challenges, indexed according to position on spinner
    let challengeAndFunTexts: [String] =
        //Challenges
        ["Use the tip of your putter for your first shot.",
         "Kick your first shot.",
         "Move your ball back off the course before your first shot.",
         "Each shot, stand on the opposite side of the ball as usual (Play off-handed).",
         "After your first shot, only use the putter like a pool cue.",
         "Hit each shot with your eyes closed.",
         "Play one-handed.",
         "Play normally!",
         //Fun
         "Automatic hole in one!",
         "Hit your first shot with your eyes closed.",
         "Take one step towards the hole before your first shot.",
         "Hit your first shot through your legs.",
         "Add one stroke to any other player's score.",
         "Spin in place 10 times before your first shot.",
         "Anytime your shot hits another player's ball, that shot doesnt count towards your score (and you decide when each player hits).",
         "You can re-do one shot."]
    
    var spinnerSize: CGFloat = 0
    var spinnerRadius: CGFloat = 0
    var spinnerCenter: CGFloat = 0
    
    var numSpinnerFields: Double? = 0

    //Field currently at the top of the spinner
    var currentField: Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.layoutIfNeeded()
        //should be able to do this in IB...
        self.view.bringSubviewToFront(titleLabel)
        self.view.sendSubviewToBack(touchBlocker)
        
        //configure segmented control
        challengeFunSelector.tintColor = UIColor.red
        
        //configure spin button
        spinButton.setTitleColor(UIColor.red, for: .normal)
        spinButton.setTitleColor(UIColor(displayP3Red: 111.0/255.0, green: 113.0/255.0, blue: 121.0/255.0, alpha: 1), for: .disabled)
        spinButton.backgroundColor = UIColor.white
        spinButton.layer.cornerRadius = 5
        spinButton.layer.borderWidth = 1
        spinButton.layer.borderColor = UIColor.red.cgColor
        spinButton.setBackgroundColor(challengeFunSelector.tintColor.withAlphaComponent(0.25), for: .highlighted)

        //sets size of spinner according to device (due to Auto Layout constraints on spinnerContainer)
        spinnerSize = self.spinnerContainer.frame.size.width/2
        spinnerRadius = spinnerSize/2
        spinnerCenter = spinnerSize/2
       
        numSpinnerFields = 8
        
        //puts spinner on screen
        drawSpinner(withBase: spinnerContainer, numFields: numSpinnerFields!, withColor1: UIColor.red, withColor2: UIColor.green)
    }
    
    internal func drawSpinner(withBase baseView:UIView, numFields: Double, withColor1 color1:UIColor, withColor2 color2:UIColor) {
        
        //Reset currentField when new spinner is drawn
        currentField = 0
        
        //Create the frame of the spinner, a CGRect object, to be stored in the spinnerContainer
        let frame = CGRect(
            x: Double(spinnerCenter),
            y: Double(spinnerCenter),
            width: Double(spinnerSize),
            height: Double(spinnerSize))
        let boxView2 = UIView(frame: frame)
        //UIView.tag could be super useful
        boxView2.tag = 55
        
        //  Adapted from: https://medium.com/@pratheeshdhayadev/spinner-wheel-animation-swift-f9a1c16e6ca7
        var i: Double = 0
        while i < numFields {
            //NOTE:top field is not offset properly for even numbers modulo 4 = 0
            let circlePath = UIBezierPath(
                arcCenter: CGPoint(x: spinnerCenter, y: spinnerCenter),
                radius: CGFloat(spinnerRadius),
                startAngle: CGFloat(Double.pi*2*i/numFields + Double.pi/numFields),
                endAngle: CGFloat(Double.pi*2*i/numFields + Double.pi*2/numFields + Double.pi/numFields),
                clockwise: true)

            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            shapeLayer.fillColor = UIColor.clear.cgColor
            if Int(i) % 2 == 0 {
                shapeLayer.strokeColor = color1.cgColor
            }
            else {
                shapeLayer.strokeColor = color2.cgColor
            }
            //Spinner radius
            shapeLayer.lineWidth = CGFloat(spinnerSize)
            boxView2.layer.addSublayer(shapeLayer)
            i += 1
        }
        baseView.addSubview(boxView2)
    }

    @IBAction func spinWheel(_ sender: Any) {
        let rotations = rotateView(targetView: spinnerContainer)
        //cover spin button with clear view
        self.view.bringSubviewToFront(touchBlocker)
        //update the current field
        currentField = (currentField + rotations) % Int(numSpinnerFields!)
    }
    
    private func rotateView(targetView: UIView) -> Int {
        //do 2+ rotations
        var duration = Int.random(in: 2*Int(numSpinnerFields!) ... ((3*Int(numSpinnerFields!))-1))
        let spins = duration
        let rotation = 2*Double.pi/self.numSpinnerFields!
        
        //  Adapted from: https://medium.com/@pratheeshdhayadev/spinner-wheel-animation-swift-f9a1c16e6ca7
        while duration > 0 {
            if duration == 1 {
                UIView.animate(
                    withDuration: TimeInterval(spins)*0.1,
                    delay: 0.0,
                    options: .curveEaseOut,
                    animations: {targetView.transform = targetView.transform.rotated(by: CGFloat(rotation))},
                    //After last time around, present the challenge alert
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
        //return how far spinner was rotated
        return spins
    }
    
    func presentFieldAlert(spins: Int) {
        //remove the blocker
        self.view.sendSubviewToBack(touchBlocker)
        
        let alert = UIAlertController(title: "This Hole:", message: challengeAndFunTexts[currentField+(8*challengeOrFun)], preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(
            title: "OK",
            style: UIAlertAction.Style.default,
            handler: {(alert: UIAlertAction!) in
                //enable spin button
                self.spinButton.isEnabled = true
                if self.challengeOrFun == 0 {
                    self.spinButton.layer.borderColor = UIColor.red.cgColor
                } else {
                    self.spinButton.layer.borderColor = UIColor.blue.cgColor
                }
        }))
        self.present(alert, animated: true, completion: nil)
        
        //disable spin button
        spinButton.isEnabled = false
        //set color to gray
        spinButton.layer.borderColor = UIColor(displayP3Red: 111.0/255.0, green: 113.0/255.0, blue: 121.0/255.0, alpha: 1).cgColor
    }
    
    @IBAction func switchChallengeFun(_ sender: Any) {
        
        if challengeFunSelector.selectedSegmentIndex == 0 {
            destroySpinner()
            drawSpinner(withBase: spinnerContainer, numFields: numSpinnerFields!, withColor1: UIColor.red, withColor2: UIColor.green)
            challengeOrFun = 0
        }
        if challengeFunSelector.selectedSegmentIndex == 1 {
            destroySpinner()
            drawSpinner(withBase: spinnerContainer, numFields: numSpinnerFields!, withColor1: UIColor.blue, withColor2: UIColor.yellow)
            challengeOrFun = 1
        }
            //reconfigure UI color according to mode
            challengeFunSelector.tintColor = cAndFColors[challengeOrFun]
            spinButton.layer.borderColor = cAndFColors[challengeOrFun].cgColor
            spinButton.setTitleColor(cAndFColors[challengeOrFun], for: .normal)
            spinButton.setBackgroundColor(challengeFunSelector.tintColor.withAlphaComponent(0.25), for: .highlighted)
    }
    
    private func destroySpinner() {
        if let foundView = view.viewWithTag(55) {
            foundView.removeFromSuperview()
        }
    }
}

extension UIButton {
    // https://stackoverflow.com/questions/14523348/how-to-change-the-background-color-of-a-uibutton-while-its-highlighted
    private func image(withColor color: UIColor) -> UIImage? {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
    
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        self.setBackgroundImage(image(withColor: color), for: state)
    }
}
