//
//  Track.swift
//  GPXAPP
//
//  Created by yasuo on 2021/9/7.
//

import Foundation
import MapKit

struct Track {

    /// 计算距离中心坐标最短的距离和坐标点 时间复杂度O(2n) ~= O(n) 如果追求复杂度为O(n) 可直接在 CoordinatesParser 代理方法中比较
    /// - Parameters:
    ///   - coordinates: 坐标
    ///   - centerCoordinate: 中心坐标
    /// - Returns: 距离中心坐标最短的距离和坐标点
    static func trackMinDistance(coordinates: [CLLocationCoordinate2D], centerCoordinate: CLLocationCoordinate2D) -> (Double,CLLocationCoordinate2D)? {
        
        
        guard var minCoordinate = coordinates.first else {
            return nil
        }
        var minDistance: Double = .infinity

        /// 开始比较
        for coordinate in coordinates {
            let distance = getDistance(coordinate1: coordinate, coordinate2: centerCoordinate)
            if distance < minDistance {
                minCoordinate = coordinate
                minDistance = distance
            }
        }
        /// 结束比较
        
        return (minDistance,minCoordinate)
    }
    
    /// 地球半径
    static let EarthRadius:Double = 6378137.0
    
    //根据两点经纬度计算两点距离
    static func getDistance(coordinate1: CLLocationCoordinate2D,coordinate2: CLLocationCoordinate2D) -> Double {

        autoreleasepool {
            let lat1:Double = radian(d: coordinate1.latitude)
            let lat2:Double = radian(d: coordinate2.latitude)
            
            let lng1:Double = radian(d: coordinate1.longitude)
            let lng2:Double = radian(d: coordinate2.longitude)
     
            let a:Double = lat1 - lat2
            let b:Double = lng1 - lng2
            
            var s:Double = 2 * asin(sqrt(pow(sin(a/2), 2) + cos(lat1) * cos(lat2) * pow(sin(b/2), 2)))
            s = s * EarthRadius
            return s
        }

    }
    
    
    //根据角度计算弧度
    static func radian(d:Double) -> Double {
         return d * Double.pi/180.0
    }
}

struct Parser {
    private let coordinateParser = CoordinatesParser()
    
    /// 获取轨迹文件路径
    /// - Parameter fileName: 文件名称
    /// - Returns: 文件路径
    private func getGPXPath(fileName: String) -> String? {
        let path = Bundle.main.path(forResource: fileName, ofType: "gpx")
        return path
    }

    
    /// 获取轨迹文件中的坐标数组
    /// - Parameter fileName: 文件名称
    /// - Returns: 轨迹坐标数组
    func parseCoordinates(fromGpxFile fileName: String) -> [CLLocationCoordinate2D]? {
        guard let filePath = getGPXPath(fileName: fileName) else {
            return nil
        }
        guard let data = FileManager.default.contents(atPath: filePath) else { return nil }
    
        coordinateParser.prepare()
    
        let parser = XMLParser(data: data)
        parser.delegate = coordinateParser

        let success = parser.parse()
    
        guard success else { return nil }
        return coordinateParser.coordinates
    }
}

class CoordinatesParser: NSObject, XMLParserDelegate  {
    private(set) var coordinates = [CLLocationCoordinate2D]()

    /// 初始化坐标数组
    func prepare() {
        coordinates = [CLLocationCoordinate2D]()
    }

    /// 代理方法,或者文件中的坐标 时间复杂度O(n)
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        guard elementName == "trkpt" || elementName == "wpt" else { return }
        guard let latString = attributeDict["lat"], let lonString = attributeDict["lon"] else { return }
        guard let lat = Double(latString), let lon = Double(lonString) else { return }
        guard let latDegrees = CLLocationDegrees(exactly: lat), let lonDegrees = CLLocationDegrees(exactly: lon) else { return }
        coordinates.append(CLLocationCoordinate2D(latitude: latDegrees, longitude: lonDegrees))
    }
}

