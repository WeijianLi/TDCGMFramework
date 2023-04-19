//
//  ViewController.swift
//  TDCGMFramework
//
//  Created by 李伟健 on 2023/4/14.
//

import UIKit
import CoreBluetooth
import TDFramework
class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    @IBOutlet weak var bleState: UILabel!
    @IBOutlet weak var tvview: UITextView!
    @IBOutlet weak var tfView: UITextField!
    @IBOutlet weak var tabview: UITableView!
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
        tabview.separatorStyle = .none
        tvview.text = ""
        tvview.layoutManager.allowsNonContiguousLayout = false
        showMsg("SDK版本号 = "+"\(TDLibreManager.getVersion())")
        TDLibreManager.addTDBleStateBlock { [self] bleState in
            showMsg("蓝牙状态 "+"\(bleState.rawValue)")
            switch bleState {
            case .disconnected:
                self.bleState.text = "断开连接"
            case .connecting:
                self.bleState.text = "连接中"
            case .connected:
                self.bleState.text = "已连接"
            case .disconnecting:
                self.bleState.text = "断开连接中"
            @unknown default:
                self.bleState.text = "--"
            }
        };
        TDLibreManager.addTDLibreErrorBlock { [self] error in
            showMsg("error code = "+"\(error.code)"+"localizedDescription = "+"\(error.localizedDescription)"+"\n"+"\(error.error)")
        }
        TDLibreManager.addTDLibreUpdataBlock { [self] libreModel in
            let msg = "电压 "+"\(libreModel.voltage)"+"\n传感器类型 "+"\(libreModel.sensorType)"+"\n传感器状态 "+"\(libreModel.sensorState)"+"\n传感器编号 "+"\(libreModel.sensorSerialNumber)"+"\n瞬感激活时间 "+"\(libreModel.sensorStartTime)"+"\n已使用时间 "+"\(libreModel.sensorTime)"+"\n蓝牙名称 "+"\(libreModel.bleName)"+"\n解析血糖条数 "+"\(libreModel.glucoseDataArr.count)"
            showMsg(msg)
            
            for gm in libreModel.glucoseDataArr {
                let msg = "time"+"\(gm.time)"+"血糖"+"\(gm.glucose)"
                showMsg(msg)
            }
        };
    }

    @IBAction func connect(_ sender: Any) {
        let name = self.tfView.text!
        if name.count == 0 {
            showMsg("请在右侧输入蓝牙名称")
            return
        }
        TDLibreManager.connectTDLibreBLE(peripheralName: name);
    }
    var bleList :Array<CBPeripheral> = []
    @IBAction func bleList(_ sender: Any) {
        TDLibreManager.scanTDLibreBLEList { [self] list in
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
    @IBAction func getLog(_ sender: Any) {
        var log = TDLibreManager.getTDLog()
        print("log = "+"\(log)")
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
        cell.textLabel?.text = bleList[indexPath.row].name
        cell.detailTextLabel?.text = "点击链接设备"
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        TDLibreManager.connectTDLibreBLE(peripheral: bleList[indexPath.row])
    }
    
}


