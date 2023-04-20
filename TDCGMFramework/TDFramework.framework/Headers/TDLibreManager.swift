//
//  TDLibreManager.swift
//  TDCGMFramework
//
//  Created by 李伟健 on 2023/4/17.
//

import Foundation
import CoreBluetooth

public typealias  TDErrorBlock = (_ error: TDErrorModel) -> Void
public typealias  TDLibreDataBlock = (_ libreModel: TDLibreDataModel) -> Void
public typealias  TDBLEStateBlock = (_ bleState: CBPeripheralState) -> Void
public typealias  TDActivateBlock = (_ error: TDErrorModel?) -> Void

@objcMembers open class TDLibreManager: NSObject {
    
    /// 版本号
    /// - Returns: <#description#>
    open class func getVersion()->String{
        return TDManager.shared.version
    }
    
    /// 蓝牙名称
    /// - Returns: <#description#>
    open class func getPeripheralName()->String{
        return TDManager.shared.peripheralName
    }
    
    /// 蓝牙连接状态
    /// - Returns: <#description#>
    open class func getBleState()->CBPeripheralState{
        return TDManager.shared.bleState
    }
    /// 糖动蓝牙状态监听
    /// - Parameter stateBlock: <#stateBlock description#>
    open class func addTDBleStateBlock(stateBlock :@escaping TDBLEStateBlock){
        TDManager.shared.addTDBleStateBlock = stateBlock
    }
    
    /// 蓝牙和nfc数据回调
    /// - Parameter dataBlock: <#dataBlock description#>
    open class func addTDLibreUpdataBlock(dataBlock :@escaping TDLibreDataBlock){
        TDManager.shared.addTDLibreUpdataBlock = dataBlock
    }
    
    /// sdk异常信息回调
    /// - Parameter errorBlock: error
    open class func addTDLibreErrorBlock(errorBlock :@escaping TDErrorBlock){
        TDManager.shared.addTDLibreErrorBlock = errorBlock
    }
    
    /// 扫描nfc
    open class func scanTDLibreNFC(){
        TDManager.shared.scanTDLibreNFC()
    }
    
    /// nfc 激活瞬感1代
    /// - Parameter success: error == nil 激活成功
    open class func activateTDLibreWithNFC(success:@escaping TDActivateBlock){
        TDManager.shared.activateTDLibreWithNFC(success: success)
    }
    
    /// 扫描糖动蓝牙发射
    /// - Parameter success: 蓝牙列表
    open class func scanTDLibreBLEList(success: @escaping (Array<CBPeripheral>)->Void){
        TDManager.shared.scanTDLibreBLEList(success: success)
    }
    
    /// 连接糖动发射器
    /// - Parameter peripheralName: 蓝牙名称
    open class func connectTDLibreBLE(peripheralName:String){
        TDManager.shared.connectTDLibreBLE(peripheralName: peripheralName)
    }
    
    /// 连接糖动发射器
    /// - Parameter peripheral: 糖动蓝牙
    open class func connectTDLibreBLE(peripheral:CBPeripheral){
        TDManager.shared.connectTDLibreBLE(peripheral: peripheral)
    }
    
    /// 断开蓝牙连接
    open class func disconnectTDLibreBLE(){
        TDManager.shared.disconnectTDLibreBLE()
    }
    
    /// 获取糖动日志
    open class func getTDLog() -> String{
       return TDManager.shared.getTDLog()
    }
}
@objcMembers open class TDGlucoseDataModel : NSObject {
    //血糖时间
    open var time : Date?
    //血糖数值 单位mmol/L
    open var glucose : Double = 0.0
}
@objcMembers open class TDErrorModel : NSObject {
    //错误码
    open var code : TDErrorType = .ErrorType_unknown
    //说明
    open var localizedDescription : String = ""
    open var error : Any?
    init(code: TDErrorType, localizedDescription: String = "") {
        var msg = localizedDescription
        if msg.count == 0 {
            msg = "未知异常"
        }
        self.code = code
        self.localizedDescription = msg
        self.error = NSError(domain: "com.td", code: Int(code.rawValue), userInfo: [NSLocalizedDescriptionKey:msg])
    }
}
@objcMembers open class TDLibreDataModel :NSObject {
    //电压值
    open var voltage : String = ""
    //蓝牙名称
    open var bleName : String = ""
    //血糖数组
    open var glucoseDataArr : Array<TDGlucoseDataModel> = []
    //传感器类型  对应 TDLibreSensorType  枚举
    open var sensorType :  TDLibreSensorType = .unknown
    //传感器状态 对应 TDLibreSensorState  枚举
    open var sensorState : TDLibreSensorState = .LibreSensorState_unknown
    //传感器编号
    open var sensorSerialNumber : String = ""
    //瞬感激活时间
    open var sensorStartTime : String = ""
    //瞬感已使用时间单位分
    open var sensorTime : Int = 0
}

