//
//  MovieCollectionLayout.swift
//  MovieApp
//
//  Created by hayrı oguz on 24.10.2020.
//

import UIKit


class MovieCollectionLayout: UICollectionViewFlowLayout {
    var showType: ShowingType = .grid
    private var nOfColumns: CGFloat = 2.0
    private var nOfRows: CGFloat = 3.0
    
    override func prepare() {
        super.prepare()
        guard let collectionView = self.collectionView else {return}

        minimumInteritemSpacing = 4.0
        minimumLineSpacing = 2.0
        sectionInset = .init(top: 4.0, left: 2.0, bottom: 4.0, right: 2.0)
        switch showType {
        case .list:
            nOfColumns = 1
            nOfRows = 5
        case .grid:
            nOfColumns = 2
            nOfRows = 3

        }
        let availableWidth = collectionView.frame.width - sectionInset.left - sectionInset.right - ((nOfColumns - 1) * minimumInteritemSpacing)
        let availableHeight = collectionView.frame.height - sectionInset.bottom - sectionInset.top - ((nOfRows - 1) * minimumLineSpacing)
        
        var cellHeight: CGFloat =  0
        var cellWidth: CGFloat = 0
        switch showType {
        case .list:
            cellHeight = availableHeight * 0.2
            cellWidth = availableWidth
        case .grid:
             cellHeight =  availableHeight * 0.3
             cellWidth = availableWidth * 0.5

        }
        itemSize = .init(width: cellWidth, height: cellHeight)
        
        
    }
}
