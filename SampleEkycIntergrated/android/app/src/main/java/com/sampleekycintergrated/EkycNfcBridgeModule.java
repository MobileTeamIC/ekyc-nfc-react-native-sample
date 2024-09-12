package com.sampleekycintergrated;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.nfc.NfcAdapter;
import android.nfc.NfcManager;
import android.text.TextUtils;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.ActivityEventListener;
import com.facebook.react.bridge.BaseActivityEventListener;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import com.vnptit.idg.sdk.activity.VnptIdentityActivity;
import com.vnptit.idg.sdk.activity.VnptOcrActivity;
import com.vnptit.idg.sdk.activity.VnptPortraitActivity;
import com.vnptit.idg.sdk.utils.KeyIntentConstants;
import com.vnptit.idg.sdk.utils.KeyResultConstants;
import com.vnptit.idg.sdk.utils.SDKEnum;
import com.vnptit.nfc.activity.VnptScanNFCActivity;
import com.vnptit.nfc.utils.KeyIntentConstantsNFC;
import com.vnptit.nfc.utils.KeyResultConstantsNFC;
import com.vnptit.nfc.utils.SDKEnumNFC;

public class EkycNfcBridgeModule extends ReactContextBaseJavaModule {

   private static final int EKYC_REQUEST_CODE = 100;
   private static final String EKYC_REJECT_CODE = "69";
   private Promise mEkycPromise;

