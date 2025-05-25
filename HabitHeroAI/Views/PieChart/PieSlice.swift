//
//  PieSlice.swift
//  HabitHeroAI
//
//  Created by Kalyani Puvvada on 5/23/25.
//

import SwiftUI

struct PieSlice: Shape {
    var startAngle: Angle
    var endAngle: Angle
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(center.x, center.y)/2
        path.addArc(center: center,
                    radius: radius,
                    startAngle: startAngle - Angle(degrees: 90),
                    endAngle: endAngle - Angle(degrees: 90),
                    clockwise: true)
        return path
    }
}
