//
//  UITimerDelegate.swift
//  UITimer
//
//  Created by Arman Zoghi on 2/3/21.
//

import Foundation

public protocol UITimerDelegate {
    func countDownFinished()
    func secondsRemaining(seconds: Int)
}