   public EkycNfcBridgeModule(ReactApplicationContext reactContext) {
      super(reactContext);

      final ActivityEventListener activityEventListener = new BaseActivityEventListener() {
         @SuppressWarnings("DanglingJavadoc")
         @Override
         public void onActivityResult(Activity activity, int requestCode, int resultCode, Intent data) {
            if (requestCode == EKYC_REQUEST_CODE && resultCode == Activity.RESULT_OK) {
               if (data != null && mEkycPromise != null) {
                  /**
                   * Dữ liệu bóc tách thông tin OCR
                   * {@link KeyResultConstants#INFO_RESULT}
                   */
                  final String dataInfoResult = data.getStringExtra(KeyResultConstants.INFO_RESULT);

                  /**
                   * Dữ liệu bóc tách thông tin Liveness card mặt trớc
                   * {@link KeyResultConstants#LIVENESS_CARD_FRONT_RESULT}
                   */
                  final String dataLivenessCardFrontResult = data.getStringExtra(KeyResultConstants.LIVENESS_CARD_FRONT_RESULT);

                  /**
                   * Dữ liệu bóc tách thông tin liveness card mặt sau
                   * {@link KeyResultConstants#LIVENESS_CARD_REAR_RESULT}
                   */
                  final String dataLivenessCardRearResult = data.getStringExtra(KeyResultConstants.LIVENESS_CARD_REAR_RESULT);

                  /**
                   * Dữ liệu bóc tách thông tin compare face
                   * {@link KeyResultConstants#COMPARE_RESULT}
                   */
                  final String dataCompareResult = data.getStringExtra(KeyResultConstants.COMPARE_RESULT);

                  /**
                   * Dữ liệu bóc tách thông tin liveness face
                   * {@link KeyResultConstants#LIVENESS_FACE_RESULT}
                   */
                  final String dataLivenessFaceResult = data.getStringExtra(KeyResultConstants.LIVENESS_FACE_RESULT);

                  /**
                   * Dữ liệu bóc tách thông tin mask face
                   * {@link KeyResultConstants#MASKED_FACE_RESULT}
                   */
                  final String dataMaskedFaceResult = data.getStringExtra(KeyResultConstants.MASKED_FACE_RESULT);

                  /**
                   * đường dẫn ảnh mặt trước trong thẻ chip lưu trong cache
                   * {@link KeyResultConstantsNFC#IMAGE_AVATAR_CARD_NFC}
                   */
                  final String avatarPath = data.getStringExtra(KeyResultConstantsNFC.IMAGE_AVATAR_CARD_NFC);

                  /**
                   * chuỗi thông tin cua SDK
                   * {@link KeyResultConstantsNFC#CLIENT_SESSION_RESULT}
                   */
                  final String clientSession = data.getStringExtra(KeyResultConstantsNFC.CLIENT_SESSION_RESULT);

                  /**
                   * kết quả NFC
                   * {@link KeyResultConstantsNFC#LOG_NFC}
                   */
                  final String logNFC = data.getStringExtra(KeyResultConstantsNFC.LOG_NFC);

                  /**
                   * mã hash avatar
                   * {@link KeyResultConstantsNFC#HASH_AVATAR}
                   */
                  final String hashAvatar = data.getStringExtra(KeyResultConstantsNFC.HASH_AVATAR);

                  /**
                   * chuỗi json string chứa thông tin post code của quê quán
                   * {@link KeyResultConstantsNFC#POST_CODE_ORIGINAL_LOCATION_RESULT}
                   */
                  final String postCodeOriginalLocation = data.getStringExtra(KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT);

                  /**
                   * chuỗi json string chứa thông tin post code của nơi thường trú
                   * {@link KeyResultConstantsNFC#POST_CODE_RECENT_LOCATION_RESULT}
                   */
                  final String postCodeRecentLocation = data.getStringExtra(KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT);

                  /**
                   * time scan nfc
                   * {@link KeyResultConstantsNFC#TIME_SCAN_NFC}
                   */
                  final String timeScanNfc = data.getStringExtra(KeyResultConstantsNFC.TIME_SCAN_NFC);

                  /**
                   * kết quả check chip căn cước công dân
                   * {@link KeyResultConstantsNFC#CHECK_AUTH_CHIP_RESULT}
                   */
                  final String checkAuthChipResult = data.getStringExtra(KeyResultConstantsNFC.CHECK_AUTH_CHIP_RESULT);

                  /**
                   * kết quả quét QRCode căn cước công dân
                   * {@link KeyResultConstantsNFC#QR_CODE_RESULT_NFC}
                   */
                  final String qrCodeResult = data.getStringExtra(KeyResultConstantsNFC.QR_CODE_RESULT_NFC);

                  final JsonObject json = new JsonObject();
                  /** eKYC **/
                  putSafe(json, KeyResultConstants.INFO_RESULT, dataInfoResult);
                  putSafe(json, KeyResultConstants.LIVENESS_CARD_FRONT_RESULT, dataLivenessCardFrontResult);
                  putSafe(json, KeyResultConstants.LIVENESS_CARD_REAR_RESULT, dataLivenessCardRearResult);
                  putSafe(json, KeyResultConstants.COMPARE_RESULT, dataCompareResult);
                  putSafe(json, KeyResultConstants.LIVENESS_FACE_RESULT, dataLivenessFaceResult);
                  putSafe(json, KeyResultConstants.MASKED_FACE_RESULT, dataMaskedFaceResult);

                  /** NFC **/
                  putSafe(json, KeyResultConstantsNFC.IMAGE_AVATAR_CARD_NFC, avatarPath);
                  putSafe(json, KeyResultConstantsNFC.CLIENT_SESSION_RESULT, clientSession);
                  putSafe(json, KeyResultConstantsNFC.LOG_NFC, logNFC);
                  putSafe(json, KeyResultConstantsNFC.HASH_AVATAR, hashAvatar);
                  putSafe(
                       json,
                       KeyResultConstantsNFC.POST_CODE_ORIGINAL_LOCATION_RESULT,
                       postCodeOriginalLocation
                  );
                  putSafe(
                       json,
                       KeyResultConstantsNFC.POST_CODE_RECENT_LOCATION_RESULT,
                       postCodeRecentLocation
                  );
                  putSafe(json, KeyResultConstantsNFC.TIME_SCAN_NFC, timeScanNfc);
                  putSafe(json, KeyResultConstantsNFC.CHECK_AUTH_CHIP_RESULT, checkAuthChipResult);
                  putSafe(json, KeyResultConstantsNFC.QR_CODE_RESULT_NFC, qrCodeResult);

                  mEkycPromise.resolve(json.toString());
               }
            }
         }
      };
      reactContext.addActivityEventListener(activityEventListener);
   }

   private void putSafe(final JsonObject json, final String key, final String value) {
      if (!TextUtils.isEmpty(value)) {
         json.addProperty(key, value);
      }
   }

