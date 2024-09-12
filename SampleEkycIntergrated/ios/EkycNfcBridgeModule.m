//
//  EkycBridgeModule.m
//  SampleEkycIntergrated
//
//  Created by Longcon99 on 30/05/2023.
//

#import <Foundation/Foundation.h>
#import "EkycNfcBridgeModule.h"
#import "ICSdkEKYC/ICSdkEKYC.h"


@implementation EkycNfcBridgeModule

// To export a module named RCTCalendarModule
RCT_EXPORT_MODULE(EkycNfcBridge);

#pragma mark - EKYC Method

RCT_EXPORT_METHOD(startEkycFull:(NSString *)json resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  self._resolve = resolve;
  self._reject = reject;
  
  NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
  NSString* accessToken = [jsonResponse valueForKey:@"access_token"];
  NSString* tokenId = [jsonResponse valueForKey:@"token_id"];
  NSString* tokenKey = [jsonResponse valueForKey:@"token_key"];
  
  ICEKYCSavedData.shared.tokenKey = tokenKey;
  ICEKYCSavedData.shared.tokenId = tokenId;
  ICEKYCSavedData.shared.authorization = accessToken;
  
  ICEkycCameraViewController *camera = (ICEkycCameraViewController *) [ICEkycCameraRouter createModule];
  camera.cameraDelegate = self;
  
  /// Giá trị này xác định kiểu giấy tờ để sử dụng:
  /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
  /// - IDCardChipBased: Căn cước công dân gắn Chip
  /// - Passport: Hộ chiếu
  /// - DriverLicense: Bằng lái xe
  /// - MilitaryIdCard: Chứng minh thư quân đội
  camera.documentType = IdentityCard;
  
  /// Luồng đầy đủ
  /// Bước 1 - chụp ảnh giấy tờ
  /// Bước 2 - chụp ảnh chân dung xa gần
  camera.flowType = full;
  
  /// xác định xác thực khuôn mặt bằng oval xa gần
  camera.versionSdk = ProOval;
  
  /// Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
  camera.isCompareFaces = YES;
  
  /// Bật/Tắt chức năng kiểm tra che mặt
  camera.isCheckMaskedFace = YES;
  
  /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
  camera.isCheckLivenessCard = YES;
  
  /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
  /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
  /// - Basic: Kiểm tra sau khi chụp ảnh
  /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
  /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
  camera.validateDocumentType = Basic;
  
  /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
  camera.isValidatePostcode = YES;
  
  /// Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
  /// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
  /// - iBETA: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
  /// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
  camera.checkLivenessFace = IBeta;
  
  /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
  camera.challengeCode = @"INNOVATIONCENTER";
  
  /// Ngôn ngữ sử dụng trong SDK
  /// - vi: Tiếng Việt
  /// - en: Tiếng Anh
  camera.languageSdk = @"vi";
  
  /// Bật/Tắt Hiển thị màn hình hướng dẫn
  camera.isShowTutorial = YES;
  
  /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
  camera.isEnableGotIt = YES;
  
  /// Sử dụng máy ảnh mặt trước
  /// - PositionFront: Camera trước
  /// - PositionBack: Camera sau
  camera.cameraPositionForPortrait = PositionFront;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL modalPresent = (BOOL) (root.presentedViewController);
    
    if (modalPresent) {
      UIViewController *parent = root.presentedViewController;
      [parent setModalPresentationStyle:UIModalPresentationFullScreen];
      [parent showViewController:camera sender:parent];
      
    } else {
      [camera setModalPresentationStyle:UIModalPresentationFullScreen];
      [root showDetailViewController:camera sender:root];
    }
    
  });

};


