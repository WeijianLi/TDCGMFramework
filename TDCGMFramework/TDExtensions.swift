//
//  TDExtensions.swift
//  TDCGMFramework
//
//  Created by 李伟健 on 2023/4/14.
//

import Foundation
extension Date {
    var toTimeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.string(from: self)
    }
    var toyyyyMMddTimeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }
    var timestamp:Int{
        return Int(self.timeIntervalSince1970)
    }
}
extension Dictionary {
    var TD_toData: Data?{
        let data = try? JSONSerialization.data(withJSONObject: self,options: [])
        return data
    }
}
extension Data {
    
    
    var toStr: String {
        return String(data:self,encoding:.utf8)!
    }
    var toHexStr: String { self.reduce("", { $0 + String(format: "%02x", $1)}) }
    var reversed : Data {
        return Data(self.reversed())
    }
    
    var TD_toDic: Dictionary<String,Any>?{
        do {
            let json = try JSONSerialization.jsonObject(with: self,options: .mutableContainers)
            let dic = json as! Dictionary<String,Any>
            return dic
        }catch _ {
            return nil
        }
    }
}
extension String {
    var toData: Data {
        return self.data(using: .utf8)!
    }
    var toHexData: Data {
        var bytes = [UInt8]()
        if !self.contains(" ") {
            var offset = self.startIndex
            while offset < self.endIndex {
                let hex = self[offset...index(after: offset)]
                bytes.append(UInt8(hex, radix: 16)!)
                formIndex(&offset, offsetBy: 2)
            }
        } else {
            for line in self.split(separator: "\n") {
                let column = line.contains("  ") ? line.components(separatedBy: "  ")[1] : String(line)
                for hex in column.split(separator: " ") {
                    bytes.append(UInt8(hex, radix: 16)!)
                }
            }
        }
        return Data(bytes)
    }
    

}

