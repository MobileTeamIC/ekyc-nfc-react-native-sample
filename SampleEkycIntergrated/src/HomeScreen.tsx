import React, {useState} from 'react';
import {Alert, Platform, SafeAreaView, StyleSheet, ToastAndroid, View,} from 'react-native';
import {useNavigation} from '@react-navigation/native';
import {NativeStackNavigationProp} from '@react-navigation/native-stack';
import {AppStackParamList} from './Routes';
import {Appbar, Button, Dialog, HelperText, Portal, TextInput, useTheme,} from 'react-native-paper';
import SDKEkycNfc from "./SDKEkycNfc";

export type LogResult = {
  /** nfc */
  imageAvatarCardNfc?: string;
  clientSessionResult?: string;
  logNfc?: string;
  hashAvatar?: string;
  postCodeOriginalLocation?: string;
  postCodeRecentLocation?: string;
  timeScanNfc?: string;
  checkAuthChipResult?: string;
  qrCodeResult?: string;
  /** ekyc */
  logOcr?: string;
  logLivNessCardFront?: string;
  logLiveNessCardRear?: string;
  logCompare?: string;
  logLiveNessFace?: string;
  logMaskFace?: string;
};

type UserIdentityInfo = {
  cardId: string;
  cardDob: string;
  cardExpireDate: string;
};

const resultEKYCToLogResult = (result: any): LogResult => {
  return {
    /** nfc */
    imageAvatarCardNfc: result.IMAGE_AVATAR_CARD_NFC,
    clientSessionResult: result.CLIENT_SESSION_RESULT,
    logNfc: result.LOG_NFC,
    hashAvatar: result.HASH_AVATAR,
    postCodeOriginalLocation: result.POST_CODE_ORIGINAL_LOCATION_RESULT,
    postCodeRecentLocation: result.POST_CODE_RECENT_LOCATION_RESULT,
    timeScanNfc: result.TIME_SCAN_NFC,
    checkAuthChipResult: result.CHECK_AUTH_CHIP_RESULT,
    qrCodeResult: result.QR_CODE_RESULT_NFC,
    /** ekyc */
    logOcr: result.INFO_RESULT,
    logLivNessCardFront: result.LIVENESS_CARD_FRONT_RESULT,
    logLiveNessCardRear: result.LIVENESS_CARD_REAR_RESULT,
    logCompare: result.COMPARE_RESULT,
    logLiveNessFace: result.LIVENESS_FACE_RESULT,
    logMaskFace: result.MASKED_FACE_RESULT,
  };
};

const isNullOrUndefined = (value?: string): boolean => {
  return value === null || value === undefined || value === 'undefined';
};

const isResultLogValid = (result: LogResult): boolean => {
  return (
    !isNullOrUndefined(result.imageAvatarCardNfc) ||
    !isNullOrUndefined(result.clientSessionResult) ||
    !isNullOrUndefined(result.logNfc) ||
    !isNullOrUndefined(result.hashAvatar) ||
    !isNullOrUndefined(result.postCodeOriginalLocation) ||
    !isNullOrUndefined(result.postCodeRecentLocation) ||
    !isNullOrUndefined(result.timeScanNfc) ||
    !isNullOrUndefined(result.checkAuthChipResult) ||
    !isNullOrUndefined(result.qrCodeResult) ||
    !isNullOrUndefined(result.logOcr) ||
    !isNullOrUndefined(result.logCompare) ||
    !isNullOrUndefined(result.logMaskFace) ||
    !isNullOrUndefined(result.logLiveNessFace) ||
    !isNullOrUndefined(result.logLiveNessCardRear) ||
    !isNullOrUndefined(result.logLivNessCardFront)
  );
};

