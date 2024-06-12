//
//  ColorBGView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 6/10/24.
//

import SwiftUI

struct ColorBGView: View {
    @State private var positions: [CGPoint] = []
    @State private var colors: [Color] = []
    @State private var timer: Timer?

    let ellipseCount = 5
    let animationDuration: Double = 5.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ForEach(0..<ellipseCount, id: \.self) { index in
                    Circle()
                        .fill(self.colors[safe: index] ?? Color.clear)
                        .frame(width: 200, height: 200)
                        .blur(radius: 100)
                        .position(self.positions[safe: index] ?? CGPoint.zero)
                }
            }
            .onAppear {
                self.initializePositionsAndColors(in: geometry.size)
                self.startTimer(in: geometry.size)
            }
            .onDisappear {
                self.stopTimer()
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    private func initializePositionsAndColors(in size: CGSize) {
        positions = (0..<ellipseCount).map { _ in randomPosition(in: size) }
        colors = (0..<ellipseCount).map { _ in randomColor() }
    }

    private func randomPosition(in size: CGSize) -> CGPoint {
        CGPoint(
            x: CGFloat.random(in: 0...size.width),
            y: CGFloat.random(in: 0...size.height)
        )
    }

    private func randomColor() -> Color {
        Color(
            hue: Double.random(in: 0...1),
            saturation: Double.random(in: 0.8...1),
            brightness: Double.random(in: 0.8...1)
        )
    }

    private func startTimer(in size: CGSize) {
        timer = Timer.scheduledTimer(withTimeInterval: animationDuration, repeats: true) { _ in
            withAnimation(.easeInOut(duration: self.animationDuration)) {
                for index in 0..<self.ellipseCount {
                    self.positions[index] = self.randomPosition(in: size)
                    self.colors[index] = self.randomColor()
                }
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ColorBGView()
}
