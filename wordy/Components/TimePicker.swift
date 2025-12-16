//
//  TimePicker.swift
//  wordy
//
//  Created by ABDULGANIY LAWAL on 16/12/2025.
//



import SwiftUI

struct TimePicker: View {
    @State private var selectedTime: Date = .now
    @State private var scrollMinute: Int?
    @Environment(\.colorScheme) var colorScheme
    private let minutesInDay = 24 * 60
    private let tickWidth: CGFloat = 4
    private let tickSpacing: CGFloat = 6
    private let horizontalPadding: CGFloat = 180
    
    @State private var selectedMinutes:[Int] = []
    var body: some View {
        VStack(spacing: 12) {
            
            Text("Notification Time")
                .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 16, weight: .medium)
                .padding(.top)
            
            Text(selectedTime.formatted(date: .omitted, time: .shortened))
                .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 46, weight: .bold)
                .contentTransition(.numericText())
             
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(alignment:.bottom, spacing: tickSpacing) {
                    ForEach(0..<minutesInDay, id: \.self) { minute in
                        tick(minute)
                            .id(minute)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .scrollTargetLayout()
            }
//            .scrollTargetBehavior(.paging)
//            .overlay(alignment: .center) {
//                VStack {
//                    Spacer()
//                    selectionIndicator
//                }
//            }
            .padding(.bottom,40)
            
            .scrollPosition(id: $scrollMinute, anchor: .center)
            
            .onChange(of: scrollMinute) { _, newValue in
                guard let minute = newValue else { return }
                let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.impactOccurred(intensity: 0.5)
                withAnimation {
                    selectedTime = dateFromMinute(minute)
                    getSelectedMinutes(scrollMinute: minute)
                }
                
            }
            .onAppear {
                scrollMinute = minuteFromDate(selectedTime)
            }
            .frame(height: 150)
           
        }
        .frame(width: 360)
        .cardBackgroundWithTransitionStyle(radius: 25, transition: nil)
    }
    
    // MARK: - Tick
    
    @ViewBuilder
    private func tick(_ minute: Int) -> some View {
//        let isHour = minute % 60 == 0
        
        VStack(spacing: 6) {
            Capsule()
                .fill(calculateColor(for: selectedMinutes, selectedMinute: minute))
                .frame(
                    width: tickWidth,
                    height: calculateHeight(for: selectedMinutes, selectedMinute: minute)
                )
                .animation(.easeInOut, value: selectedMinutes.contains(minute))
            
            //            if isHour {
            //                Text("\(minute / 60)")
            //                    .font(.caption2)
            //                    .foregroundStyle(.secondary)
            //            }
        }
    }
    
    
    
    
    // MARK: - Selection Indicator
    
    private var selectionIndicator: some View {
        Capsule()
            .fill(Color.blue.opacity(0.7))
            .frame(width: 7, height: 40)
    }
    
    private func getSelectedMinutes(scrollMinute: Int) {
        
        guard scrollMinute < minutesInDay && scrollMinute >= 0 else { return }
        
        let previous1 = max(scrollMinute - 1, 0)
        let previous2 = max(scrollMinute - 2, 0)
        let next1 = min(scrollMinute + 1, minutesInDay - 1)
        let next2 = min(scrollMinute + 2, minutesInDay - 1)
        
        selectedMinutes = [scrollMinute, previous1, previous2, next1, next2].sorted()
        debugLog(selectedMinutes)
    }
    
    private func calculateHeight(for minutes: [Int],selectedMinute: Int) -> CGFloat {
        if minutes.contains(selectedMinute) {
            if selectedMinute == scrollMinute {
                return 24
            }else {
                return 12
            }
        } else {
            return 5
        }
    }
    
    private func calculateColor(for minutes: [Int],selectedMinute: Int) -> Color {
        if minutes.contains(selectedMinute) {
            if selectedMinute == scrollMinute {
                return .blue
            }else {
                return .gray.opacity(0.5)
            }
        } else {
            return .gray.opacity(0.3)
        }
    }
    
    
    private func minuteFromDate(_ date: Date) -> Int {
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        return (components.hour ?? 0) * 60 + (components.minute ?? 0)
    }
    
    private func dateFromMinute(_ minute: Int) -> Date {
        let hour = minute / 60
        let min = minute % 60
        
        return Calendar.current.date(
            bySettingHour: hour,
            minute: min,
            second: 0,
            of: selectedTime
        ) ?? selectedTime
    }
}

#Preview {
    TimePicker()
}
