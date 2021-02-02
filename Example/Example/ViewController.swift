//
//  ViewController.swift
//  Example
//
//  Created by Arman Zoghi on 2/2/21.
//

import UIKit
import UITimer

class ViewController: UIViewController {

    let timer = TimerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.allConfig()
    }
    
    //all config
    fileprivate func allConfig() {
        self.timer.remainingTime = 323210
        self.view.addSubview(self.timer)
        self.timer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timer, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.8, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timer, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0, constant: 80).isActive = true
    }

}