RCT_EXPORT_METHOD(startEkycOcr:(NSString *)json resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  self._resolve = resolve;
  self._reject = reject;
  
  NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
  NSString* accessToken = [jsonResponse valueForKey:@"access_token"];
  NSString* tokenId = [jsonResponse valueForKey:@"token_id"];
  NSString* tokenKey = [jsonResponse valueForKey:@"token_key"];
  
  ICEKYCSavedData.shared.tokenKey = tokenKey;
  ICEKYCSavedData.shared.tokenId = tokenId;
  ICEKYCSavedData.shared.authorization = accessToken;
  
  ICEkycCameraViewController *camera = (ICEkycCameraViewController *) [ICEkycCameraRouter createModule];
  camera.cameraDelegate = self;
  
  /// Giá trị này xác định kiểu giấy tờ để sử dụng:
  /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
  /// - IDCardChipBased: Căn cước công dân gắn Chip
  /// - Passport: Hộ chiếu
  /// - DriverLicense: Bằng lái xe
  /// - MilitaryIdCard: Chứng minh thư quân đội
  camera.documentType = IdentityCard;
  
  /// Luồng đầy đủ
  /// Bước 1 - chụp ảnh giấy tờ
  /// Bước 2 - chụp ảnh chân dung xa gần
  camera.flowType = ocr;
  
  /// Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
  camera.isCheckLivenessCard = YES;
  
  /// Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
  /// - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
  /// - Basic: Kiểm tra sau khi chụp ảnh
  /// - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
  /// - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
  camera.validateDocumentType = Basic;
  
  /// Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
  camera.isValidatePostcode = YES;
  
  /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
  camera.challengeCode = @"INNOVATIONCENTER";
  
  /// Ngôn ngữ sử dụng trong SDK
  /// - vi: Tiếng Việt
  /// - en: Tiếng Anh
  camera.languageSdk = @"vi";
  
  /// Bật/Tắt Hiển thị màn hình hướng dẫn
  camera.isShowTutorial = YES;
  
  /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
  camera.isEnableGotIt = YES;
  
  /// Sử dụng máy ảnh mặt trước
  /// - PositionFront: Camera trước
  /// - PositionBack: Camera sau
  camera.cameraPositionForPortrait = PositionFront;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL modalPresent = (BOOL) (root.presentedViewController);
    
    if (modalPresent) {
      UIViewController *parent = root.presentedViewController;
      [parent setModalPresentationStyle:UIModalPresentationFullScreen];
      [parent showViewController:camera sender:parent];
      
    } else {
      [camera setModalPresentationStyle:UIModalPresentationFullScreen];
      [root showDetailViewController:camera sender:root];
    }
    
  });

};


RCT_EXPORT_METHOD(startEkycFace:(NSString *)json resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  self._resolve = resolve;
  self._reject = reject;
  
  NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
  NSString* accessToken = [jsonResponse valueForKey:@"access_token"];
  NSString* tokenId = [jsonResponse valueForKey:@"token_id"];
  NSString* tokenKey = [jsonResponse valueForKey:@"token_key"];
  
  ICEKYCSavedData.shared.tokenKey = tokenKey;
  ICEKYCSavedData.shared.tokenId = tokenId;
  ICEKYCSavedData.shared.authorization = accessToken;
  
  ICEkycCameraViewController *camera = (ICEkycCameraViewController *) [ICEkycCameraRouter createModule];
  camera.cameraDelegate = self;
  
  /// Giá trị này xác định kiểu giấy tờ để sử dụng:
  /// - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
  /// - IDCardChipBased: Căn cước công dân gắn Chip
  /// - Passport: Hộ chiếu
  /// - DriverLicense: Bằng lái xe
  /// - MilitaryIdCard: Chứng minh thư quân đội
  camera.documentType = IdentityCard;
  
  /// Luồng đầy đủ
  /// Bước 1 - chụp ảnh giấy tờ
  /// Bước 2 - chụp ảnh chân dung xa gần
  camera.flowType = face;
  
  /// xác định xác thực khuôn mặt bằng oval xa gần
  camera.versionSdk = ProOval;
  
  /// Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
  camera.isCompareFaces = YES;
  
  /// Bật/Tắt chức năng kiểm tra che mặt
  camera.isCheckMaskedFace = YES;
  
  /// Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
  /// - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
  /// - iBETA: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
  /// - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
  camera.checkLivenessFace = IBeta;
  
  /// Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
  camera.challengeCode = @"INNOVATIONCENTER";
  
  /// Ngôn ngữ sử dụng trong SDK
  /// - vi: Tiếng Việt
  /// - en: Tiếng Anh
  camera.languageSdk = @"vi";
  
  /// Bật/Tắt Hiển thị màn hình hướng dẫn
  camera.isShowTutorial = YES;
  
  /// Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
  camera.isEnableGotIt = YES;
  
  /// Sử dụng máy ảnh mặt trước
  /// - PositionFront: Camera trước
  /// - PositionBack: Camera sau
  camera.cameraPositionForPortrait = PositionFront;
  
  
  dispatch_async(dispatch_get_main_queue(), ^{
    UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
    BOOL modalPresent = (BOOL) (root.presentedViewController);
    
    if (modalPresent) {
      UIViewController *parent = root.presentedViewController;
      [parent setModalPresentationStyle:UIModalPresentationFullScreen];
      [parent showViewController:camera sender:parent];
      
    } else {
      [camera setModalPresentationStyle:UIModalPresentationFullScreen];
      [root showDetailViewController:camera sender:root];
    }
    
  });

};


