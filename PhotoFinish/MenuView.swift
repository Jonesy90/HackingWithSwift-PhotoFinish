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
}

#Preview {
    MenuView()
}
