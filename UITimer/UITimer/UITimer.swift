//
//  UITimer.swift
//  UITimer
//
//  Created by soroush Amini Araste on 10/5/20.
//  Copyright © 2020 soroush Amini Araste. All rights reserved.
//

import UIKit

open class UITimer: UIView {
    
    open var delegate: UITimerDelegate?
    
    /// Decides what type of countdown to show.
    open var type: UITimerType = .singleField {
        didSet {
            switch self.type {
            case .singleField:
                self.timerStackView.spacing = 15
            case .doubleField:
                self.timerStackView.spacing = 3
            }
        }
    }
    
    /// Sets colons to separate seconds from minutes from hours from days. 
    open var setColonSeparators = false
    
    open var colonColor: UIColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)
    
    open var hideTitles = false {
        didSet {
            self.titlesStackView.isHidden = self.hideTitles
        }
    }
    
    /// Sets the time interval which the count down must obey. Must be set before countdown.
    open var timeInterval: Double = 1.0 
    
    /// Sets the time to countdown from.
    open var countDown: Int = 1 {
        didSet {
            timer = Timer(timeInterval: self.timeInterval, target: self, selector: #selector(timerCalculation), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            self.createTimerLabels()
            if self.type == .singleField {
                self.configCountDownTimer(totalTime: countDown)
            } else {
                self.configDoubleDigitCountDownTimer(totalTime: countDown)
            }
            self.checkIfDaysExist()
            self.checkIfHoursExist()
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
    
    /// Configures the layer of the countdown cells.
    /// - Parameters:
    ///   - width: Sets the border width.
    ///   - color: Sets the border color.
    ///   - cornerRadius: Sets the corner radius of cells
    open func setBorder(width: CGFloat, color: UIColor = #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: CGFloat? = 10) {
        let count = self.labelArray.count - 1
        for i in 0...count {
            self.labelArray[i].layer.borderWidth = width
            self.labelArray[i].layer.borderColor = color.cgColor
            self.labelArray[i].layer.cornerRadius = cornerRadius!
        }
    }
    
    open func customize(backgroundColor: UIColor? = #colorLiteral(red: 0.9322072864, green: 0.8707377911, blue: 0.9809352756, alpha: 1), numberColor: UIColor? = #colorLiteral(red: 0.5561129451, green: 0.1538559794, blue: 0.629018724, alpha: 1), font: UIFont?, borderWidth: CGFloat? = 0, borderColor: UIColor? = #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: CGFloat? = 10, titleColor: UIColor? = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1) ,colonColor: UIColor? = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)) {
        let count = self.labelArray.count - 1
        for i in 0...count {
            self.labelArray[i].backgroundColor = backgroundColor!
            self.labelArray[i].color = numberColor!
            self.labelArray[i].font = font
            self.labelArray[i].layer.borderWidth = borderWidth!
            self.labelArray[i].layer.borderColor = borderColor!.cgColor
            self.labelArray[i].layer.cornerRadius = cornerRadius!
        }
        self.textColor = titleColor!
        self.colonColor = colonColor!
    }
    
    /// Sets the color of the text fields below the timer.
    open var textColor: UIColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1) {
        didSet {
            for i in 0...3 {
                let label = titlesStackView.arrangedSubviews[i] as! UILabel
                label.textColor = self.textColor
            }
        }
    }
    
    fileprivate var timer = Timer() {
        didSet {
            oldValue.invalidate()
        }
    }
    fileprivate var labelArray: [TimerView] = []
    /// An array of 4 strings which sets the titles below the timer.
    open var titles: [String] = ["Days", "Hours", "Minutes", "Seconds"] {
        didSet {
            for i in 0...3 {
                let label = titlesStackView.arrangedSubviews[i] as! UILabel
                label.textColor = self.textColor
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
    
//MARK: - checkes
    //days
    fileprivate func checkIfDaysExist() {
        if self.countDown < 86400 {
            if self.type == .doubleField {
                self.titlesStackView.arrangedSubviews[0].isHidden = true
                self.timerStackView.arrangedSubviews[0].isHidden = true
                self.timerStackView.arrangedSubviews[1].isHidden = true
                if self.setColonSeparators {
                    self.timerStackView.arrangedSubviews[2].isHidden = true
                }
            } else {
                self.titlesStackView.arrangedSubviews[0].isHidden = true
                self.timerStackView.arrangedSubviews[0].isHidden = true
                if self.setColonSeparators {
                    self.timerStackView.arrangedSubviews[1].isHidden = true
                }
            }
        }
    }
    
    //hours
    fileprivate func checkIfHoursExist() {
        if self.countDown < 3600 {
            if self.type == .doubleField {
                self.titlesStackView.arrangedSubviews[1].isHidden = true
                self.timerStackView.arrangedSubviews[3].isHidden = true
                self.timerStackView.arrangedSubviews[4].isHidden = true
                if self.setColonSeparators {
                    self.timerStackView.arrangedSubviews[5].isHidden = true
                }
            } else {
                self.titlesStackView.arrangedSubviews[1].isHidden = true
                self.timerStackView.arrangedSubviews[1].isHidden = true
                if self.setColonSeparators {
                    self.timerStackView.arrangedSubviews[2].isHidden = true
                }
            }
        }
    }
    
    //MARK: - DEFAULT INITIALIZE
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    public init(Interval: Double? = 1.0, Type: UITimerType? = .doubleField, FromTime: Int, SetColonSeparators: Bool? = true, TextColor: UIColor? = .white) {
        super.init(frame: .zero)
        
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
            titlesStackView.addArrangedSubview(label)
        }
    }
    
    fileprivate func configCountDownTimer(totalTime: Int) {
        let animationDuration = (self.timeInterval * 2) / 10
        let convertedTime = secondsToDaysHoursMinutesSeconds(seconds: totalTime)
        if self.convertToPersian == true {
            if labelArray[0].timeString != String(convertedTime.0).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0).convertEngNumToPersianNum()
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.1).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.1).convertEngNumToPersianNum()
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.2).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.2).convertEngNumToPersianNum()
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.3).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.3).convertEngNumToPersianNum()
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
        } else {
            if labelArray[0].timeString != String(convertedTime.0) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0)
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.1) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.1)
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.2) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.2)
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.3) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.3)
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
        }
    }
    
    fileprivate func configDoubleDigitCountDownTimer(totalTime: Int) {
        let animationDuration = (self.timeInterval * 2) / 10
        let convertedTime = secondsToDaysHoursMinutesSeconds(seconds: totalTime)
        if self.convertToPersian == true {
            if labelArray[0].timeString != String(convertedTime.0 / 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0 / 10).convertEngNumToPersianNum()
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.0 % 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.0 % 10).convertEngNumToPersianNum()
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.1 / 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.1 / 10).convertEngNumToPersianNum()
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.1 % 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.1 % 10).convertEngNumToPersianNum()
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[4].timeString != String(convertedTime.2 / 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[4].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[4].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[4].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[4].timeString = String(convertedTime.2 / 10).convertEngNumToPersianNum()
                    self.labelArray[4].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[4].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[4].timeLabel.transform = .identity
                        self.labelArray[4].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[5].timeString != String(convertedTime.2 % 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[5].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[5].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[5].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[5].timeString = String(convertedTime.2 % 10).convertEngNumToPersianNum()
                    self.labelArray[5].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[5].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[5].timeLabel.transform = .identity
                        self.labelArray[5].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[6].timeString != String(convertedTime.3 / 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[6].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[6].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[6].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[6].timeString = String(convertedTime.3 / 10).convertEngNumToPersianNum()
                    self.labelArray[6].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[6].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[6].timeLabel.transform = .identity
                        self.labelArray[6].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[7].timeString != String(convertedTime.3 % 10).convertEngNumToPersianNum() {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[7].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[7].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[7].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[7].timeString = String(convertedTime.3 % 10).convertEngNumToPersianNum()
                    self.labelArray[7].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[7].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[7].timeLabel.transform = .identity
                        self.labelArray[7].timeLabel.alpha = 1
                    }
                }
            }
        } else {
            if labelArray[0].timeString != String(convertedTime.0 / 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[0].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[0].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[0].timeString = String(convertedTime.0 / 10)
                    self.labelArray[0].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[0].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[0].timeLabel.transform = .identity
                        self.labelArray[0].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[1].timeString != String(convertedTime.0 % 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[1].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[1].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[1].timeString = String(convertedTime.0 % 10)
                    self.labelArray[1].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[1].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[1].timeLabel.transform = .identity
                        self.labelArray[1].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[2].timeString != String(convertedTime.1 / 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[2].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[2].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[2].timeString = String(convertedTime.1 / 10)
                    self.labelArray[2].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[2].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[2].timeLabel.transform = .identity
                        self.labelArray[2].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[3].timeString != String(convertedTime.1 % 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[3].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[3].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[3].timeString = String(convertedTime.1 % 10)
                    self.labelArray[3].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[3].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[3].timeLabel.transform = .identity
                        self.labelArray[3].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[4].timeString != String(convertedTime.2 / 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[4].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[4].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[4].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[4].timeString = String(convertedTime.2 / 10)
                    self.labelArray[4].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[4].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[4].timeLabel.transform = .identity
                        self.labelArray[4].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[5].timeString != String(convertedTime.2 % 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[5].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[5].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[5].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[5].timeString = String(convertedTime.2 % 10)
                    self.labelArray[5].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[5].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[5].timeLabel.transform = .identity
                        self.labelArray[5].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[6].timeString != String(convertedTime.3 / 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[6].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[6].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[6].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[6].timeString = String(convertedTime.3 / 10)
                    self.labelArray[6].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[6].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[6].timeLabel.transform = .identity
                        self.labelArray[6].timeLabel.alpha = 1
                    }
                }
            }
            if labelArray[7].timeString != String(convertedTime.3 % 10) {
                UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseOut) {
                    self.labelArray[7].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: self.labelArray[7].bounds.height / 2 + 5).scaledBy(x: 0.7, y: 0.7)
                    self.labelArray[7].timeLabel.alpha = 0.1
                } completion: { (_) in
                    self.labelArray[7].timeString = String(convertedTime.3 % 10)
                    self.labelArray[7].timeLabel.transform = CGAffineTransform.identity.translatedBy(x: 0, y: -self.labelArray[7].bounds.height / 2 - 10).scaledBy(x: 0.7, y: 0.7)
                    UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut) {
                        self.labelArray[7].timeLabel.transform = .identity
                        self.labelArray[7].timeLabel.alpha = 1
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
        self.timerStackView.removeAllArrangedSubviews()
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
        }
        if self.type == .doubleField {
            for i in 0...6 {
                if i % 2 != 0 {
                    if self.setColonSeparators {
                        let separator = UILabel()
                        separator.text = ":"
                        separator.textAlignment = .center
                        separator.font = .boldSystemFont(ofSize: 25)
                        separator.textColor = self.colonColor
                        self.timerStackView.insertArrangedSubview(separator, at: (i + 1 + (i / 2)))
                        self.timerStackView.setCustomSpacing(-5, after: separator)
                        self.timerStackView.setCustomSpacing(-5, after: labelArray[i])
                    } else {
                        self.timerStackView.setCustomSpacing(15, after: labelArray[i])
                    }
                }
            }
        } else {
            for i in 0...2 {
                if self.setColonSeparators {
                    let separator = UILabel()
                    separator.text = ":"
                    separator.textAlignment = .center
                    separator.font = .boldSystemFont(ofSize: 25)
                    separator.textColor = self.colonColor
                    self.timerStackView.insertArrangedSubview(separator, at: (2 * i + 1))
                    self.timerStackView.setCustomSpacing(-20, after: separator)
                    self.timerStackView.setCustomSpacing(-20, after: labelArray[i])
                }
            }
        }
    }
    
    @objc func timerCalculation() {
        if self.type == .singleField {
            self.configCountDownTimer(totalTime: temp - 1)
        } else {
            self.configDoubleDigitCountDownTimer(totalTime: temp - 1)
        }
        self.temp -= 1
        self.delegate?.secondsRemaining(seconds: temp)
        if self.temp == 0 {
            self.delegate?.countDownFinished()
            self.timer.invalidate()
        }
    }
}

extension UITimer: UITimerDelegate {
    public func secondsRemaining(seconds: Int) {
        //seconds remaining.
    }
    
    public func countDownFinished() {
        //finished.
    }
}

private extension String {
    func convertEngNumToPersianNum() -> String {
        let numbersDictionary : Dictionary = ["0" : "۰","1" : "۱", "2" : "۲", "3" : "۳", "4" : "۴", "5" : "۵", "6" : "۶", "7" : "۷", "8" : "۸", "9" : "۹"]
        var str : String = self
        
        for (key,value) in numbersDictionary {
            str =  str.replacingOccurrences(of: key, with: value)
        }
        
        return str
    }
}

private extension UIStackView {
    /// Removes all arranged subviews within a StackView.
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
