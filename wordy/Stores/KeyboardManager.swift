//
//  KeyboardManager.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 08/12/2025.
//




import SwiftUI
import Combine

@MainActor
@Observable
class KeyboardManager {
    var isKeyboardVisible: Bool = false
    @ObservationIgnored private var cancellables: Set<AnyCancellable> = []
    
    init() {

        NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)
            .sink { [weak self] _ in
                
                withAnimation {
                    self?.isKeyboardVisible = true
                }
          
                        
                    
                
                
            }
            .store(in: &cancellables)
        
        NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)
            .sink { [weak self] _ in
                
             
                withAnimation {
                    self?.isKeyboardVisible = false
                }
                
                
                
            }
            .store(in: &cancellables)
    }
    
  
    func dismissKeyboard() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first else { return }
        window.endEditing(true)
    }
    
    deinit {
        cancellables.removeAll()
    }
}
