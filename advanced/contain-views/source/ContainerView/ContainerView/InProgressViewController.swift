//
//  InProgressViewController.swift
//  ContainerView
//
//  Created by Jonathan Rasmusson (Contractor) on 2019-09-27.
//  Copyright © 2019 Jonathan Rasmusson. All rights reserved.
//

import UIKit

class ActivatingViewController: UIViewController {

    typealias responder = ContainerViewControllerResponder

    override func viewDidLoad() {
        view.backgroundColor = .cyan

        let titleLabel = makeLabel(withTitle: "Activating")
        let activateButton = makeButton(withText: "Activate")
        let cancelButton = makeButton(withText: "Cancel")

        // responder chain
        activateButton.addTarget(nil, action: #selector(responder.didPressPrimaryCTAButton(_:)), for: .primaryActionTriggered)
        cancelButton.addTarget(nil, action: #selector(responder.didPressSecondaryCTAButton(_:)), for: .primaryActionTriggered)

        view.addSubview(titleLabel)
        view.addSubview(activateButton)
        view.addSubview(cancelButton)

        titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24).isActive = true
        titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        activateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activateButton.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true

        cancelButton.topAnchor.constraint(equalTo: activateButton.bottomAnchor, constant: 8).isActive = true
        cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
}

