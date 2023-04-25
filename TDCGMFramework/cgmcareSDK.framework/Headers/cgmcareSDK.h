//
//  cgmcareSDK.h
//  cgmcareSDK
//
//  Created by 李伟健 on 2023/4/25.
//

#import <Foundation/Foundation.h>

//! Project version number for cgmcareSDK.
FOUNDATION_EXPORT double cgmcareSDKVersionNumber;

//! Project version string for cgmcareSDK.
FOUNDATION_EXPORT const unsigned char cgmcareSDKVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <cgmcareSDK/PublicHeader.h>

#import <CommonCrypto/CommonCryptor.h>

//瞬感传感器类型
typedef NS_ENUM(int, TDLibreSensorType) {
    unknown     = 0,
    libre1      = 1,
    libre2      = 2,
    libreProH   = 3,
};
//瞬感传感器状态
typedef NS_ENUM(int, TDLibreSensorState) {
    LibreSensorState_unknown              = 0,
    LibreSensorState_notActivated         = 1,//未激活
    LibreSensorState_warmingUp            = 2,//预热
    LibreSensorState_active               = 3,//已激活
    LibreSensorState_expired              = 4,//过期
    LibreSensorState_shutdown             = 5,//关机
    LibreSensorState_failure              = 6,//故障
};
//瞬感异常状态码
typedef NS_ENUM(int, TDErrorType) {
    ErrorType_unknown                     = 0,//未知错误
    ErrorType_system                      = 1,//系统错误
    ErrorType_LibreSensorTypeError        = 2,//传感器不是1代
    ErrorType_LibreSensorStateError       = 3,//操作与当前探头状态不匹配，只有探头在LibreSensorState_notActivated状态下可激活
    ErrorType_LibreCrcError               = 4,//传感器数据校验不通过
    ErrorType_LibreError                  = 5,//糖动获取数据异常
    ErrorType_BLEUnauthorized             = 6,//没有蓝牙权限
    ErrorType_Unauthorized                = 7,//sdk未授权
};

