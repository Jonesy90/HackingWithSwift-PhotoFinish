//
//  ContentView.swift
//  PhotoFinish
//
//  Created by Michael Jones on 23/08/2025.
//

import SwiftUI

struct ContentView: View {
    var gridSize: Int
    var tileSize: Double
    var columns: [GridItem]
    
    @State private var images: [Image?]
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<gridSize * gridSize, id: \.self) { index in
                TileView(tileSize: tileSize, offset: .zero, image: images[index])
            }
        }
    }
    
    init(gridSize: Int = 3) {
        self.gridSize = gridSize
        tileSize = 356 / Double(gridSize)
        columns = Array(repeating: GridItem(.fixed(tileSize), spacing: 2), count: gridSize)
        
        let startImages = (0..<gridSize * gridSize).dropLast().map { Image(systemName: "\($0).circle")} + [nil]
        _images = State(initialValue: startImages)
    }
    
    /// Will find all possible grid locations next to one grid location.
    /// - Parameter index: The index within the grid.
    /// - Returns: An array of all the valid indexes in the grid.
    func getAdjacentIndices(for index: Int) -> [Int] {
        let row = index / gridSize
        let col = index % gridSize
        
        var adjacent = [Int]()
        
        if row > 0 { adjacent.append(index - gridSize) }
        if row < gridSize - 1 { adjacent.append(index + gridSize) }
        if col > 0 { adjacent.append(index - 1) }
        if col < gridSize - 1 { adjacent.append(index + 1) }
        
        return adjacent
    }
    
    /// Finds where the empty square is within the grid, finds the indexes in the squares around the empty square, pick a random index from there and swap that square with the empty square.
    func shuffleTiles() {
        for _ in 0..<1000 {
            /// Finds where the empty tile is.
            let emptyIndex = images.firstIndex(of: nil)!
            
            /// Reads the squares around the empty square to give us an [Int] of possible moves.
            let possibleMoves = getAdjacentIndices(for: emptyIndex)
            
            /// Gets a random Int from the [Int] of possibleMoves and swaps the tiles.
            if let randomMove = possibleMoves.randomElement() {
                images.swapAt(emptyIndex, randomMove)
            }
        }
    }
    
    
}

#Preview {
    ContentView()
}
