//
//  EkycBridgeModule.h
//  SampleEkycIntergrated
//
//  Created by Longcon99 on 30/05/2023.
//

#ifndef EkycNfcBridgeModule_h
#define EkycNfcBridgeModule_h

#import <React/RCTBridgeModule.h>
#import "ICSdkEKYC/ICSdkEKYC.h"
#import "ICNFCCardReader/ICNFCCardReader.h"

@interface EkycNfcBridgeModule: NSObject <RCTBridgeModule, ICEkycCameraDelegate, ICMainNFCReaderDelegate>

@property(nonatomic, copy) RCTPromiseResolveBlock _resolve;
@property(nonatomic, copy) RCTPromiseRejectBlock _reject;

@end

#endif /* EkycNfcBridgeModule_h */
