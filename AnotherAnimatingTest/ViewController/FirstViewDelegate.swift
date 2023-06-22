//
//  FirstViewDelegate.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 22.06.2023.
//

import Foundation

protocol FirstViewDelegate: AnyObject {
    func didSelectCell(cell: TextCell)
}
