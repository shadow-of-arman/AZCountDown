//
//  UICountDownDelegate.swift
//  AZCountDown
//
//  Created by Arman Zoghi on 2/3/21.
//

import Foundation

/// The protocol responsible for the UICountDown's delegate.
public protocol UICountDownDelegate {
    /// Gets called when the countdown reaches zero.
    func countDownFinished()
    /// Returns the seconds remaining for the countdown to end.
    /// - Parameter seconds: The seconds remaining.
    func secondsRemaining(seconds: Int)
}
