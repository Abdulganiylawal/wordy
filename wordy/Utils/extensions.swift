import Foundation
import SwiftUI

extension View {
    @ViewBuilder
    func modifier<Content: View>(if condition: Bool, animation: Animation = .default, modify: (Self) -> Content) -> some View {
        Group {
            if condition {
                modify(self)
            } else {
                self
            }
        }
        .animation(animation, value: condition)
    }
    
    func cardBackgroundWithTransitionStyle(radius:CGFloat,transition:Namespace.ID?) -> some View {
        self.modifier(CardBackgroundWithTransition(radius: radius, transition: transition))
    }


    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
                    .transition(.opacity)
                    .animation(.easeInOut(duration: 0.25), value: shouldShow)
            }
            self
        }
    }
}



extension JSONDecoder {
    /// Decodes with detailed error logging for all `DecodingError` cases.
    /// Throws user-friendly messages while logging technical details.
    func decodeLoggingErrors<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decode(type, from: data)
        } catch let decodingError as DecodingError {
            switch decodingError {
            case let .dataCorrupted(context):
                debugLog("Decoding error - Data corrupted: \(context)")
            case let .keyNotFound(key, context):
                debugLog("Decoding error - Key '\(key)' not found: \(context.debugDescription)")
                debugLog("codingPath: \(context.codingPath)")
            case let .valueNotFound(_, context):
                debugLog("Decoding error - Value not found: \(context.debugDescription)")
                debugLog("codingPath: \(context.codingPath)")
            case let .typeMismatch(type, context):
                debugLog("Decoding error - Type '\(type)' mismatch: \(context.debugDescription)")
                debugLog("codingPath: \(context.codingPath)")
            @unknown default:
                debugLog("Decoding error - Unknown case: \(decodingError)")
            }
            throw NSError(
                domain: "DecodingError",
                code: 100,
                userInfo: [NSLocalizedDescriptionKey: "Unable to decode data. Please try again."]
            )
        } catch {
            debugLog("Decoding error: \(error)")
            throw NSError(
                domain: "DecodingError",
                code: 101,
                userInfo: [NSLocalizedDescriptionKey: "Failed to process data. Please try again."]
            )
        }
    }
}

