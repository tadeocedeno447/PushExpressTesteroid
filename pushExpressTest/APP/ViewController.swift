//
//  ViewController.swift
//  pushExpressTest
//
//  Created by D K on 01.10.2024.
//

import SwiftUI

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showGame()
                
                func showGame() {
                    let mainView = SwiftUIView()
                    let hostingController = UIHostingController(rootView: mainView)
                    
                    addChild(hostingController)
                    view.addSubview(hostingController.view)
                    hostingController.didMove(toParent: self)
                    
                    hostingController.view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        hostingController.view.topAnchor.constraint(equalTo: view.topAnchor),
                        hostingController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                        hostingController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                        hostingController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor)
                    ])
                }
    }


}

