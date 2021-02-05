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
    let timer2 = UITimer()
    let timer3 = UITimer()
    let timer4 = UITimer()
    let timer5 = UITimer()
    let gradiant = CAGradientLayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.gradiant.endPoint = .init(x: 1, y: 1)
        self.gradiant.colors = [UIColor(red: 197/255, green: 51/255, blue: 226/255, alpha: 1).cgColor, UIColor(red: 91/255, green: 158/255, blue: 230/255, alpha: 1).cgColor]
        self.gradiant.frame = UIScreen.main.bounds
        self.view.layer.addSublayer(self.gradiant)
        self.example1()
        self.example2()
        self.example3()
        self.example4()
        self.example5()
    }
    
    //example 1
    fileprivate func example1() {
        self.timer.delegate = self
        self.timer.setColonSeparators = true
        self.timer.type = .doubleField
        self.timer.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
//        self.timer.timeInterval = 0.5
        self.timer.countdownFrom(days: 3, hours: 17, minutes: 25, seconds: 33)
        self.timer.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer)
        self.timer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer, attribute: .top, relatedBy: .equal, toItem: self.view.safeAreaLayoutGuide, attribute: .top, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }
    
    //example 2
    fileprivate func example2() {
        self.timer2.delegate = self
        self.timer2.setColonSeparators = true
        self.timer2.type = .doubleField
        self.timer2.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
//        self.timer.timeInterval = 0.5
        self.timer2.countdownFrom(days: 0, hours: 18, minutes: 46, seconds: 50)
        self.timer2.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer2)
        self.timer2.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer2, attribute: .top, relatedBy: .equal, toItem: self.timer, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: self.timer2, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer2, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer2, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }
    
    //example 3
    fileprivate func example3() {
        self.timer3.delegate = self
        self.timer3.setColonSeparators = false
        self.timer3.type = .doubleField
        self.timer3.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
        self.timer3.countdownFrom(days: 0, hours: 16, minutes: 32, seconds: 12)
        self.timer3.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer3)
        self.timer3.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer3, attribute: .top, relatedBy: .equal, toItem: self.timer2, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: self.timer3, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer3, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer3, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }
    
    //example 4
    fileprivate func example4() {
        self.timer4.delegate = self
        self.timer4.setColonSeparators = true
        self.timer4.type = .singleField
        self.timer4.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
        self.timer4.countdownFrom(days: 2, hours: 16, minutes: 32, seconds: 12)
        self.timer4.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer4)
        self.timer4.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer4, attribute: .top, relatedBy: .equal, toItem: self.timer3, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: self.timer4, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer4, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer4, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }
    
    //example 5
    fileprivate func example5() {
        self.timer5.delegate = self
        self.timer5.setColonSeparators = true
        self.timer5.convertToPersian = true
        self.timer5.type = .doubleField
        self.timer5.textColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
        self.timer5.countdownFrom(days: 0, hours: 16, minutes: 32, seconds: 12)
        self.timer5.setBorder(width: 1, color: #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: 5)
        self.view.addSubview(self.timer5)
        self.timer5.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer5, attribute: .top, relatedBy: .equal, toItem: self.timer4, attribute: .bottom, multiplier: 1, constant: 30).isActive = true
        NSLayoutConstraint(item: self.timer5, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer5, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer5, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
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
