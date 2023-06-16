//
//  FlowController.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 16.06.2023.
//

import Foundation

protocol FlowController: class {
    
    associatedtype T
    var completionHandler: ((T)->())? { get set }
}
