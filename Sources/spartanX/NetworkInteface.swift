//
//  NetworkInteface.swift
//  spartanX
//
//  Created by yuuji on 2/13/17.
//
//

import Foundation
import spartanX_include

public struct NetworkInterface: CustomStringConvertible {
    
    public var name: String
    public var address: SXSocketAddress?
    
    var flags: UInt32
    
    public init(raw: UnsafePointer<ifaddrs>) {
        name = String(cString: raw.pointee.ifa_name)
        address = try? SXSocketAddress(raw.pointee.ifa_addr)
        flags = raw.pointee.ifa_flags
    }
    
    public var description: String {
        
        var proto = "other"
        
        if address != nil {
            proto = "\(address!.sockdomain()!)"
        }
        return "Interface: \(name), addr(\(proto)): \(address?.address ?? "")"
    }
    
    @inline(__always)
    private func contains(_ f: Int32) -> Bool {
        return (flags & UInt32(f)) == UInt32(f)
    }
    
    public var up: Bool {
        return contains(IFF_UP)
    }
    
    public var isVliadBoardcast: Bool {
        return contains(IFF_BROADCAST)
    }
    
    public var debug: Bool {
        return contains(IFF_DEBUG)
    }
    
    public var isLoopback: Bool {
        return contains(IFF_LOOPBACK)
    }
    
    public var noArp: Bool {
        return contains(IFF_NOARP)
    }
    
    public var promiscousMode: Bool {
        return contains(IFF_PROMISC)
    }
    
    public var AvoidTrailers: Bool {
        return contains(IFF_NOTRAILERS)
    }
    
    public var recvAllMulticast: Bool {
        return contains(IFF_ALLMULTI)
    }
    
    public var supportMulticast: Bool {
        return contains(IFF_MULTICAST)
    }
    
    public var running: Bool {
        return contains(IFF_RUNNING)
    }
    
    
    public static var intefaces: [NetworkInterface] {
        var head: UnsafeMutablePointer<ifaddrs>?
        var cur: UnsafeMutablePointer<ifaddrs>?
        
        var intefaces = [NetworkInterface]()
        
        getifaddrs(&head)
        
        cur = head;
        
        while (cur != nil) {
            intefaces.append(NetworkInterface(raw: cur!))
            print(cur!.pointee.ifa_addr.pointee.sa_family)
            cur = cur!.pointee.ifa_next
            
        }
        
        freeifaddrs(head)
        return intefaces
    }
    
    public static func intefaces(support domains: Set<SocketDomains>) -> [NetworkInterface] {
        var head: UnsafeMutablePointer<ifaddrs>?
        var cur: UnsafeMutablePointer<ifaddrs>?
        
        var intefaces = [NetworkInterface]()
        
        getifaddrs(&head)
        
        cur = head;
        
        while (cur != nil) {
            if let domain = SocketDomains(rawValue: cur!.pointee.ifa_addr.pointee.sa_family) {
                if domains.contains(domain) {
                    intefaces.append(NetworkInterface(raw: cur!));
                }
            }
            cur = cur!.pointee.ifa_next
        }
        
        freeifaddrs(head)
        return intefaces
    }
    
    public static func inteface(named: String, support domain: SocketDomains) -> NetworkInterface? {
        var head: UnsafeMutablePointer<ifaddrs>?
        var cur: UnsafeMutablePointer<ifaddrs>?
        
        var inteface: NetworkInterface?
        
        getifaddrs(&head)
        
        cur = head;
        
        while (cur != nil) {
            if let _domain = SocketDomains(rawValue: cur!.pointee.ifa_addr.pointee.sa_family) {
                if (_domain == domain) {
                    inteface = NetworkInterface(raw: cur!)
                }
            }
            cur = cur!.pointee.ifa_next
        }
        
        freeifaddrs(head)
        return inteface
    }
    
    public static func intefaces(named: String) -> [NetworkInterface] {
        var head: UnsafeMutablePointer<ifaddrs>?
        var cur: UnsafeMutablePointer<ifaddrs>?
        
        var intefaces = [NetworkInterface]()
        
        getifaddrs(&head)
        
        cur = head;
        
        while (cur != nil) {
            let name = String(cString: cur!.pointee.ifa_name)
            if name == named {
                intefaces.append(NetworkInterface(raw: cur!));
            }
            cur = cur!.pointee.ifa_next
        }
        
        freeifaddrs(head)
        return intefaces
    }
    
    
}
