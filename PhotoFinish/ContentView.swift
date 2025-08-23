//
//  ContentView.swift
//  PhotoFinish
//
//  Created by Michael Jones on 23/08/2025.
//

import SwiftUI

struct ContentView: View {
    ///
    enum MoveDirection {
        case up, down, left, right
    }
    
    var gridSize: Int
    var tileSize: Double
    var columns: [GridItem]
    
    @State private var images: [Image?]
    
    /// Used to track how much the user dragged on the screen. Starting from zero.
    /// This is the value that will be passed into the TileView.
    @State private var dragOffset = CGSize.zero
    
    /// Keeps track of the tile being dragged.
    @State private var dragTileIndex: Int? = nil
    
    var body: some View {
        LazyVGrid(columns: columns, spacing: 2) {
            ForEach(0..<gridSize * gridSize, id: \.self) { index in
                TileView(
                    tileSize: tileSize,
                    offset: dragTileIndex == index ? dragOffset : .zero,
                    image: images[index]
                )
                /// Adding a drag gesture to the TileView, which will update dragOffset as the user moves their finger on the screen.
                /// dragGesture will go back to zero when the lifts their finger off the screen.
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            dragOffset = value.translation
                            dragTileIndex = index
                        }
                        .onEnded { value in
                            dragOffset = .zero
                        }
                )
            }
        }
        /// Once the view loads, it will automatically run the shuffleTiles method.
        .onAppear(perform: shuffleTiles)
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
