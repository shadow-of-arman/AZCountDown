//
//  UICountDown.swift
//  AZCountDown
//
//  Created by soroush Amini Araste in collaboration with Arman Zoghi on 10/5/20.

//  Copyright © 2020 soroush Amini Araste, Arman Zoghi. All rights reserved.
//

import UIKit

/// A customizable view that sets a timer and starts counting down towards zero from the given value.
open class UICountDown: UIView {
    
    /// The countdown view's delegate.
    open var delegate: UICountDownDelegate?
    
    /// Decides what type of countdown to show.
    open var type: UICountDownType = .singleDigit {
        didSet {
            switch self.type {
            case .singleDigit:
                self.timerStackView.spacing = 15
            case .doubleDigit:
                self.timerStackView.spacing = 3
            }
        }
    }
    
    /// Sets colons to separate seconds from minutes from hours from days. 
    open var setColonSeparators = false
    
    /// Sets the color of the separator colons.
    open var colonColor: UIColor = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1) {
        didSet {
            for label in self.timerStackView.arrangedSubviews {
                if label.tag == 5 {
                    let colon = label as! UILabel
                    colon.textColor = self.colonColor                    
                }
            }
        }
    }
    
    /// Decides wether to hide the titles below the countdown.
    open var hideTitles = false {
        didSet {
            self.titlesStackView.isHidden = self.hideTitles
        }
    }
    
    /// Sets the time interval which the count down must obey. Must be set before countdown.
    open var timeInterval: Double = 1.0 
    
    /// Sets the time to countdown from.
    open var countDownFrom: Int = 1 {
        didSet {
            timer = Timer(timeInterval: self.timeInterval, target: self, selector: #selector(timerCalculation), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
            self.createTimerLabels()
            if self.type == .singleDigit {
                self.configCountDownTimer(totalTime: countDownFrom)
            } else {
                self.configDoubleDigitCountDownTimer(totalTime: countDownFrom)
            }
            self.checkIfDaysExist()
            self.checkIfHoursExist()
            temp = countDownFrom
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
        self.countDownFrom = time
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
        self.cellBorderWidth = width
        self.cellBorderColor = color
        self.cellCornerRadius = cornerRadius
        let count = self.labelArray.count - 1
        for i in 0...count {
            self.labelArray[i].layer.borderWidth = width
            self.labelArray[i].layer.borderColor = color.cgColor
            self.labelArray[i].layer.cornerRadius = cornerRadius!
        }
    }
    
    /// Customize the appearance of the countdown view.
    /// - Parameters:
    ///   - type: Decides what type of countdown to show.
    ///   - backgroundColor: Sets the background color of the timer cells.
    ///   - numberColor: Sets the color of the timer numbers.
    ///   - font: Sets the font to use for the timer numbers.
    ///   - borderWidth: Sets the border width of each timer cell.
    ///   - borderColor: Sets the border color of each timer cell.
    ///   - cornerRadius: Sets the corner radius of each timer cell.
    ///   - titleColor: Sets the color of the titles below the timer.
    ///   - colonColor: Sets the color of the separator colons.
    open func customize(type: UICountDownType? = .doubleDigit, backgroundColor: UIColor? = #colorLiteral(red: 0.9322072864, green: 0.8707377911, blue: 0.9809352756, alpha: 1), numberColor: UIColor? = #colorLiteral(red: 0.5561129451, green: 0.1538559794, blue: 0.629018724, alpha: 1), font: UIFont? = .systemFont(ofSize: 15), borderWidth: CGFloat? = 0, borderColor: UIColor? = #colorLiteral(red: 0.8252273202, green: 0.6826880574, blue: 0.9464033246, alpha: 1), cornerRadius: CGFloat? = 10, titleColor: UIColor? = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1), titleFont: UIFont? = .systemFont(ofSize: 12), colonColor: UIColor? = #colorLiteral(red: 0.8940555453, green: 0.8786097169, blue: 0.9770053029, alpha: 1)) {
        self.type = type!
        self.cellBackgroundColor = backgroundColor!
        self.cellNumberColor = numberColor!
        self.cellFont = font
        self.cellBorderWidth = borderWidth
        self.cellBorderColor = borderColor
        self.cellCornerRadius = cornerRadius
        if self.labelArray == [] {
            self.countDownFrom = 10000
        }
        let count = self.labelArray.count - 1
        for i in 0...count {
            self.labelArray[i].backgroundColor = backgroundColor!
            self.labelArray[i].color = numberColor!
            self.labelArray[i].font = font
            self.labelArray[i].layer.borderWidth = borderWidth!
            self.labelArray[i].layer.borderColor = borderColor!.cgColor
            self.labelArray[i].layer.cornerRadius = cornerRadius!
        }
        self.titleFont = titleFont
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
    
    /// Sets the font to use for the bottom titles.
    open var titleFont: UIFont? {
        didSet {
            for titleLabel in titlesStackView.arrangedSubviews {
                let label = titleLabel as! UILabel
                label.font = self.titleFont
            }
        }
    }
    
    fileprivate var cellBackgroundColor: UIColor = #colorLiteral(red: 0.9322072864, green: 0.8707377911, blue: 0.9809352756, alpha: 1)
    fileprivate var cellNumberColor: UIColor = #colorLiteral(red: 0.5561129451, green: 0.1538559794, blue: 0.629018724, alpha: 1)
    fileprivate var cellFont: UIFont?
    fileprivate var cellBorderWidth: CGFloat?
    fileprivate var cellBorderColor: UIColor?
    fileprivate var cellCornerRadius: CGFloat?
    
    fileprivate var timer = Timer() {
        didSet {
            oldValue.invalidate()
        }
    }
    fileprivate var labelArray: [CountDownView] = []
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
        if self.countDownFrom < 86400 {
            if self.type == .doubleDigit {
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
        if self.countDownFrom < 3600 {
            if self.type == .doubleDigit {
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
    /// Initializes and returns a newly allocated view object with the specified frame rectangle.
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the `center` and `bounds` properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createUI()
    }
    
    /// Returns an object initialized from data in a given unarchiver.
    /// - Parameter coder: An unarchiver object.
    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// Initializes a UICountdown object and sets up its properties.
    /// - Parameters:
    ///   - Interval: The time interval between each unit of time.
    ///   - Type: The type of UICountdown to use.
    ///   - FromTime: The time from which the countdown should start counting down to zero.
    public init(fromTime: Int, interval: Double? = 1.0, type: UICountDownType? = .doubleDigit) {
        super.init(frame: .zero)
        self.createUI()
        self.timeInterval = interval!
        self.type = type!
        self.countDownFrom = fromTime
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
        if type == .singleDigit {
            for _ in 0...3 {
                let label = CountDownView()
                label.backgroundColor = self.cellBackgroundColor
                label.color = self.cellNumberColor
                label.font = self.cellFont
                label.layer.borderWidth = self.cellBorderWidth ?? 0
                label.layer.borderColor = self.cellBorderColor?.cgColor ?? UIColor.clear.cgColor
                label.layer.cornerRadius = self.cellCornerRadius ?? 15
                self.labelArray.append(label)
            }
        } else {
            for _ in 0...7 {
                let label = CountDownView()
                label.backgroundColor = self.cellBackgroundColor
                label.color = self.cellNumberColor
                label.font = self.cellFont
                label.layer.borderWidth = self.cellBorderWidth ?? 0
                label.layer.borderColor = self.cellBorderColor?.cgColor ?? UIColor.clear.cgColor
                label.layer.cornerRadius = self.cellCornerRadius ?? 15
                self.labelArray.append(label)
            }
        }
        self.labelArray.forEach { (label) in
            label.timeString = label.timeString.convertEngNumToPersianNum()
            self.timerStackView.addArrangedSubview(label)
        }
        if self.type == .doubleDigit {
            for i in 0...6 {
                if i % 2 != 0 {
                    if self.setColonSeparators {
                        let separator = UILabel()
                        separator.text = ":"
                        separator.tag = 5
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
                    separator.tag = 5
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
    
    @objc fileprivate func timerCalculation() {
        if self.type == .singleDigit {
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

extension UICountDown: UICountDownDelegate {
    /// Returns the time remaining in the countdown in seconds.
    /// - Parameter seconds: The seconds remaining from the countdown to end.
    public func secondsRemaining(seconds: Int) {
        //seconds remaining.
    }
    
    /// Gets called when the timer reaches zero.
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
