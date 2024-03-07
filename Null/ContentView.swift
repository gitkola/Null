import SwiftUI

struct ContentView: View {
    let numberOfVerticalScreens = 5
    let numberOfHorizontalScreens = 5
    @State private var verticalOffset: CGFloat = 0
    @State private var currentVerticalIndex: Int = 0

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                VStack(spacing: 0) {
                    ForEach(0..<numberOfVerticalScreens, id: \.self) { index in
                        HorizontalSwipeView(numberOfScreens: numberOfHorizontalScreens)
                            .frame(width: geometry.size.width, height: geometry.size.height)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height, alignment: .top)
                .offset(y: -verticalOffset)
                .gesture(
                    DragGesture().onEnded({ value in
                        let screenHeight = geometry.size.height
                        let verticalMovement = value.translation.height
                        let cardIndexChange = verticalMovement / screenHeight
                        
                        if cardIndexChange < 0 && currentVerticalIndex < numberOfVerticalScreens - 1 {
                            currentVerticalIndex += 1
                        } else if cardIndexChange > 0 && currentVerticalIndex > 0 {
                            currentVerticalIndex -= 1
                        }
                        
                        withAnimation(.easeOut) {
                            verticalOffset = CGFloat(currentVerticalIndex) * screenHeight
                        }
                    })
                )
                
                VStack {
                    Spacer()
                    ForEach(0..<numberOfVerticalScreens, id: \.self) { index in
                        Circle()
                            .fill(index == currentVerticalIndex ? Color.white : Color.gray)
                            .frame(width: 8, height: 8)
                            .padding(.vertical, 2)
                    }
                    Spacer()
                }
                .padding(.leading, 10)
            }
        }
        .edgesIgnoringSafeArea(.all)
    }
}

struct HorizontalSwipeView: View {
    let numberOfScreens: Int

    var body: some View {
        TabView {
            ForEach(0..<numberOfScreens, id: \.self) { _ in
                ScreenView()
            }
        }
        .tabViewStyle(PageTabViewStyle())
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct ScreenView: View {
    let color: Color = .random

    var body: some View {
        Rectangle()
            .foregroundColor(color)
            .ignoresSafeArea()
    }
}

extension Color {
    static var random: Color {
        return Color(
            red: .random(in: 0...1),
            green: .random(in: 0...1),
            blue: .random(in: 0...1),
            opacity: 1.0
        )
    }
}