const HomeScreen = (): React.JSX.Element => {
  const navigation =
    useNavigation<NativeStackNavigationProp<AppStackParamList>>();
  const theme = useTheme();

  const [info, setInfo] = useState<UserIdentityInfo>({
    cardId: '',
    cardDob: '',
    cardExpireDate: '',
  });
  const [visible, setVisible] = useState(false);

  const showDialog = () => {
    setInfo({
      cardId: '',
      cardDob: '',
      cardExpireDate: '',
    });
    setVisible(true);
  };

  const hideDialog = () => {
    setVisible(false);
  };

  const navigateToLog = (result: any) => {
    const logResult = resultEKYCToLogResult(JSON.parse(result));
    if (isResultLogValid(logResult)) {
      navigation.navigate('Log', logResult);
    }
  };

  const notifyMessage = (msg: string) => {
    if (Platform.OS === 'android') {
      ToastAndroid.show(msg, ToastAndroid.SHORT);
    } else {
      Alert.alert(msg);
    }
  };

  const openEKYCFull = async (): Promise<void> => {
    navigateToLog(await SDKEkycNfc.startEkycFull());
  };

  const openEKYCOcr = async (): Promise<void> => {
    navigateToLog(await SDKEkycNfc.startEkycOcr());
  };

  const openEKYCFace = async (): Promise<void> => {
    navigateToLog(await SDKEkycNfc.startEkycFace());
  };

  const navigateToNfcQrCode = async (): Promise<void> => {
    const response = await SDKEkycNfc.navigateToNfcQrCode();
    if (response.error) {
      notifyMessage(response.error);
    } else {
      navigateToLog(response)
    }
  };

  const navigateToScanNfc = async (): Promise<void> => {
    hideDialog();
    const response = await SDKEkycNfc.navigateToScanNfc(
      info.cardId,
      info.cardDob,
      info.cardExpireDate
    );
    if (response.error) {
      notifyMessage(response.error);
    } else {
      navigateToLog(response)
    }
  };

  return (
    <SafeAreaView style={styles.container}>
      <Appbar.Header style={{backgroundColor: theme.colors.primary}}>
        <Appbar.Content
          title="Tích hợp SDK VNPT eKYC NFC"
          color={theme.colors.surface}
          style={styles.centeredTitle}
        />
      </Appbar.Header>
      <View style={styles.container}>
        <View style={styles.spacingMedium}/>
        <Button 
          onPress={openEKYCFull} 
          mode="elevated"
          style={styles.button}>
          Thực hiện luồng đầy đủ
        </Button>
        <Button 
          onPress={openEKYCOcr}
          mode="elevated"
          style={styles.button}>
          Thực hiện OCR giấy tờ
        </Button>
        <Button 
          onPress={openEKYCFace}
          mode="elevated"
          style={styles.button}>
          Thực hiện kiểm tra khuôn mặt
        </Button>
        <Button
          onPress={navigateToNfcQrCode}
          mode="elevated"
          style={styles.button}>
          Thực hiện quét QR ={'>'} Đọc chip NFC
        </Button>
        <Button onPress={showDialog} mode="elevated" style={styles.button}>
          Thực hiện Đọc chip NFC
        </Button>
      </View>
      <Portal>
        <Dialog visible={visible} onDismiss={hideDialog}>
          <Dialog.Title>Nhập thông tin</Dialog.Title>
          <Dialog.Content>
            <TextInput
              label="Nhập số ID"
              value={info.cardId}
              inputMode={'numeric'}
              maxLength={12}
              onChangeText={text => setInfo({...info, cardId: text})}
            />
            <View style={styles.marginSmall}>
              <TextInput
                label="Nhập ngày sinh"
                value={info.cardDob}
                inputMode={'numeric'}
                maxLength={6}
                onChangeText={text => setInfo({...info, cardDob: text})}
              />
              <HelperText type="info" visible>
                * Định dạng: yyMMdd, vd: 950614
              </HelperText>
            </View>
            <View style={styles.marginSmall}>
              <TextInput
                label="Nhập ngày hết hạn"
                value={info.cardExpireDate}
                inputMode={'numeric'}
                maxLength={6}
                onChangeText={text => setInfo({...info, cardExpireDate: text})}
              />
              <HelperText type="info" visible>
                * Định dạng: yyMMdd, vd: 950614
              </HelperText>
            </View>
          </Dialog.Content>
          <Dialog.Actions>
            <Button onPress={hideDialog}>Hủy</Button>
            <Button onPress={navigateToScanNfc}>Quét NFC</Button>
          </Dialog.Actions>
        </Dialog>
      </Portal>
    </SafeAreaView>
  );
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
  },
  button: {
    marginHorizontal: 16,
    marginVertical: 8,
  },
  spacingMedium: {
    height: 16,
  },
  marginSmall: {
    marginTop: 8,
  },
  centeredTitle: {
    justifyContent: 'center',
    alignItems: 'center',
  },
});

export default HomeScreen;
