import Foundation
import SwiftUI

class Tokens {
    static let menuSpring = Animation.spring(response: 0.6, dampingFraction: 0.45, blendDuration: 0.1)
    static let backgroundBlur:CGFloat = 250
    static let topPadding: CGFloat = 20
    static let fastBounceAnimation: Animation = .spring(response: 0.2, dampingFraction: 0.8, blendDuration: 0.1)
    
    
    static let fastBounceAnimationNoBounce: Animation = .spring(response: 0.1, dampingFraction: 1, blendDuration: 0.05)
    
    
    struct Colors {
        
        struct Primary {
            static let p50 = Color(hex: "#ebf2fe")
            static let p100 = Color(hex: "#d8e6fd")
            static let p200 = Color(hex: "#b1cdfb")
            static let p300 = Color(hex: "#89b4fa")
            static let p400 = Color(hex: "#629bf8")
            static let p500 = Color(hex: "#3b82f6")
            static let p600 = Color(hex: "#2f69c7")
            static let p700 = Color(hex: "#235097")
            static let p800 = Color(hex: "#183668")
            static let p900 = Color(hex: "#122a50")
        }
        
        struct Orange {
            static let o50 = Color(hex: "#fcf3e5")
            static let o100 = Color(hex: "#fae7cc")
            static let o200 = Color(hex: "#f5cf99")
            static let o300 = Color(hex: "#efb666")
            static let o400 = Color(hex: "#ea9e33")
            static let o500 = Color(hex: "#e58600")
            static let o600 = Color(hex: "#b76b00")
            static let o700 = Color(hex: "#895000")
            static let o800 = Color(hex: "#5c3600")
            static let o900 = Color(hex: "#452800")
        }
        
        struct Red {
            static let r50 = Color(hex: "#ffebea")
            static let r100 = Color(hex: "#ffd8d6")
            static let r200 = Color(hex: "#ffb1ac")
            static let r300 = Color(hex: "#ff8983")
            static let r400 = Color(hex: "#ff6259")
            static let r500 = Color(hex: "#ff3b30")
        }
        
        struct Green {
            static let g50 = Color(hex: "#e5fbec")
            static let g100 = Color(hex: "#ccf7d9")
            static let g200 = Color(hex: "#99efb4")
            static let g300 = Color(hex: "#66e78e")
            static let g400 = Color(hex: "#33df69")
            static let g500 = Color(hex: "#00d743")
        }
        
        struct Grey {
            static let g50 = Color(hex: "#e8e8e8")
            static let g100 = Color(hex: "#d9d9d9")
            static let g200 = Color(hex: "#bcbcbc")
            static let g300 = Color(hex: "#9e9e9e")
            static let g400 = Color(hex: "#818181")
            static let g500 = Color(hex: "#636363")
            static let g600 = Color(hex: "#4f4f4f")
            static let g700 = Color(hex: "#3b3b3b")
            static let g800 = Color(hex: "#282828")
            static let g900 = Color(hex: "#1e1e1e")
        }
        
        struct Transparent {
            struct Black {
                static let b100 = Color(hex: "#0000000a")
                static let b200 = Color(hex: "#00000014")
                static let b300 = Color(hex: "#0000001e")
                static let b400 = Color(hex: "#00000028")
                static let b500 = Color(hex: "#00000033")
            }
            struct White {
                static let w100 = Color(hex: "#ffffff0a")
                static let w200 = Color(hex: "#ffffff14")
                static let w300 = Color(hex: "#ffffff1e")
                static let w400 = Color(hex: "#ffffff28")
                static let w500 = Color(hex: "#ffffff33")
            }
        }
    }
    
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
