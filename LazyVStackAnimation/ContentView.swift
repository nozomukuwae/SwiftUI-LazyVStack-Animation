//
//  ContentView.swift
//  LazyVStackAnimation
//
//  Created by Nozomu Kuwae on 2025/01/27.
//

import SwiftUI

struct ContentView: View {
    @State private var numbers = Array(0..<3)
    
    var body: some View {
        VStack {
            LazyVStack {
                Button("Append") {
                    let lastValue = numbers.last ?? -1
                    numbers.append(lastValue+1)
                }
                .padding()
                
                ForEach(numbers, id: \.self) { number in
                    Text(String(number))
                        .padding()
                        .background(
                            Color.mint,
                            ignoresSafeAreaEdges: .horizontal
                        )
                        .onTapGesture {
                            if let index = numbers.firstIndex(where: { $0 == number }) {
                                numbers.remove(at: index)
                            }
                        }
                }
            }
            .animation(.easeIn(duration: 1.0), value: numbers)

            Spacer()
        }
    }
}

#Preview {
    ContentView()
}
