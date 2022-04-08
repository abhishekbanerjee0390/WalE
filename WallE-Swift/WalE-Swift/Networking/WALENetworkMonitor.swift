//
//  WALENetworkMonitor.swift
//  WalE-Swift
//
//  Created by Abhishek Banerjee on 06/04/22.
//


import Network

typealias WALENetworkStatusChanged = (_ isConnected: Bool) -> Void


protocol WALENetworkMonitorProtocol {
    
    var isConnected: Bool { get }
    func startMonitoringNetwork(_ statusChanged: @escaping WALENetworkStatusChanged)
}


struct WALENetworkMonitor: WALENetworkMonitorProtocol {
    
    private let monitor: NWPathMonitor
    
    var isConnected: Bool {
        return monitor.currentPath.status == .satisfied
    }
    
    init() {
        monitor = NWPathMonitor()
    }
    
    func startMonitoringNetwork(_ statusChanged: @escaping WALENetworkStatusChanged) {
        
        print("startMonitoringNetwork")
        print("monitor.currentPath.status before", monitor.currentPath.status)

        monitor.pathUpdateHandler = { path in
            print("monitor.currentPath.status after", monitor.currentPath.status)
            statusChanged(path.status == .satisfied)
        }
        
        let queue = DispatchQueue(label: "WALENetworkMonitor")
        monitor.start(queue: queue)
    }
}
