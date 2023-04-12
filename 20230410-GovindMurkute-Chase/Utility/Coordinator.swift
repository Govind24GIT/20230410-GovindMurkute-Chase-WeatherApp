//
//  Coordinator.swift
//  20230410-GovindMurkute-Chase
//
//  Created by Govind Murkute on 11/04/23.
//

import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    var coordinator: [Coordinator] { get set }

    func start()
}