   @NonNull
   @Override
   public String getName() {
      return "EkycNfcBridge";
   }

   private boolean isDeviceSupportedNfc(Activity activity) {
      final NfcAdapter adapter = ((NfcManager) activity.getSystemService(Context.NFC_SERVICE)).getDefaultAdapter();
      return adapter != null && adapter.isEnabled();
   }

   // Phương thức thực hiện eKYC luồng đầy đủ bao gồm: Chụp ảnh giấy tờ và chụp ảnh chân dung
   // Bước 1 - chụp ảnh chân dung xa gần
   // Bước 2 - hiển thị kết quả
   @ReactMethod
   private void startEkycFace(final String args, final Promise promise) {
      final Activity currentActivity = getCurrentActivity();
      if (currentActivity == null) {
         return;
      }

      mEkycPromise = promise;

      final Intent intent = getBaseIntent(args, currentActivity, VnptPortraitActivity.class);

      // Giá trị này xác định phiên bản khi sử dụng Máy ảnh tại bước chụp ảnh chân dung luồng full. Mặc định là Normal ✓
      // - Normal: chụp ảnh chân dung 1 hướng
      // - ADVANCED: chụp ảnh chân dung xa gần
      intent.putExtra(KeyIntentConstants.VERSION_SDK, SDKEnum.VersionSDKEnum.ADVANCED.getValue());

      // Bật/[Tắt] chức năng So sánh ảnh trong thẻ và ảnh chân dung
      intent.putExtra(KeyIntentConstants.IS_COMPARE_FLOW, false);

      // Bật/Tắt chức năng kiểm tra che mặt
      intent.putExtra(KeyIntentConstants.IS_CHECK_MASKED_FACE, true);

      // Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
      // - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
      // - IBeta: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
      // - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
      intent.putExtra(KeyIntentConstants.CHECK_LIVENESS_FACE, SDKEnum.ModeCheckLiveNessFace.iBETA.getValue());

      currentActivity.startActivityForResult(intent, EKYC_REQUEST_CODE);
   }


   // Phương thức thực hiện eKYC luồng "Chụp ảnh giấy tờ"
   // Bước 1 - chụp ảnh giấy tờ
   // Bước 2 - hiển thị kết quả
   @ReactMethod
   private void startEkycOcr(final String args, final Promise promise) {
      final Activity currentActivity = getCurrentActivity();
      if (currentActivity == null) {
         return;
      }

      mEkycPromise = promise;

      final Intent intent = getBaseIntent(args, currentActivity, VnptOcrActivity.class);

      // Giá trị này xác định kiểu giấy tờ để sử dụng:
      // - IdentityCard: Chứng minh thư nhân dân, Căn cước công dân
      // - IDCardChipBased: Căn cước công dân gắn Chip
      // - Passport: Hộ chiếu
      // - DriverLicense: Bằng lái xe
      // - MilitaryIdCard: Chứng minh thư quân đội
      intent.putExtra(KeyIntentConstants.DOCUMENT_TYPE, SDKEnum.DocumentTypeEnum.IDENTITY_CARD.getValue());

      // Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
      intent.putExtra(KeyIntentConstants.IS_CHECK_LIVENESS_CARD, true);

      // Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
      // - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
      // - Basic: Kiểm tra sau khi chụp ảnh
      // - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
      // - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
      intent.putExtra(KeyIntentConstants.TYPE_VALIDATE_DOCUMENT, SDKEnum.TypeValidateDocument.Basic.getValue());

      currentActivity.startActivityForResult(intent, EKYC_REQUEST_CODE);
   }

