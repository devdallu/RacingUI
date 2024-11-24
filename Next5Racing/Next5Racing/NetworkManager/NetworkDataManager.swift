//
//  NetworkDataManager.swift
//  Next5Racing
//
//  Created by Ganesh Kumar Ananthi Dwarakan on 23/11/24.
//

import Foundation
import Network

class NetworkManager {
    private var monitor: NWPathMonitor?
    private var queue = DispatchQueue.global(qos: .background)
    
    // To store the current network status
    var isConnected = false
    var connectionType: String = "None"
    
    init() {
        monitor = NWPathMonitor()
        monitor?.pathUpdateHandler = { path in
            self.isConnected = path.status == .satisfied
            if path.usesInterfaceType(.wifi) {
                self.connectionType = "WiFi"
            } else if path.usesInterfaceType(.cellular) {
                self.connectionType = "Cellular"
            } else {
                self.connectionType = "None"
            }
        }
        monitor?.start(queue: queue)
    }
    
    // Method to stop monitoring if needed
    func stopMonitoring() {
        monitor?.cancel()
    }
}
