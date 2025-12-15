//
//  IsPreviewKey.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 15/12/2025.
//


import Foundation
import SwiftUI

private struct IsPreviewKey: EnvironmentKey {
    static let defaultValue = false
}

extension EnvironmentValues {
    var isPreview: Bool {
        get { self[IsPreviewKey.self] }
        set { self[IsPreviewKey.self] = newValue }
    }
}