   // Phương thức thực hiện eKYC luồng đầy đủ bao gồm: Chụp ảnh giấy tờ và chụp ảnh chân dung
   // Bước 1 - chụp ảnh giấy tờ
   // Bước 2 - chụp ảnh chân dung xa gần
   // Bước 3 - hiển thị kết quả
   @ReactMethod
   private void startEkycFull(final String args, final Promise promise) {
      final Activity currentActivity = getCurrentActivity();
      if (currentActivity == null) {
         return;
      }

      mEkycPromise = promise;

      final Intent intent = getBaseIntent(args, currentActivity, VnptIdentityActivity.class);

      // Giá trị này xác định kiểu giấy tờ để sử dụng:
      // - IDENTITY_CARD: Chứng minh thư nhân dân, Căn cước công dân
      // - IDCardChipBased: Căn cước công dân gắn Chip
      // - Passport: Hộ chiếu
      // - DriverLicense: Bằng lái xe
      // - MilitaryIdCard: Chứng minh thư quân đội
      intent.putExtra(KeyIntentConstants.DOCUMENT_TYPE, SDKEnum.DocumentTypeEnum.IDENTITY_CARD.getValue());

      // Bật/Tắt chức năng So sánh ảnh trong thẻ và ảnh chân dung
      intent.putExtra(KeyIntentConstants.IS_COMPARE_FLOW, true);

      // Bật/Tắt chức năng kiểm tra ảnh giấy tờ chụp trực tiếp (liveness card)
      intent.putExtra(KeyIntentConstants.IS_CHECK_LIVENESS_CARD, true);

      // Lựa chọn chức năng kiểm tra ảnh chân dung chụp trực tiếp (liveness face)
      // - NoneCheckFace: Không thực hiện kiểm tra ảnh chân dung chụp trực tiếp hay không
      // - iBETA: Kiểm tra ảnh chân dung chụp trực tiếp hay không iBeta (phiên bản hiện tại)
      // - Standard: Kiểm tra ảnh chân dung chụp trực tiếp hay không Standard (phiên bản mới)
      intent.putExtra(KeyIntentConstants.CHECK_LIVENESS_FACE, SDKEnum.ModeCheckLiveNessFace.iBETA.getValue());

      // Bật/Tắt chức năng kiểm tra che mặt
      intent.putExtra(KeyIntentConstants.IS_CHECK_MASKED_FACE, true);

      // Lựa chọn chế độ kiểm tra ảnh giấy tờ ngay từ SDK
      // - None: Không thực hiện kiểm tra ảnh khi chụp ảnh giấy tờ
      // - Basic: Kiểm tra sau khi chụp ảnh
      // - MediumFlip: Kiểm tra ảnh hợp lệ trước khi chụp (lật giấy tờ thành công → hiển thị nút chụp)
      // - Advance: Kiểm tra ảnh hợp lệ trước khi chụp (hiển thị nút chụp)
      intent.putExtra(KeyIntentConstants.TYPE_VALIDATE_DOCUMENT, SDKEnum.TypeValidateDocument.Basic.getValue());

      // Giá trị này xác định việc có xác thực số ID với mã tỉnh thành, quận huyện, xã phường tương ứng hay không.
      intent.putExtra(KeyIntentConstants.IS_VALIDATE_POSTCODE, true);

      // Giá trị này xác định phiên bản khi sử dụng Máy ảnh tại bước chụp ảnh chân dung luồng full. Mặc định là Normal ✓
      // - Normal: chụp ảnh chân dung 1 hướng
      // - ProOval: chụp ảnh chân dung xa gần
      intent.putExtra(KeyIntentConstants.VERSION_SDK, SDKEnum.VersionSDKEnum.ADVANCED.getValue());

      currentActivity.startActivityForResult(intent, EKYC_REQUEST_CODE);
   }

