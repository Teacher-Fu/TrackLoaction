//
//  ViewController.swift
//  GPXAPP
//
//  Created by yasuo on 2021/9/7.
//

import UIKit
import MapKit

// 计算轨迹track.gpx上到点(latitude:30.614791, longitude:104.141420)最近距离以及该点坐标，并给出其时间复杂度。

class ViewController: UIViewController {
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let parser = Parser()
        let centerCoordinat = CLLocationCoordinate2D(latitude: 30.614791, longitude: 104.141420)
        let gpxs =  parser.parseCoordinates(fromGpxFile: "track")
        let trackDistance = Track.trackMinDistance(coordinates: gpxs ?? [], centerCoordinate: centerCoordinat)
        guard let trackSet = trackDistance else { return }
        
        distanceLabel.text = "\(trackSet.0) m"
        locationLabel.text = "\(trackSet.1)"
        
        print("中心点\(centerCoordinat)")
        print("距离中心点最近的距离是 \(trackSet.0) m")
        print("距离中心点最近的坐标点是 \(trackSet.1) ")

    }


}



