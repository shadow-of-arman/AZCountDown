//
//  UITimer.swift
//  UITimer
//
//  Created by soroush Amini Araste on 10/5/20.
//  Copyright © 2020 soroush Amini Araste. All rights reserved.
//

import UIKit

open class UITimer: UIView {
    
    open var type: UITimerType = .singleField {
        didSet {
            switch self.type {
            case .singleField:
                self.timerStackView.spacing = 15
            case .doubleField:
                self.timerStackView.spacing = 5
            }
        }
    }
    
    /// Sets the time to countdown from.
    open var countDown: Int = 1 {
        didSet {
            self.createTimerLabels()
            self.configCountDownTimer(totalTime: countDown)
            temp = countDown
        }
    }
    
    /// Sets the time to countdown from.
    /// - Parameters:
    ///   - days: Days left.
    ///   - hours: Hours left.
    ///   - minutes: Minutes left.
    ///   - seconds: Seconds left.
    open func countdownFrom(days: Int, hours: Int, minutes: Int, seconds: Int) {
        let time = seconds + (minutes * 60) + (hours * 3600) + (days * 86400)
        self.countDown = time
    }
    
    /// Converts the countdown numbers shown to Persian.
    open var convertToPersian = false {
        didSet {
            if self.convertToPersian == true {
                self.titles = ["روز", "ساعت", "دقیقه" , "ثانیه"]                
            }
        }
    }
    
    open func setBorder(width: CGFloat, color: UIColor, cornerRadius: CGFloat? = 10) {
        let count = self.labelArray.count - 1
        for i in 0...count {
            self.labelArray[i].layer.borderWidth = width
            self.labelArray[i].layer.borderColor = color.cgColor
            self.labelArray[i].layer.cornerRadius = cornerRadius!
        }
    }
    
    open var textColor: UIColor = .black {
        didSet {
            for i in 0...3 {
                let label = titlesStackView.arrangedSubviews[i] as! UILabel
                label.textColor = self.textColor
            }
        }
    }
    
    fileprivate var timer = Timer()
    fileprivate var labelArray: [TimerView] = []
    fileprivate var titles: [String] = ["Days", "Hours", "Minutes", "Seconds"] {
        didSet {
            for i in 0...3 {
                let label = titlesStackView.arrangedSubviews[i] as! UILabel
                label.text = titles[i]
            }
        }
    }

    fileprivate var temp: Int = 0
    fileprivate var timerStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    fileprivate var titlesStackView: UIStackView = {
        var stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        return stackView
    }()
    
    
    //MARK: - DEFAULT INITIALIZE
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
        timer = Timer(timeInterval: 1.0, target: self, selector: #selector(timerCalculation), userInfo: nil, repeats: true)
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    //MARK: - INITIALIZE UI
    fileprivate func createUI() {
        self.addingTimerStackView()
        self.configTitleLabels()
        self.addingTitleStackView()
    }
    
    fileprivate func addingTimerStackView() {
        self.addSubview(timerStackView)
        self.timerStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: timerStackView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timerStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timerStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: timerStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.7, constant: 0).isActive = true
    }
    
    fileprivate func addingTitleStackView() {
        self.addSubview(titlesStackView)
        self.titlesStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: titlesStackView, attribute: .top, relatedBy: .equal, toItem: self.timerStackView, attribute: .bottom, multiplier: 1, constant: 10).isActive = true
        NSLayoutConstraint(item: titlesStackView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titlesStackView, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: titlesStackView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.3, constant: 0).isActive = true
    }
    
    fileprivate func configTitleLabels() {
        for i in 0...3 {
            let label = UILabel()
            label.text = titles[i]
            label.font = .systemFont(ofSize: 12)
            label.textAlignment = .center
//            label.configure(text: "\(titles[i])", fontSize: 14, textColor: .init(hex: "333333"), textAlignment: .center, fontType: .regular)
            titlesStackView.addArrangedSubview(label)
        }
    }
    
    fileprivate func configCountDownTimer(totalTime: Int) {
        let convertedTime = secondsToDaysHoursMinutesSeconds(seconds: totalTime)
        if self.convertToPersian == true {
            if labelArray[0].timeString != String(convertedTime.0).convertEngNumToPersianNum() {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0).convertEngNumToPersianNum()
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.1).convertEngNumToPersianNum() {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.1).convertEngNumToPersianNum()
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.2).convertEngNumToPersianNum() {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.2).convertEngNumToPersianNum()
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.3).convertEngNumToPersianNum() {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.3).convertEngNumToPersianNum()
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
        } else {
            if labelArray[0].timeString != String(convertedTime.0) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0)
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.1) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.1)
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.2) {
                UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.2)
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.3) {
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.3)
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
        }
    }
    
    fileprivate func secondsToDaysHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int, Int) {
        var remaining = 0
        let days = seconds / (24 * 3600)
        remaining = seconds % (24 * 3600)
        let hours = remaining / 3600
        remaining = remaining % 3600
        let minutes = remaining / 60
        let seconds = (seconds % 3600) % 60
        return (days, hours, minutes, seconds)
    }
    
    fileprivate func createTimerLabels() {
        self.labelArray = []
        if type == .singleField {
            for _ in 0...3 {
                let label = TimerView()
                self.labelArray.append(label)
            }
        } else {
            for _ in 0...7 {
                let label = TimerView()
                self.labelArray.append(label)
            }
        }
        self.labelArray.forEach { (label) in
            label.timeString = label.timeString.convertEngNumToPersianNum()
            self.timerStackView.addArrangedSubview(label)
            if self.type == .doubleField {
                for i in 0...7 {
                    if i % 2 != 0 {
                        self.timerStackView.setCustomSpacing(15, after: labelArray[i])
                    }
                }                
            }
        }
    }
    
    @objc func timerCalculation() {
        self.configCountDownTimer(totalTime: temp - 1)
        self.temp -= 1
    }
    
    //MARK: - OBJC FUNCTIONS
    
    //MARK: - UPDATE UI
    fileprivate func updateUI() {
        
    }
}


extension String {
    func convertEngNumToPersianNum() -> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
}