   private Intent getBaseIntent(final String args, final Activity activity, final Class<?> clazz) {
      final Intent intent = new Intent(activity, clazz);

      final JsonObject json = JsonParser.parseString(args).getAsJsonObject();

      // Nhập thông tin bộ mã truy cập. Lấy tại mục Quản lý Token https://ekyc.vnpt.vn/admin-dashboard/console/project-manager
      intent.putExtra(KeyIntentConstants.ACCESS_TOKEN, json.get("access_token").getAsString());
      intent.putExtra(KeyIntentConstants.TOKEN_ID, json.get("token_id").getAsString());
      intent.putExtra(KeyIntentConstants.TOKEN_KEY, json.get("token_key").getAsString());

      // Giá trị này dùng để đảm bảo mỗi yêu cầu (request) từ phía khách hàng sẽ không bị thay đổi.
      intent.putExtra(KeyIntentConstants.CHALLENGE_CODE, "INNOVATIONCENTER");

      // Ngôn ngữ sử dụng trong SDK
      // - VIETNAMESE: Tiếng Việt
      // - ENGLISH: Tiếng Anh
      intent.putExtra(KeyIntentConstants.LANGUAGE_SDK, SDKEnum.LanguageEnum.VIETNAMESE.getValue());

      // Bật/Tắt Hiển thị màn hình hướng dẫn
      intent.putExtra(KeyIntentConstants.IS_SHOW_TUTORIAL, true);

      // Bật chức năng hiển thị nút bấm "Bỏ qua hướng dẫn" tại các màn hình hướng dẫn bằng video
      intent.putExtra(KeyIntentConstants.IS_ENABLE_GOT_IT, true);

      // Sử dụng máy ảnh mặt trước
      // - FRONT: Camera trước
      // - BACK: Camera trước
      intent.putExtra(KeyIntentConstants.CAMERA_POSITION_FOR_PORTRAIT, SDKEnum.CameraTypeEnum.FRONT.getValue());

      return intent;
   }

