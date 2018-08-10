//
//  STIMapViewController.swift
//  STIBottomSheet
//
//  Created by Sven Titgemeyer on 27.07.18.
//  Copyright © 2018 Sven Titgemeyer. All rights reserved.
//

import UIKit
import MapKit

@objc class STIMapViewController: UIViewController {
    
    var mapView: MKMapView!
    
    override func loadView() {
        super.loadView()
        let map = MKMapView(frame: view.bounds)
        map.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(map)
        
//        let blurview = UIVisualEffectView(effect: UIBlurEffect(style: .light))
//        blurview.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(blurview)
//        blurview.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
//        blurview.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
//        blurview.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
//        blurview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
    }
}
