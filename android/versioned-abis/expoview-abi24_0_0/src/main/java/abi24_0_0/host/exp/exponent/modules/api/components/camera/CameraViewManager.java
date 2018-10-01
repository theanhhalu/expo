package abi24_0_0.host.exp.exponent.modules.api.components.camera;

import android.Manifest;
import android.graphics.Bitmap;
import android.os.Build;
import android.support.annotation.Nullable;

import abi24_0_0.com.facebook.react.bridge.Promise;
import abi24_0_0.com.facebook.react.bridge.ReadableArray;
import abi24_0_0.com.facebook.react.bridge.ReadableMap;
import abi24_0_0.com.facebook.react.common.MapBuilder;
import abi24_0_0.com.facebook.react.uimanager.ThemedReactContext;
import abi24_0_0.com.facebook.react.uimanager.ViewGroupManager;
import abi24_0_0.com.facebook.react.uimanager.annotations.ReactProp;
import com.google.android.cameraview.AspectRatio;

import java.nio.ByteBuffer;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Set;

import abi24_0_0.host.exp.exponent.modules.api.components.camera.tasks.ResolveTakenPictureAsyncTask;
import host.exp.expoview.Exponent;

public class CameraViewManager extends ViewGroupManager<ExpoCameraView> {
  public enum Events {
    EVENT_CAMERA_READY("onCameraReady"),
    EVENT_ON_MOUNT_ERROR("onMountError"),
    EVENT_ON_BAR_CODE_READ("onBarCodeRead"),
    EVENT_ON_FACES_DETECTED("onFacesDetected"),
    EVENT_ON_FACE_DETECTION_ERROR("onFaceDetectionError");

    private final String mName;

    Events(final String name) {
      mName = name;
    }

    @Override
    public String toString() {
      return mName;
    }
  }

  private static final String REACT_CLASS = "ExponentCamera";

  private static CameraViewManager instance;
  private ExpoCameraView mCameraView;

  public CameraViewManager() {
    super();
    instance = this;
  }

  public static CameraViewManager getInstance() { return instance; }

  @Override
  public String getName() {
    return REACT_CLASS;
  }

  @Override
  protected ExpoCameraView createViewInstance(ThemedReactContext themedReactContext) {
    mCameraView = new ExpoCameraView(themedReactContext);
    return mCameraView;
  }

  @Override
  @Nullable
  public Map<String, Object> getExportedCustomDirectEventTypeConstants() {
    MapBuilder.Builder<String, Object> builder = MapBuilder.builder();
    for (Events event : Events.values()) {
      builder.put(event.toString(), MapBuilder.of("registrationName", event.toString()));
    }
    return builder.build();
  }

  @ReactProp(name = "type")
  public void setType(ExpoCameraView view, int type) {
    view.setFacing(type);
  }

  @ReactProp(name = "ratio")
  public void setRatio(ExpoCameraView view, String ratio) {
    view.setAspectRatio(AspectRatio.parse(ratio));
  }

  @ReactProp(name = "flashMode")
  public void setFlashMode(ExpoCameraView view, int torchMode) {
    view.setFlash(torchMode);
  }

  @ReactProp(name = "autoFocus")
  public void setAutoFocus(ExpoCameraView view, boolean autoFocus) {
    view.setAutoFocus(autoFocus);
  }

  @ReactProp(name = "focusDepth")
  public void setFocusDepth(ExpoCameraView view, float depth) {
    view.setFocusDepth(depth);
  }

  @ReactProp(name = "zoom")
  public void setZoom(ExpoCameraView view, float zoom) {
    view.setZoom(zoom);
  }

  @ReactProp(name = "whiteBalance")
  public void setWhiteBalance(ExpoCameraView view, int whiteBalance) {
    view.setWhiteBalance(whiteBalance);
  }

  @ReactProp(name = "barCodeTypes")
  public void setBarCodeTypes(ExpoCameraView view, ReadableArray barCodeTypes) {
    if (barCodeTypes == null) {
      return;
    }
    List<String> result = new ArrayList<>(barCodeTypes.size());
    for (int i = 0; i < barCodeTypes.size(); i++) {
      result.add(barCodeTypes.getString(i));
    }
    view.setBarCodeTypes(result);
  }

  @ReactProp(name = "barCodeScannerEnabled")
  public void setBarCodeScanning(ExpoCameraView view, boolean barCodeScannerEnabled) {
    view.setShouldScanBarCodes(barCodeScannerEnabled);
  }

  @ReactProp(name = "faceDetectorEnabled")
  public void setFaceDetecting(ExpoCameraView view, boolean faceDetectorEnabled) {
    view.setShouldDetectFaces(faceDetectorEnabled);
  }

  @ReactProp(name = "faceDetectionMode")
  public void setFaceDetectionMode(ExpoCameraView view, int mode) {
    view.setFaceDetectionMode(mode);
  }

  @ReactProp(name = "faceDetectionLandmarks")
  public void setFaceDetectionLandmarks(ExpoCameraView view, int landmarks) {
    view.setFaceDetectionLandmarks(landmarks);
  }

  @ReactProp(name = "faceDetectionClassifications")
  public void setFaceDetectionClassifications(ExpoCameraView view, int classifications) {
    view.setFaceDetectionClassifications(classifications);
  }

  public void takePicture(ReadableMap options, Promise promise) {
    if (!Build.FINGERPRINT.contains("generic")) {
      if (mCameraView.isCameraOpened()) {
        mCameraView.takePicture(options, promise);
      } else {
        promise.reject("E_CAMERA_UNAVAILABLE", "Camera is not running");
      }
    } else {
      Bitmap image = ExpoCameraViewHelper.generateSimulatorPhoto(mCameraView.getWidth(), mCameraView.getHeight());
      ByteBuffer byteBuffer = ByteBuffer.allocate(image.getRowBytes() * image.getHeight());
      image.copyPixelsToBuffer(byteBuffer);
      new ResolveTakenPictureAsyncTask(byteBuffer.array(), promise, options).execute();
    }
  }

  public void record(final ReadableMap options, final Promise promise) {
    if (mCameraView.isCameraOpened()) {
      mCameraView.record(options, promise);
    } else {
      promise.reject("E_CAMERA_UNAVAILABLE", "Camera is not running");
    }
  }

  public void stopRecording() {
    if (mCameraView.isCameraOpened()) {
      mCameraView.stopRecording();
    }
  }

  public Set<AspectRatio> getSupportedRatios() {
    if (mCameraView.isCameraOpened()) {
      return mCameraView.getSupportedAspectRatios();
    }
    return null;
  }
}