   @ReactMethod
   private void navigateToNfcQrCode(final String args, final Promise promise) {
      final Activity activity = getCurrentActivity();
      if (activity == null) return;

      mEkycPromise = promise;
      if (!isDeviceSupportedNfc(activity)) {
         mEkycPromise.reject(EKYC_REJECT_CODE, "Thiết bị không hỗ trợ NFC");
         return;
      }

      final JsonObject json = JsonParser.parseString(args).getAsJsonObject();

      final Intent intent = new Intent(activity, VnptScanNFCActivity.class);
      /*
       * Truyền access token chứa bearer
       */
      intent.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN, json.get("access_token").getAsString());
      /*
       * Truyền token id
       */
      intent.putExtra(KeyIntentConstantsNFC.TOKEN_ID, json.get("token_id").getAsString());
      /*
       * Truyền token key
       */
      intent.putExtra(KeyIntentConstantsNFC.TOKEN_KEY, json.get("token_key").getAsString());
      /*
       * điều chỉnh ngôn ngữ tiếng việt
       *    - vi: tiếng việt
       *    - en: tiếng anh
       */
      intent.putExtra(KeyIntentConstantsNFC.LANGUAGE_NFC, SDKEnumNFC.LanguageEnum.VIETNAMESE.getValue());
      /*
       * hiển thị màn hình hướng dẫn + hiển thị nút bỏ qua hướng dẫn
       * - mặc định luôn luôn hiển thị màn hình hướng dẫn
       *    - true: hiển thị nút bỏ qua
       *    - false: ko hiển thị nút bỏ qua
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_GOT_IT, true);
      /*
       * bật tính năng upload ảnh
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_UPLOAD_IMAGE, true);
      /*
       * bật tính năng get Postcode
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_MAPPING_ADDRESS, true);
      /*
       * bật tính năng xác thực chip
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_VERIFY_CHIP, true);
      /*
       * truyền các giá trị đọc thẻ
       *    - nếu không truyền gì mặc định sẽ đọc tất cả (MRZ,Verify Document,Image Avatar)
       *    - giá trị truyền vào là 1 mảng int: nếu muốn đọc giá trị nào sẽ truyền
       *      giá trị đó vào mảng
       * eg: chỉ đọc thông tin MRZ
       *    new int[]{SDKEnumNFC.ReadingNFCTags.MRZInfo.getValue()}
       */
      intent.putExtra(
           KeyIntentConstantsNFC.READING_TAG_NFC,
           new int[]{
                SDKEnumNFC.ReadingNFCTags.MRZInfo.getValue(),
                SDKEnumNFC.ReadingNFCTags.VerifyDocumentInfo.getValue(),
                SDKEnumNFC.ReadingNFCTags.ImageAvatarInfo.getValue()
           }
      );
      /*
       * truyền giá trị bật quét QRCode
       *    - true: tắt quét QRCode
       *    - false: bật quét QRCode
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_TURN_OFF_QR_CODE, false);
      // set baseDomain="" => sử dụng mặc định là Product
      intent.putExtra(KeyIntentConstantsNFC.CHANGE_BASE_URL_NFC, "");

      activity.startActivityForResult(intent, EKYC_REQUEST_CODE);
   }

   @ReactMethod
   private void navigateToScanNfc(final String args, final Promise promise) {
      final Activity activity = getCurrentActivity();
      if (activity == null) return;

      mEkycPromise = promise;
      if (!isDeviceSupportedNfc(activity)) {
         mEkycPromise.reject(EKYC_REJECT_CODE, "Thiết bị không hỗ trợ NFC");
         return;
      }

      final JsonObject json = JsonParser.parseString(args).getAsJsonObject();

      final Intent intent = new Intent(activity, VnptScanNFCActivity.class);
      /*
       * Truyền access token chứa bearer
       */
      intent.putExtra(KeyIntentConstantsNFC.ACCESS_TOKEN, json.get("access_token").getAsString());
      /*
       * Truyền token id
       */
      intent.putExtra(KeyIntentConstantsNFC.TOKEN_ID, json.get("token_id").getAsString());
      /*
       * Truyền token key
       */
      intent.putExtra(KeyIntentConstantsNFC.TOKEN_KEY, json.get("token_key").getAsString());
      /*
       * điều chỉnh ngôn ngữ tiếng việt
       *    - vi: tiếng việt
       *    - en: tiếng anh
       */
      intent.putExtra(KeyIntentConstantsNFC.LANGUAGE_NFC, SDKEnumNFC.LanguageEnum.VIETNAMESE.getValue());
      /*
       * hiển thị màn hình hướng dẫn + hiển thị nút bỏ qua hướng dẫn
       * - mặc định luôn luôn hiển thị màn hình hướng dẫn
       *    - true: hiển thị nút bỏ qua
       *    - false: ko hiển thị nút bỏ qua
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_GOT_IT, true);
      /*
       * bật tính năng upload ảnh
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_UPLOAD_IMAGE, true);
      /*
       * bật tính năng get Postcode
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_MAPPING_ADDRESS, true);
      /*
       * bật tính năng xác thực chip
       *    - true: bật tính năng
       *    - false: tắt tính năng
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_ENABLE_VERIFY_CHIP, true);
      /*
       * truyền các giá trị đọc thẻ
       *    - nếu không truyền gì mặc định sẽ đọc tất cả (MRZ,Verify Document,Image Avatar)
       *    - giá trị truyền vào là 1 mảng int: nếu muốn đọc giá trị nào sẽ truyền
       *      giá trị đó vào mảng
       * eg: chỉ đọc thông tin MRZ
       *    new int[]{SDKEnumNFC.ReadingNFCTags.MRZInfo.getValue()}
       */
      intent.putExtra(
           KeyIntentConstantsNFC.READING_TAG_NFC,
           new int[]{
                SDKEnumNFC.ReadingNFCTags.MRZInfo.getValue(),
                SDKEnumNFC.ReadingNFCTags.VerifyDocumentInfo.getValue(),
                SDKEnumNFC.ReadingNFCTags.ImageAvatarInfo.getValue()
           }
      );
      /*
       * truyền giá trị bật quét QRCode
       *    - true: tắt quét QRCode
       *    - false: bật quét QRCode
       */
      intent.putExtra(KeyIntentConstantsNFC.IS_TURN_OFF_QR_CODE, true);
      // set baseDomain="" => sử dụng mặc định là Product
      intent.putExtra(KeyIntentConstantsNFC.CHANGE_BASE_URL_NFC, "");
      // truyền id định danh căn cước công dân
      intent.putExtra(KeyIntentConstantsNFC.ID_NUMBER_CARD, json.get("card_id").getAsString());
      // truyền ngày sinh ghi trên căn cước công dân
      intent.putExtra(KeyIntentConstantsNFC.BIRTHDAY_CARD, json.get("card_dob").getAsString());
      // truyền ngày hết hạn căn cước công dân
      intent.putExtra(KeyIntentConstantsNFC.EXPIRED_CARD, json.get("card_expire_date").getAsString());

      activity.startActivityForResult(intent, EKYC_REQUEST_CODE);
   }
}
