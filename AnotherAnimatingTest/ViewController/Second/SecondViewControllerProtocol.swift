//
//  SecondViewControllerProtocol.swift
//  AnotherAnimatingTest
//
//  Created by Данила Бердников on 21.09.2023.
//

import UIKit

protocol SecondViewControllerProtocol: UIViewController, SecondViewDelegate {

    var calendarView: SecondView! { get }

}
