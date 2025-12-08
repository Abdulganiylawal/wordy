


import SwiftUI

struct CustomTextStyle: ViewModifier {
    enum Weight: String {
        case regular 
        case medium 
        case semiBold 
        case bold 
    }

    var color: Color
    var size: CGFloat
    var weight: Font.Weight

    func body(content: Content) -> some View {
        content
            .font(.system(size: size, weight: weight))
            .fontDesign(.rounded)
            .foregroundStyle(color)
    }
}

extension View {
    func customTextStyle(color: Color, size: CGFloat = 14, weight: Font.Weight) -> some View {
        self.modifier(CustomTextStyle(color: color, size: size, weight: weight))
    }
}