#pragma mark - NFC Method
RCT_EXPORT_METHOD(navigateToNfcQrCode:(NSString *)json resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  self._resolve = resolve;
  self._reject = reject;
  
  NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
  NSString* accessToken = [jsonResponse valueForKey:@"access_token"];
  NSString* tokenId = [jsonResponse valueForKey:@"token_id"];
  NSString* tokenKey = [jsonResponse valueForKey:@"token_key"];

  [ICNFCSaveData shared].SDTokenId = tokenId;
  [ICNFCSaveData shared].SDTokenKey = tokenKey;
  [ICNFCSaveData shared].SDAuthorization = accessToken;
  [ICNFCSaveData shared].isPrintLogRequest = YES;
  
  if (@available(iOS 13.0, *)) {
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Hiển thị màn hình trợ giúp
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video.
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho idNumberCard, birthdayCard và expiredDateCard => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = QRCode;
    
    // bật chức năng tải ảnh chân dung trong CCCD
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode.
    objICMainNFCReader.isGetPostcodeMatching = true;
    
    // bật tính năng xác thực thẻ.
    objICMainNFCReader.isEnableVerifyChip = true;
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Security Object Document (SOD, COM)
    // MRZ Code (DG1)
    // Image Base64 (DG2)
    // Security Data (DG14, DG15)
    // ** Lưu Ý: Nếu không truyền dữ liệu hoặc truyền mảng rỗng cho readingTagsNFC. SDK sẽ đọc hết các thông tin trong thẻ
    objICMainNFCReader.readingTagsNFC = @[@(VerifyDocumentInfo), @(MRZInfo), @(ImageAvatarInfo), @(SecurityDataInfo)];
    
    // Giá trị tên miền chính của SDK
    // Giá trị "" => gọi đến môi trường Product
    objICMainNFCReader.baseDomain = [NSString string];
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
        
    dispatch_async(dispatch_get_main_queue(), ^{
      UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
      BOOL modalPresent = (BOOL) (root.presentedViewController);
      objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      
      if (modalPresent) {
        UIViewController *parent = root.presentedViewController;
        [parent setModalPresentationStyle:UIModalPresentationFullScreen];
        [parent showViewController:objICMainNFCReader sender:parent];
        
      } else {
        [objICMainNFCReader setModalPresentationStyle:UIModalPresentationFullScreen];
        [root showDetailViewController:objICMainNFCReader sender:root];
      }
      
    });
    
  } else {
    // Fallback on earlier versions
  }
  
};


