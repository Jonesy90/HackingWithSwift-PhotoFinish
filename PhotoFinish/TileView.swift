//
//  TileView.swift
//  PhotoFinish
//
//  Created by Michael Jones on 23/08/2025.
//

import SwiftUI

struct TileView: View {
    var tileSize: Double
    var offset: CGSize
    var image: Image?
    
    var body: some View {
        if let image {
            image
                .resizable()
                .frame(width: tileSize, height: tileSize)
                .offset(offset)
        } else {
            Color.clear
        }
    }
}

#Preview {
    TileView(tileSize: 60, offset: .zero, image: .init(systemName: "1.circle"))
}
