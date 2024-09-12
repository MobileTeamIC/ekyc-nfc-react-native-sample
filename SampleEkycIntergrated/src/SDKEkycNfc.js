import {NativeModules} from "react-native";

const {EkycNfcBridge} = NativeModules;
const SDKEkycNfc = {};

SDKEkycNfc.startEkycFull = async function () {
  try {
    const json = JSON.stringify({
      access_token: '<ACCESS_TOKEN> (including bearer)',
      token_id: '<TOKEN_ID>',
      token_key: '<TOKEN_KEY>',
    });
    return await EkycNfcBridge.startEkycFull(json)
  } catch (e) {
    return {
      'error': e.message
    }
  }
};

SDKEkycNfc.startEkycOcr = async function () {
  try {
    const json = JSON.stringify({
      access_token: '<ACCESS_TOKEN> (including bearer)',
      token_id: '<TOKEN_ID>',
      token_key: '<TOKEN_KEY>',
    });
    return await EkycNfcBridge.startEkycOcr(json)
  } catch (e) {
    return {
      'error': e.message
    }
  }
};

SDKEkycNfc.startEkycFace = async function () {
  try {
    const json = JSON.stringify({
      access_token: '<ACCESS_TOKEN> (including bearer)',
      token_id: '<TOKEN_ID>',
      token_key: '<TOKEN_KEY>',
    });
    return await EkycNfcBridge.startEkycFace(json)
  } catch (e) {
    return {
      'error': e.message
    }
  }
};

SDKEkycNfc.navigateToScanNfc = async function (cardId, cardDob, cardExpireDate) {
  try {
    const json = JSON.stringify({
      access_token: '<ACCESS_TOKEN> (including bearer)',
      token_id: '<TOKEN_ID>',
      token_key: '<TOKEN_KEY>',
      card_id: cardId,
      card_dob: cardDob,
      card_expire_date: cardExpireDate,
    });
    return await EkycNfcBridge.navigateToScanNfc(json)
  } catch (e) {
    return {
      'error': e.message
    }
  }
};

SDKEkycNfc.navigateToNfcQrCode = async function () {
  try {
    const json = JSON.stringify({
      access_token: '<ACCESS_TOKEN> (including bearer)',
      token_id: '<TOKEN_ID>',
      token_key: '<TOKEN_KEY>',
    });
    return await EkycNfcBridge.navigateToNfcQrCode(json)
  } catch (e) {
    return {
      'error': e.message
    }
  }
};

export default SDKEkycNfc;
