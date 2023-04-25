# TDCGMFramework

source 'https://github.com/cocoaPods/Specs.git'
platform :ios, ‘14.0’

target ‘app名’ do
	use_frameworks!
   	pod 'cgmcareSDK' , '~> 2.0.8'
end



nfc和糖动发射器 读取libre1 血糖数据


一、 必要配置
1.     targets->Build Settings->Swift Language Version 设置为 Swift5
2.     targets->Signing&Capabilities->+Capability 添加Near Field Communication Tag Reading 和Backgroud Modes， Backgroud Modes 内选中Uses Bluetooth LE accessories ,Acts as a Bluetoth LE accessory 
3.     targets->info 添加Privacy - Bluetooth Always Usage Description和Privacy - Bluetooth Peripheral Usage Description 蓝牙权限 Privacy - NFC Scan Usage Description nfc权限，添加com.apple.developer.nfc.readersession.formats 字段为数组，添加item0 TAG ，item1 NDEF    
二、使用
添加头文件
oc import <cgmcareSDK/cgmcareSDK.h>
Swift  import cgmcareSDK
1.授权

TDLibreManager.auth(appSecret: appSecret) { [self] error in
            if error == nil {
                showMsg("授权成功")
            }else{
                showMsg("授权结果 = " + error!.localizedDescription)
            }
        }
	
2.设置回调

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
    
3.连接读取数据

    /// 扫描nfc
    open class func scanTDLibreNFC(){
        TDManager.shared.scanTDLibreNFC()
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


