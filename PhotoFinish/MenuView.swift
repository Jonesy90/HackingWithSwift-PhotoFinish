//
//  MenuView.swift
//  PhotoFinish
//
//  Created by Michael Jones on 23/08/2025.
//

import SwiftUI
import PhotosUI

struct MenuView: View {
    /// Import photos from the system.
    @State private var selectedItem: PhotosPickerItem?
    
    /// SwiftUI Images to be loaded.
    @State private var gridImages = [Image]()
    
    /// Selected Image as a UIImage.
    @State private var selectedImage: UIImage?
    
    /// The chosen grid size.
    @State private var gridSize = 3
    
    var body: some View {
        NavigationStack {
            Form {
                /// Picker for the user to select the size of the grid.
                Picker("Size", selection: $gridSize) {
                    Text("Small").tag(3)
                    Text("Medium").tag(4)
                    Text("Large").tag(5)
                    Text("Epic").tag(6)
                    Text("Gigantic").tag(7)
                }
                
                PhotosPicker("Select Image", selection: $selectedItem, matching: .images)
                
                Section {
                    NavigationLink("Start", value: true)
                        .disabled(gridImages.isEmpty)
                }
            }
            .navigationTitle("PhotoFinish")
        }
    }
    
    
    /// Passes whatever picture the user selects and convert it into a square.
    /// - Parameter image: Passes in the image the user selects.
    /// - Returns: Returns a cropped rectangle of the passed in image.
    func cropToSquare(image: UIImage) -> UIImage {
        /// Find the shortest side length.
        let sideLength = min(image.size.width, image.size.height)
        
        /// Calculates the X and Y offsets. So we crop to the squares centre.
        /// This helps provide a cropped rectangle.
        let x = (image.size.width - sideLength) / 2
        let y = (image.size.height - sideLength) / 2
        let cropRect = CGRect(x: x, y: y, width: sideLength, height: sideLength)
        
        guard let cgImage = image.cgImage?.cropping(to: cropRect) else { return image }
        
        return UIImage(cgImage: cgImage)
    }
    
    /// Fill the pieces array full of SwiftUI images, each storing one small part of the entire Image.
    /// - Parameter gridSize: Allocated grid size.
    func splitImageIntoGrid(gridSize: Int) {
        /// Makes sure we have selected an image. If not, bail out.
        guard let selectedImage else { return }
        
        /// converts the selectedImage into a square image using 'cropToSquare' method.
        let squareImage = cropToSquare(image: selectedImage)
        
        /// the correct size of each tile in proportion to the entire square image, based on the grid.
        let pieceSize = squareImage.size.width / CGFloat(gridSize)
        
        var pieces = [Image]()
        
        for row in 0..<gridSize {
            for col in 0..<gridSize {
                /// Calculate the rectangle we're cropping to based on the row, column and piece size.
                let x = Double(col) * pieceSize
                let y = Double(row) * pieceSize
                let rect = CGRect(x: x, y: y, width: pieceSize, height: pieceSize)
                
                /// performing the actual crop using the underlying CGImage.
                /// convert it into a SwiftUI Image and put it into the array.
                if let cgImage = squareImage.ciImage?.cropped(to: rect) {
                    let pieceImage = UIImage(ciImage: cgImage)
                    pieces.append(Image(uiImage: pieceImage))
                }
            }
        }
        
        gridImages = pieces
    }
}

#Preview {
    MenuView()
}
