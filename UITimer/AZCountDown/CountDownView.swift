//
//  CountDownView.swift
//  AZCountDown
//
//  Created by Arman Zoghi on 2/3/21.
//

import Foundation
import UIKit

class CountDownView: UIView {
    
    /// The label inside the view that is responsible for showing the time string.
    let timeLabel = UILabel()
    
    /// Sets the time to show inside the time label.
    var timeString = "" {
        didSet {
            self.timeLabel.text = self.timeString
        }
    }
    
    /// Sets the font to use for the time label.
    var font: UIFont! {
        didSet {
            self.timeLabel.font = self.font
        }
    }
    
    var color: UIColor! {
        didSet {
            self.timeLabel.textColor = self.color
        }
    }
    
//MARK: - View LifeCycle
    /// Initializes and returns a newly allocated CountDownView object with the specified frame rectangle.
    /// - Parameter frame: The frame rectangle for the view, measured in points. The origin of the frame is relative to the superview in which you plan to add it. This method uses the frame rectangle to set the `center` and `bounds` properties accordingly.
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.9322072864, green: 0.8707377911, blue: 0.9809352756, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.labelConfig()
    }
    
    /// Returns an object initialized from data in a given unarchiver.
    /// - Parameter coder: An unarchiver object.
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.backgroundColor = #colorLiteral(red: 0.9322072864, green: 0.8707377911, blue: 0.9809352756, alpha: 1)
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        self.labelConfig()
    }
    
//MARK: - All configs
    fileprivate func allConfigs() {
        self.labelConfig()
    }
    
//MARK: - Time Label
    //config
    fileprivate func labelConfig() {
        self.addSubview(self.timeLabel)
        self.labelConstraints()
        self.timeLabel.textAlignment = .center
        self.timeLabel.textColor = #colorLiteral(red: 0.5561129451, green: 0.1538559794, blue: 0.629018724, alpha: 1)
        self.timeLabel.text = "0"
        self.timeLabel.backgroundColor = .clear
    }
    //constraints
    fileprivate func labelConstraints() {
        self.timeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint(item: self.timeLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timeLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timeLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: 0.9, constant: 0).isActive = true
        NSLayoutConstraint(item: self.timeLabel, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.9, constant: 0).isActive = true
    }
}
