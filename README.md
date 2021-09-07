# TrackLoaction
计算轨迹track.gpx上到点(latitude:30.614791, longitude:104.141420)最近距离以及该点坐标，并给出其时间复杂度。

入口: ViewController.swift

核心: Track.swift


### 解析
- 获取 track.gpx 中经纬度   (时间复杂度O(n))
- 遍历经纬度数组 计算与中心经纬度距离 较小的留下,大的舍弃   (时间复杂度O(n))
- 输出 轨迹track.gpx上到点(latitude:30.614791, longitude:104.141420)最近距离以及该点坐标

可综合1,2步  在获取 track.gpx 中经纬度  直接 计算与中心经纬度距离 较小的留下,大的舍弃   (时间复杂度O(n))
