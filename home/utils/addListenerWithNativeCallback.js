import { DeviceEventEmitter, NativeModules } from 'react-native';

const { ExponentKernel } = NativeModules;

const addListenerWithNativeCallback = (eventName, eventListener) => {
  console.log("trying to add eventLiseter for name " + eventName);
  if (ExponentKernel) {
    console.log("kernel is present");
    DeviceEventEmitter.addListener(eventName, async (event) => {
      try {
        let result = await eventListener(event);
        if (!result) {
          result = {};
        }
        ExponentKernel.onEventSuccess(event.eventId, result);
      } catch (e) {
        ExponentKernel.onEventFailure(event.eventId, e.message);
      }
    });
  }
};

export default addListenerWithNativeCallback;
