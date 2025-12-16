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
    private let tickWidth: CGFloat = 2
    private let tickSpacing: CGFloat = 6
    private let horizontalPadding: CGFloat = 180

    var body: some View {
        VStack(spacing: 12) {


            Text(selectedTime.formatted(date: .omitted, time: .shortened))
                .customTextStyle(color: AppColors.textInverted(colorScheme: colorScheme), size: 46, weight: .bold)
                .contentTransition(.numericText())
                .padding(.top)

            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: tickSpacing) {
                    ForEach(0..<minutesInDay, id: \.self) { minute in
                        tick(minute)
                            .id(minute)
                    }
                }
                .padding(.horizontal, horizontalPadding)
                .scrollTargetLayout()
            }
     
            .scrollPosition(id: $scrollMinute, anchor: .center)
            
            .onChange(of: scrollMinute) { _, newValue in
                guard let minute = newValue else { return }
                 let impact = UIImpactFeedbackGenerator(style: .soft)
                impact.impactOccurred(intensity: 0.5)
                withAnimation {
                    selectedTime = dateFromMinute(minute)
                }
              
            }
            .onAppear {
                scrollMinute = minuteFromDate(selectedTime)
            }
            .frame(height: 150)
            .overlay(selectionIndicator, alignment: .center)
        }
        .frame(width: 360)
        .cardBackgroundWithTransitionStyle(radius: 25, transition: nil)
    }

    // MARK: - Tick

    @ViewBuilder
    private func tick(_ minute: Int) -> some View {
        let isHour = minute % 60 == 0

        VStack(spacing: 6) {
            Rectangle()
                .fill(isHour ? .primary : .secondary)
                .frame(
                    width: tickWidth,
                    height: isHour ? 24 : 12
                )

            if isHour {
                Text("\(minute / 60)")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
        }
    }

    // MARK: - Selection Indicator

    private var selectionIndicator: some View {
        Rectangle()
            .fill(Color.red)
            .frame(width: 2, height: 40)
    }

    // MARK: - Date ↔︎ Minute Mapping

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
