import Foundation
import SwiftUI

class Tokens {
    static let menuSpring = Animation.spring(response: 0.65, dampingFraction: 0.65, blendDuration: 0.5)
    static let backgroundBlur:CGFloat = 250
    static let topPadding: CGFloat = 20
    static let fastBounceAnimation: Animation = .spring(response: 0.2, dampingFraction: 0.8, blendDuration: 0.1)
    
    
    static let fastBounceAnimationNoBounce: Animation = .spring(response: 0.1, dampingFraction: 1, blendDuration: 0.05)
    
    struct Radius {
        static let sm: CGFloat = 4
        static let md: CGFloat = 8
        static let lg: CGFloat = 12
        static let xl: CGFloat = 16
        static let xxl: CGFloat = 24
        static let xxxl: CGFloat = 32
        static let pill: CGFloat = 100000
    }
    
    struct Spacing {
        static let xs: CGFloat = 0
        static let sm: CGFloat = 2
        static let md: CGFloat = 4
        static let lg: CGFloat = 8
        static let xl: CGFloat = 12
        static let xxl: CGFloat = 16
        static let xxxl: CGFloat = 20
        static let xxxxl: CGFloat = 24
    }

    
    struct Scale {
        static let s0: CGFloat = 0
        static let s25: CGFloat = 1
        static let s50: CGFloat = 2
        static let s100: CGFloat = 4
        static let s200: CGFloat = 8
        static let s300: CGFloat = 14
        static let s400: CGFloat = 16
        static let s500: CGFloat = 20
        static let s600: CGFloat = 24
        static let s700: CGFloat = 28
        static let s800: CGFloat = 32
        static let s900: CGFloat = 40
        static let s1000: CGFloat = 48
        static let s1100: CGFloat = 64
        static let s1200: CGFloat = 80
        static let s1300: CGFloat = 96
        static let s1400: CGFloat = 128
        static let s1500: CGFloat = 100000
    }
}

let isiOS26OrLater = ProcessInfo().isOperatingSystemAtLeast(
    OperatingSystemVersion(majorVersion: 26, minorVersion: 0, patchVersion: 0)
)
