//
//  EditViewDataSource.swift
//  MotionApp
//
//  Created by konatsu_p on 2020/03/03.
//  Copyright © 2020 konatsup. All rights reserved.
//

import SpreadsheetView

class EditViewDataSource: SpreadsheetViewDataSource {
    let columns = 30
    let rows = 20
    
    let width: CGFloat = 50
    let height: CGFloat = 50
    
    init (){
        
    }
    
    func numberOfColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return columns
    }
    
    func numberOfRows(in spreadsheetView: SpreadsheetView) -> Int {
        return rows
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, widthForColumn column: Int) -> CGFloat {
        return width
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, heightForRow row: Int) -> CGFloat {
        return height
    }
    
    func spreadsheetView(_ spreadsheetView: SpreadsheetView, cellForItemAt indexPath: IndexPath) -> Cell? {
        switch (indexPath.column, indexPath.row) {
        case (0, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: HeaderCell.self), for: indexPath) as! HeaderCell
            print(cell.frame)
            cell.label.text = "aaaa"
            print(cell.frame)
            
            //            cell.sortArrow.text = "uuuuu"
            
            cell.setNeedsLayout()
            
            return cell
        case (1, 0):
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TimeMeterCell.self), for: indexPath) as! TimeMeterCell
            
            cell.contentView.subviews.map{$0.backgroundColor = .orange}
            
            return cell
        default:
            let cell = spreadsheetView.dequeueReusableCell(withReuseIdentifier: String(describing: TextCell.self), for: indexPath) as! TextCell
            cell.label.text = "iiiiadsfafsfsdfas"
            //            cell.sideCellView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            //            cell.sideCellView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            //            cell.addSideCellView(width: width, height: height)
            return cell
        }
    }
    
    func mergedCells(in spreadsheetView: SpreadsheetView) -> [CellRange] {
        return [CellRange(from: (row: 0, column: 1), to: (row: 0, column: columns - 1)),
                CellRange(from: (row: 1, column: 0), to: (row: rows - 1, column: 0)),
                CellRange(from: (row: 1, column: 1), to: (row: rows - 1, column: columns - 1))]
    }
    
    func frozenColumns(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
    
    func frozenRows(in spreadsheetView: SpreadsheetView) -> Int {
        return 1
    }
}

extension EditViewDataSource {
    private enum Const {
        static let heightForRow: CGFloat = 40
        static let separator: CGFloat = 5.0
    }
}
