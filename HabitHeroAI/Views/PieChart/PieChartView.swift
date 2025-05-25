//
//  PieChartView.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/23/25.
//

import SwiftUI

struct PieChartView: View {
    var percentage: Double
    @State private var animatedPercentage = 0.0
    var body: some View {
        ZStack {
            PieSlice(
                startAngle: .degrees(0),
                endAngle: .degrees(360)
            )
            .fill(Color.gray.opacity(0.5))
            PieSlice(
                startAngle: .degrees(0),
                endAngle: .degrees(percentage * 360)
            )
            .fill(Color.green)
            .animation(.easeOut(duration: 1.0), value: percentage)
            VStack {
                Text("\(Int(percentage * 100))%")
                    .font(.largeTitle.bold())
                Text("Completed")
                    .font(.caption)
            }
        }
        .frame(width: 200, height: 200)
        .onAppear {
            animatedPercentage = 0 // ensure reset
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                animatedPercentage = percentage
            }
        }
    }
}

#Preview {
    PieChartView(percentage: 0.7)
}
