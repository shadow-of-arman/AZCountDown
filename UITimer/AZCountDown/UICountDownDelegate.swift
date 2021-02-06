//
//  UICountDownDelegate.swift
//  AZCountDown
//
//  Created by Arman Zoghi on 2/3/21.
//

import Foundation

public protocol UICountDownDelegate {
    func countDownFinished()
    func secondsRemaining(seconds: Int)
}
