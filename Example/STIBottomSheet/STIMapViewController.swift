//
//  STIMapViewController.swift
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 27.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

import UIKit
import MapKit
import STIBottomSheet

@objc class STIMapViewController: UIViewController {
    
    var mapView: MKMapView!
    var button: UIButton!
    
    override func loadView() {
        super.loadView()
        let map = MKMapView(frame: view.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(map)
        
        let button = UIButton(frame: .zero)
        button.setTitle("Add Sheet", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.blue, for: .normal)
        view.addSubview(button)
        button.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1).isActive = true
        button.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -8).isActive = true
        button.addTarget(self, action: #selector(addDemoSheet), for: .primaryActionTriggered)
    }
    
    @objc func addDemoSheet() {
        guard let sheetController = self.parent as? STIBottomSheetViewController else {
            fatalError()
        }
        sheetController.addBottomSheet(DemoSheetViewController(), closable: true)
    }
}
