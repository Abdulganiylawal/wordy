//
//  userStores.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//

import Combine
import SwiftUI

class UserStores:ObservableObject {
    @AppStorage("wantsHaptics") var wantsHaptics:Bool = true
    @AppStorage("wantsSounds") var wantsSounds:Bool = true
}
