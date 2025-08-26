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
//                            dragOffset = value.translation
                            dragOffset = getConstrainedOffset(for: index, translation: value.translation)
                            dragTileIndex = index
                        }
                        .onEnded { value in
                            handleDragEnded(tileIndex: index, translation: getConstrainedOffset(for: index, translation: value.translation))
                            dragOffset = .zero
                        }
                )
            }
        }
        /// Once the view loads, it will automatically run the shuffleTiles method.
        .onAppear(perform: shuffleTiles)
    }
    
    init(gridSize: Int, images: [Image?]) {
        self.gridSize = gridSize
        tileSize = 356 / Double(gridSize)
        columns = Array(repeating: GridItem(.fixed(tileSize), spacing: 2), count: gridSize)
        
        _images = State(initialValue: images)
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
    
    
    /// Returns a valid move direction from a tileIndex.
    /// - Parameter tileIndex: The tile index location.
    /// - Returns: Returns a valid move direction using MoveDirection enum.
    func getValidMoveDirection(for tileIndex: Int) -> MoveDirection? {
        /// finds where the empty tile is.
        let emptyIndex = images.firstIndex(of: nil)!
        /// gets all the indices which are adjacent to the empty tile.
        let adjacentToEmpty = getAdjacentIndices(for: emptyIndex)
        
        /// checks if tileIndex is within the list of indexes which are adjacent to the empty tile.
        /// if it is not, bail out and return nil.
        guard adjacentToEmpty.contains(tileIndex) else { return nil }
        
        let tileRow = tileIndex /  gridSize
        let tileCol = tileIndex % gridSize
        let emptyRow = emptyIndex / gridSize
        let emptyCol = emptyIndex % gridSize
        
        if tileRow == emptyRow {
            return tileCol < emptyCol ? MoveDirection.right : MoveDirection.left
        } else {
            return tileRow < emptyRow ? MoveDirection.down : MoveDirection.up
        }
    }
    
    
    /// Ensures the user drags the tile piece within the limited range from the tile start position to the empty tiles position.
    /// - Parameters:
    ///   - tileIndex: The chosen tile to be moved.
    ///   - translation: How far the tile has moved.
    /// - Returns: The final end position of the moved tile.
    func getConstrainedOffset(for tileIndex: Int, translation: CGSize) -> CGSize {
        ///
        guard let direction = getValidMoveDirection(for: tileIndex) else {
            return .zero
        }
        
        /// Provides an extra bit of spacing around each tile.
        let sizePlusSpacing = tileSize + 2
        
        ///
        switch direction {
        case .up:
            return CGSize(width: 0, height: translation.height.clamped(in: -sizePlusSpacing...0))
        case .down:
            return CGSize(width: 0, height: translation.height.clamped(in: 0...sizePlusSpacing))
        case .left:
            return CGSize(width: translation.width.clamped(in: -sizePlusSpacing...0), height: 0)
        case .right:
            return CGSize(width: translation.width.clamped(in: 0...sizePlusSpacing), height: 0)
        }
        
    }
    
    
    /// Triggers when the user has moved it within half a tile size.
    /// - Parameters:
    ///   - tileIndex: The chosen tile to be moved.
    ///   - translation: How far the tile has moved.
    func handleDragEnded(tileIndex: Int, translation: CGSize) {
        ///
        guard let direction = getValidMoveDirection(for: tileIndex) else {
            return
        }
        
        /// gets us the absolute value of numbers.
        let dragDistance = switch direction {
        case .up, .down:
            abs(translation.height)
        case .left, .right:
            abs(translation.width)
        }
        
        /// If the drag distance is more than half way through the endpoint location. Snap it into place.
        if dragDistance > tileSize * 0.5 {
            let emptyIndex = images.firstIndex(of: nil)!
            images.swapAt(tileIndex, emptyIndex)
        }
    }
    
    
}

#Preview {
    let gridSize = 3
    let startImages = (0..<gridSize * gridSize).dropLast().map { Image(systemName: "\($0).circle")} + [nil]
    
    ContentView(gridSize: 3, images: startImages)
}
