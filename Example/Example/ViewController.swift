//
//  ViewController.swift
//  Example
//
//  Created by Arman Zoghi on 2/2/21.
//

import UIKit
import UITimer

class ViewController: UIViewController {

    let timer = UITimer()
    let gradiant = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradiant.endPoint = .init(x: 1, y: 1)
        self.gradiant.colors = [UIColor(red: 197/255, green: 51/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 91/255, green: 158/255, blue: 230/255, alpha: 1).cgColor]
        self.gradiant.frame = UIScreen.main.bounds
        self.view.layer.addSublayer(self.gradiant)
        self.allConfig()
    }
    
    //all config
    fileprivate func allConfig() {
        self.timer.delegate = self
        self.timer.setColonSeparators = true
        self.timer.convertToPersian = true
        self.timer.type = .doubleField
        self.timer.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
        self.timer.countdownFrom(days: 3, hours: 17, minutes: 46, seconds: 50)
        self.timer.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer)
        self.timer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }

}

extension ViewController: UITimerDelegate {
    func secondsRemaining(seconds: Int) {
//        print(seconds)
    }
    
    func countDownFinished() {
        print("FINISHED!")
    }
    
    
}
