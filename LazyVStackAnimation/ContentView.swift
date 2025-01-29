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
            Button("Append") {
                let lastValue = numbers.last ?? -1
                numbers.append(lastValue+1)
            }
            .padding()

            ListView(
                numbers: $numbers,
                onTapNumber: { number in
                    if let index = numbers.firstIndex(where: { $0 == number }) {
                        numbers.remove(at: index)
                    }
                }
            )

            Spacer()
        }
    }
}

struct ListView: View {
    @Binding var newNumbers: [Int]
    @State private var numbers: [Int]
    let onTapNumber: (Int) -> Void
    
    init(numbers: Binding<[Int]>, onTapNumber: @escaping (Int) -> Void) {
        self._newNumbers = numbers
        self.numbers = numbers.wrappedValue
        self.onTapNumber = onTapNumber
    }
    
    var body: some View {
        LazyVStack {
            ForEach(numbers, id: \.self) { number in
                Text(String(number))
                    .padding()
                    .background(
                        Color.mint,
                        ignoresSafeAreaEdges: .horizontal
                    )
                    .transition(.opacity)
                    .onTapGesture { onTapNumber(number) }
            }
        }
        .onChange(of: newNumbers, initial: false) {
            if newNumbers.count < numbers.count {
                withAnimation(.easeInOut(duration: 1.0)) {
                    // Works when only one item is removed at once
                    if let index = numbers.indices.first(where: {
                        numbers[$0] != newNumbers[safe: $0]
                    }) {
                        numbers.remove(at: index)
                    }
                }
            } else {
                numbers = newNumbers
            }
        }
    }
}

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

#Preview {
    ContentView()
}
