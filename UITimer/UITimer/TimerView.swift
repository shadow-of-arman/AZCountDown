//
//  TimerView.swift
//  HomaMarketSymbols
//
//  Created by soroush amini araste on 10/5/20.
//  Copyright © 2020 soroush amini araste. All rights reserved.
//

import UIKit

open class TimerView: UIView {
    
    open var countDown: Int = 1 {
        didSet {
            self.createTimerLabels()
            self.configCountDownTimer(totalTime: countDown)
            temp = countDown
        }
    }
    
    /// Converts the countdown numbers shown to Persian.
    open var convertToPersian = false {
        didSet {
            if self.convertToPersian == true {
                self.titles = ["روز", "ساعت", "دقیقه" , "ثانیه"]                
            }
        }
    }
    
    fileprivate var timer = Timer()
    fileprivate var labelArray: [UILabel] = []
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
            label.font = .systemFont(ofSize: 15)
            label.textAlignment = .center
//            label.configure(text: "\(titles[i])", fontSize: 14, textColor: .init(hex: "333333"), textAlignment: .center, fontType: .regular)
            titlesStackView.addArrangedSubview(label)
        }
    }
    
    fileprivate func configCountDownTimer(totalTime: Int) {
        let convertedTime = secondsToDaysHoursMinutesSeconds(seconds: totalTime)
        if self.convertToPersian == true {
            if labelArray[0].text != String(convertedTime.0).convertEngNumToPersianNum() {
                UIView.transition(with: labelArray[0], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[0].text = String(convertedTime.0).convertEngNumToPersianNum()
                }
            }
            if labelArray[1].text != String(convertedTime.1).convertEngNumToPersianNum() {
                UIView.transition(with: labelArray[1], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[1].text = String(convertedTime.1).convertEngNumToPersianNum()
                }
            }
            if labelArray[2].text != String(convertedTime.2).convertEngNumToPersianNum() {
                UIView.transition(with: labelArray[2], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[2].text = String(convertedTime.2).convertEngNumToPersianNum()
                }
            }
            if labelArray[3].text != String(convertedTime.3).convertEngNumToPersianNum() {
                UIView.transition(with: labelArray[3], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[3].text = String(convertedTime.3).convertEngNumToPersianNum()
                }
            }
        } else {
            if labelArray[0].text != String(convertedTime.0) {
                UIView.transition(with: labelArray[0], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[0].text = String(convertedTime.0)
                }
            }
            if labelArray[1].text != String(convertedTime.1) {
                UIView.transition(with: labelArray[1], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[1].text = String(convertedTime.1)
                }
            }
            if labelArray[2].text != String(convertedTime.2) {
                UIView.transition(with: labelArray[2], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[2].text = String(convertedTime.2)
                }
            }
            if labelArray[3].text != String(convertedTime.3) {
                UIView.transition(with: labelArray[3], duration: 0.6, options: .transitionFlipFromBottom) {
                    self.labelArray[3].text = String(convertedTime.3)
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
        for _ in 0...3 {
            let label = UILabel()
            label.layer.cornerRadius = 10
            label.textAlignment = .center
            label.backgroundColor = .systemBlue
            label.textColor = .white
//            label.configure(text: "", fontSize: 17, textColor: .white, textAlignment: .center, fontType: .yekan_bold)
//            label.backgroundColor = .init(hex: "00ACAD")
            label.clipsToBounds = true
            labelArray.append(label)
        }
        labelArray.forEach { (label) in
            label.text = label.text?.convertEngNumToPersianNum()
            timerStackView.addArrangedSubview(label)
        }
    }
    
    @objc func timerCalculation() {
        configCountDownTimer(totalTime: temp - 1)
        temp -= 1
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