RCT_EXPORT_METHOD(navigateToScanNfc:(NSString *)json resolve:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
  
  self._resolve = resolve;
  self._reject = reject;
  
  NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
  NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data
                                                               options:kNilOptions
                                                                 error:nil];
  NSString* accessToken = [jsonResponse valueForKey:@"access_token"];
  NSString* tokenId = [jsonResponse valueForKey:@"token_id"];
  NSString* tokenKey = [jsonResponse valueForKey:@"token_key"];
  NSString* cardId = [jsonResponse valueForKey:@"card_id"];
  NSString* cardDob = [jsonResponse valueForKey:@"card_dob"];
  NSString* cardExpireDate = [jsonResponse valueForKey:@"card_expire_date"];
  
  [ICNFCSaveData shared].SDTokenId = tokenId;
  [ICNFCSaveData shared].SDTokenKey = tokenKey;
  [ICNFCSaveData shared].SDAuthorization = accessToken;
  [ICNFCSaveData shared].isPrintLogRequest = YES;

  
  if (@available(iOS 13.0, *)) {
    ICMainNFCReaderViewController *objICMainNFCReader = (ICMainNFCReaderViewController *)[ICMainNFCReaderRouter createModule];
    
    // Đặt giá trị DELEGATE để nhận kết quả trả về
    objICMainNFCReader.icMainNFCDelegate = self;
    
    // Hiển thị màn hình trợ giúp
    objICMainNFCReader.isShowTutorial = true;
    
    // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video.
    objICMainNFCReader.isEnableGotIt = true;
    
    // Thuộc tính quy định việc đọc thông tin NFC
    // - QRCode: Quét mã QR sau đó đọc thông tin thẻ Chip NFC
    // - NFCReader: Nhập thông tin cho idNumberCard, birthdayCard và expiredDateCard => sau đó đọc thông tin thẻ Chip NFC
    objICMainNFCReader.cardReaderStep = NFCReader;
    // Số giấy tờ căn cước, là dãy số gồm 12 ký tự.
    objICMainNFCReader.idNumberCard = cardId;
    // Ngày sinh của người dùng được in trên Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 1978 thì giá trị là 780518).
    objICMainNFCReader.birthdayCard = cardDob;
    // Ngày hết hạn của Căn cước, có định dạng YYMMDD (ví dụ 18 tháng 5 năm 2047 thì giá trị là 470518).
    objICMainNFCReader.expiredDateCard = cardExpireDate;
    
    
    // bật chức năng tải ảnh chân dung trong CCCD
    objICMainNFCReader.isEnableUploadAvatarImage = true;
    
    // Bật tính năng Matching Postcode.
    objICMainNFCReader.isGetPostcodeMatching = true;
    
    // bật tính năng xác thực thẻ.
    objICMainNFCReader.isEnableVerifyChip = true;
    
    // Giá trị này được truyền vào để xác định các thông tin cần để đọc. Các phần tử truyền vào là các giá trị của CardReaderValues.
    // Security Object Document (SOD, COM)
    // MRZ Code (DG1)
    // Image Base64 (DG2)
    // Security Data (DG14, DG15)
    // ** Lưu Ý: Nếu không truyền dữ liệu hoặc truyền mảng rỗng cho readingTagsNFC. SDK sẽ đọc hết các thông tin trong thẻ
    objICMainNFCReader.readingTagsNFC = @[@(VerifyDocumentInfo), @(MRZInfo), @(ImageAvatarInfo), @(SecurityDataInfo)];
    
    // Giá trị tên miền chính của SDK
    // Giá trị "" => gọi đến môi trường Product
    objICMainNFCReader.baseDomain = [NSString string];
    
    // Giá trị này xác định ngôn ngữ được sử dụng trong SDK.
    // - icnfc_vi: Tiếng Việt
    // - icnfc_en: Tiếng Anh
    objICMainNFCReader.languageSdk = @"icekyc_vi";
    
    dispatch_async(dispatch_get_main_queue(), ^{
      UIViewController *root = [[[UIApplication sharedApplication] delegate] window].rootViewController;
      BOOL modalPresent = (BOOL) (root.presentedViewController);
      objICMainNFCReader.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
      
      if (modalPresent) {
        UIViewController *parent = root.presentedViewController;
        [parent setModalPresentationStyle:UIModalPresentationFullScreen];
        [parent showViewController:objICMainNFCReader sender:parent];
        
      } else {
        [objICMainNFCReader setModalPresentationStyle:UIModalPresentationFullScreen];
        [root showDetailViewController:objICMainNFCReader sender:root];
      }
      
    });
    
  } else {
    // Fallback on earlier versions
  }
  
};


#pragma mark - Delegate NFC

