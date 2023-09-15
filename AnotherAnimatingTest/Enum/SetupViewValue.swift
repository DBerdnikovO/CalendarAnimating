//
//  SetupViewValue.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 14.06.2023.
//

import UIKit

struct ViewZoomLayouts {
    
    let itemSize: NSCollectionLayoutSize?
    let groupSize: NSCollectionLayoutSize?
    
}

enum ViewZoom {
    
    case first
    case second
    
    var layouts: ViewZoomLayouts {
        switch self {
        case .first:
            return ViewZoomLayouts(itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3),
                                                                    heightDimension: .fractionalHeight(1)),
                                   groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                     heightDimension: .fractionalHeight(0.18)))
        case .second:
            return ViewZoomLayouts(itemSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                                    heightDimension: .fractionalHeight(1))
                                   , groupSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                                       heightDimension: .fractionalHeight(0.54)))
        }
    }
    
}
