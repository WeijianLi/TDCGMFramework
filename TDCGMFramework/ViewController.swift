//
//  ViewController.swift
//  TDCGMFramework
//
//  Created by 李伟健 on 2023/4/14.
//

import UIKit
import CoreBluetooth
import cgmcareSDK
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //    let appSecret = "i50QOn2jqr2WwqnVp2CL2lz505Qe052Q"
    let appSecret = "x6Zrqqnazi4aMmGGfv65qa5g7rBm0SA7"
    @IBOutlet weak var authState: UILabel!
    @IBOutlet weak var bleState: UILabel!
    @IBOutlet weak var tvview: UITextView!
    @IBOutlet weak var tfView: UITextField!
    @IBOutlet weak var tabview: UITableView!
    let notificationHandler = NotificationHandler()
    func showMsg(_ items: Any...){
        print(items)

        var s = ""
        for i in items {
            s.append(String(format: "%@", i as! CVarArg))
        }
        self.tvview.text.append("\n")
        self.tvview.text.append(s)
        self.tvview.scrollRangeToVisible(NSMakeRange(self.tvview.text.count, 1))
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        authState.text = "\(TDLibreManager.getAuthStatus())"
        tabview.separatorStyle = .none
        tvview.text = ""
        tvview.layoutManager.allowsNonContiguousLayout = false
        showMsg("SDK版本号 = "+"\(TDLibreManager.getVersion())")
        TDLibreManager.addTDBleStateBlock { [self] bleState in
            showMsg("蓝牙状态 "+"\(bleState.rawValue)")
            var state = "--"
            switch bleState {
            case .disconnected:
                state = "断开连接"
            case .connecting:
                state = "连接中"
            case .connected:
                state = "已连接"
            case .disconnecting:
                state = "断开连接中"
            @unknown default:
                break
            }
            self.bleState.text = state
            notificationHandler.requestUserNotification(title: "蓝牙状态",body: state)
        };
        TDLibreManager.addTDLibreErrorBlock { [self] error in
            showMsg("error code = "+"\(error.code)"+"localizedDescription = "+"\(error.localizedDescription)"+"\n"+"\(error.error)")
            notificationHandler.requestUserNotification(title: "SDK异常",body: error.localizedDescription)
        }
        TDLibreManager.addTDLibreUpdataBlock { [self] libreModel in
            let msg = "电压 "+"\(libreModel.voltage)"+"\n传感器类型 "+"\(libreModel.sensorType)"+"\n传感器状态 "+"\(libreModel.sensorState)"+"\n传感器编号 "+"\(libreModel.sensorSerialNumber)"+"\n瞬感激活时间 "+"\(libreModel.sensorStartTime)"+"\n已使用时间 "+"\(libreModel.sensorTime)"+"\n蓝牙名称 "+"\(libreModel.bleName)"+"\n解析血糖条数 "+"\(libreModel.glucoseDataArr.count)"
            showMsg(msg)
            
            for gm in libreModel.glucoseDataArr {
                let msg = "time"+"\(gm.time)"+"血糖"+"\(gm.glucose)"
                showMsg(msg)
            }
            if libreModel.glucoseDataArr.count > 0 {
                let m = libreModel.glucoseDataArr.first
                notificationHandler.requestUserNotification(title: "最新血糖",body: "时间 = " + m!.time!.toTimeStr + " 血糖值 = "+"\(m?.glucose)")
            }else{
                notificationHandler.requestUserNotification(title: "最新血糖",body: "没有最新数据")
            }
            
        };
        auth(UIButton())
    }

    @IBAction func connect(_ sender: Any) {
        let name = self.tfView.text!
        if name.count == 0 {
            showMsg("请在右侧输入蓝牙名称")
            return
        }
        TDLibreManager.connectTDLibreBLE(peripheralName: name);
    }
    var bleList :Array<Dictionary<String,Any>> = []
    @IBAction func bleList(_ sender: Any) {
        TDLibreManager.scanTDLibreBLEAndAdvertisementDataList { [self] list in
            bleList = list
            tabview.reloadData()
        }
    }
    @IBAction func activity(_ sender: UIButton) {
        TDLibreManager.activateTDLibreWithNFC { [self] error in
            if error != nil {
                let msg = "激活失败 "+"error code = "+"\(error!.code)"+"localizedDescription = "+"\(error!.localizedDescription)"+"\n"+"\(error!.error)"
                showMsg(msg)
                return
            }
            showMsg("激活成功")
        }
    }
    @IBAction func auth(_ sender: Any) {
        TDLibreManager.auth(appSecret: appSecret) { [self] error in
            if error == nil {
                showMsg("授权成功")
                TDLibreManager.connectTDLibreBLE(peripheralName: TDLibreManager.getPeripheralName())
            }else{
                showMsg("授权结果 = " + error!.localizedDescription)
            }
            authState.text = "\(TDLibreManager.getAuthStatus())"
        }
        
    }
    @IBAction func getLog(_ sender: Any) {
//        showMsg("解密前")
//        var log = TDLibreManager.getTDTodayLog()
//        showMsg(log)
//        showMsg("解密后")
//        log = TDLogManager.shared.decryptTDLogInfo(s: log)
//        showMsg(log)
//        print(log)
    }
    @IBAction func disconnect(_ sender: Any) {
        TDLibreManager.disconnectTDLibreBLE()
    }
    @IBAction func scan(_ sender: Any) {
        TDLibreManager.scanTDLibreNFC()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.bleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        let dic = bleList[indexPath.row];
        let peripheral :CBPeripheral = dic["peripheral"] as! CBPeripheral;
        let advertisementData :[String : Any] = dic["advertisementData"] as! [String : Any]
        let kCBAdvDataManufacturerData :Data = advertisementData["kCBAdvDataManufacturerData"] as! Data
        let macID = kCBAdvDataManufacturerData.suffix(6)
        cell.textLabel?.text = peripheral.name! + " macID:\(macID.toHexStr)"
        cell.detailTextLabel?.text = "点击链接设备"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = bleList[indexPath.row];
        let peripheral :CBPeripheral = dic["peripheral"] as! CBPeripheral;
        TDLibreManager.connectTDLibreBLE(peripheral: peripheral)
    }
    
    
}