- (void)icNFCCardReaderGetResult {
  NSLog(@"Finished SDK");
  
  // Hiển thị thông tin kết quả QUÉT QR
  NSLog(@"scanQRCodeResult = %@", [ICNFCSaveData shared].scanQRCodeResult);
  
  // Hiển thị thông tin đọc thẻ chip dạng chi tiết
  NSLog(@"dataNFCResult = %@", [ICNFCSaveData shared].dataNFCResult);
  
  // Hiển thị thông tin POSTCODE
  NSLog(@"postcodePlaceOfOriginResult = %@", [ICNFCSaveData shared].postcodePlaceOfOriginResult);
  NSLog(@"postcodePlaceOfResidenceResult = %@", [ICNFCSaveData shared].postcodePlaceOfResidenceResult);
  
  // Hiển thị thông tin xác thực C06
  NSLog(@"verifyNFCCardResult = %@", [ICNFCSaveData shared].verifyNFCCardResult);
  
  // Hiển thị thông tin ảnh chân dung đọc từ thẻ
  NSLog(@"imageAvatar = %@", [ICNFCSaveData shared].imageAvatar);
  NSLog(@"hashImageAvatar = %@", [ICNFCSaveData shared].hashImageAvatar);
  
  // Hiển thị thông tin Client Session
  NSLog(@"clientSessionResult = %@", [ICNFCSaveData shared].clientSessionResult);
  
  // Hiển thị thông tin đọc dữ liệu nguyên bản của thẻ CHIP: COM, DG1, DG2, … DG14, DG15
  NSLog(@"dataGroupsResult = %@", [ICNFCSaveData shared].dataGroupsResult);
  
  NSError* err;
  NSData* jsonData = [NSJSONSerialization dataWithJSONObject:[ICNFCSaveData shared].verifyNFCCardResult options:0 error:&err];
  NSString* verifyNFCCardResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  jsonData = [NSJSONSerialization dataWithJSONObject:[ICNFCSaveData shared].dataNFCResult options:0 error:&err];
  NSString* dataNFCResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  jsonData = [NSJSONSerialization dataWithJSONObject:[ICNFCSaveData shared].postcodePlaceOfOriginResult options:0 error:&err];
  NSString* postcodePlaceOfOriginResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  jsonData = [NSJSONSerialization dataWithJSONObject:[ICNFCSaveData shared].postcodePlaceOfResidenceResult options:0 error:&err];
  NSString* postcodePlaceOfResidenceResult = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
  
  NSDictionary* dict = @{
    // Thông tin mã QR
    @"QR_CODE_RESULT_NFC": [ICNFCSaveData shared].scanQRCodeResult,
    // Thông tin verify C06
    @"CHECK_AUTH_CHIP_RESULT": verifyNFCCardResult,
    // Thông tin ẢNH chân dung
    @"IMAGE_AVATAR_CARD_NFC": [ICNFCSaveData shared].pathImageAvatar.absoluteString,
    @"HASH_AVATAR": [ICNFCSaveData shared].hashImageAvatar,
    // Thông tin Client Session
    @"CLIENT_SESSION_RESULT": [ICNFCSaveData shared].clientSessionResult,
    // Thông tin NFC
    @"LOG_NFC": dataNFCResult,
    // Thông tin postcode
    @"POST_CODE_ORIGINAL_LOCATION_RESULT": postcodePlaceOfOriginResult,
    @"POST_CODE_RECENT_LOCATION_RESULT": postcodePlaceOfResidenceResult,
    /// eKYC
    @"INFO_RESULT": @"",
    @"LIVENESS_CARD_FRONT_RESULT": @"",
    @"LIVENESS_CARD_REAR_RESULT": @"",
    @"COMPARE_RESULT": @"",
    @"LIVENESS_FACE_RESULT": @"",
    @"MASKED_FACE_RESULT": @""
  };
  
  NSError* error;
  NSData* data= [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
  
  NSString* resultJson = @"";
  if (error) {
    NSLog(@"Failure to serialize JSON object %@", error);
    
  } else {
    resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  
  self._resolve(resultJson);
  self._resolve = nil;
  
}

- (void)icNFCMainDismissed {
  NSLog(@"icNFCMainDismissed");

}


#pragma mark - Delegate EKYC
- (void)icEkycGetResult {
  NSLog(@"Finished SDK");
  
  NSString* dataInfoResult = ICEKYCSavedData.shared.ocrResult;
  NSString* dataLivenessCardFrontResult = ICEKYCSavedData.shared.livenessCardFrontResult;
  NSString* dataLivenessCardRearResult = ICEKYCSavedData.shared.livenessCardBackResult;
  NSString* dataCompareResult = ICEKYCSavedData.shared.compareFaceResult;
  NSString* dataLivenessFaceResult = ICEKYCSavedData.shared.livenessFaceResult;
  NSString* dataMaskedFaceResult = ICEKYCSavedData.shared.maskedFaceResult;
  
  NSDictionary* dict = @{
    @"INFO_RESULT": dataInfoResult,
    @"LIVENESS_CARD_FRONT_RESULT": dataLivenessCardFrontResult,
    @"LIVENESS_CARD_REAR_RESULT": dataLivenessCardRearResult,
    @"COMPARE_RESULT": dataCompareResult,
    @"LIVENESS_FACE_RESULT": dataLivenessFaceResult,
    @"MASKED_FACE_RESULT": dataMaskedFaceResult,
    /// NFC
    @"QR_CODE_RESULT_NFC": @"",
    @"CHECK_AUTH_CHIP_RESULT": @"",
    @"IMAGE_AVATAR_CARD_NFC": @"",
    @"HASH_AVATAR": @"",
    @"CLIENT_SESSION_RESULT": @"",
    @"LOG_NFC": @"",
    @"POST_CODE_ORIGINAL_LOCATION_RESULT": @"",
    @"POST_CODE_RECENT_LOCATION_RESULT": @""
  };
  
  NSError* error;
  NSData* data= [NSJSONSerialization dataWithJSONObject:dict options:0 error:&error];
  
  NSString* resultJson = @"";
  if (error) {
    NSLog(@"Failure to serialize JSON object %@", error);
    
  } else {
    resultJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
  }
  
  self._resolve(resultJson);
  self._resolve = nil;
  
}

- (void)icEkycCameraClosedWithType:(ScreenType)type {
  NSLog(@"icEkycCameraClosedWithType SDK");

}

@end
