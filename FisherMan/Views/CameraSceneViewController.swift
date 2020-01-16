//  
//  CameraSceneViewController.swift
//  FisherMan
//
//  Created by Гранченко Юрий on 13.01.2020.
//  Copyright © 2020 GYS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation

class CameraSceneViewController: BaseViewController<CameraSceneViewModel> {
    
    private var toggledCamera = false
    private let minimumZoom: CGFloat = 1.0
    private let maximumZoom: CGFloat = 5.0
    private var lastZoomFactor: CGFloat = 1.0
    
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentDevice: AVCaptureDevice?
    
    private var stillImageOutput = AVCapturePhotoOutput()
    private var cameraPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private lazy var captureSession: AVCaptureSession = {
        let capture = AVCaptureSession()
        capture.sessionPreset = AVCaptureSession.Preset.photo
        return capture
    }()
    
    private let takePhotoButton = specify(UIButton(), {
           let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 80, weight: .regular)
           let cameraImage = UIImage(systemName: "camera.circle", withConfiguration: buttonConfiguration)
           $0.setImage(cameraImage, for: .normal)
       })
       private let cameraRotateButton = specify(UIButton(), {
           let buttonConfiguration = UIImage.SymbolConfiguration(pointSize: 25, weight: .regular)
           let cameraImage = UIImage(systemName: "camera.rotate", withConfiguration: buttonConfiguration)
           $0.setImage(cameraImage, for: .normal)
       })
    
    override func setupUI() {
        backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
        frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front)
        currentDevice = backCamera
        do {
            guard let currentDevice = currentDevice else { return }
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentDevice)
            if captureSession.canAddInput(captureDeviceInput) {
                captureSession.addInput(captureDeviceInput)
                
                if captureSession.canAddOutput(stillImageOutput) {
                    captureSession.addOutput(stillImageOutput)
                    cameraPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
                    view.layer.addSublayer(cameraPreviewLayer!)
                    cameraPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
                    cameraPreviewLayer?.frame = view.layer.frame
                    captureSession.startRunning()
                } else {
                    Logger.error("captureSession can't add output")
                }
            } else {
                Logger.error("captureSession can't add input")
            }
        } catch {
            Logger.error(error)
        }
        view.add(cameraRotateButton, layoutBlock: { $0.top(30).trailing(20) })
        view.add(takePhotoButton, layoutBlock: { $0.bottom(50).centerX() })
    }
    
    override func setupBindings() {
        view.rx.swipeGesture(.right).when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                if let zoomInFactor = self.currentDevice?.videoZoomFactor {
                    if zoomInFactor < 5.0 {
                        let newZoomInFactor = min(zoomInFactor + 1.0, 5.0)
                        do {
                            try self.currentDevice?.lockForConfiguration()
                            self.currentDevice?.ramp(toVideoZoomFactor: newZoomInFactor, withRate: 1.0)
                            self.currentDevice?.unlockForConfiguration()
                        } catch {
                            Logger.error(error)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        view.rx.swipeGesture(.left).when(.recognized)
            .subscribe(onNext: { [unowned self] _ in
                if let zoomOutFactor = self.currentDevice?.videoZoomFactor {
                    if zoomOutFactor > 1.0 {
                        let newZoomOutFactor = max(zoomOutFactor - 1.0, 1.0)
                        do {
                            try self.currentDevice?.lockForConfiguration()
                            self.currentDevice?.ramp(toVideoZoomFactor: newZoomOutFactor, withRate: 1.0)
                            self.currentDevice?.unlockForConfiguration()
                        } catch {
                            Logger.error(error)
                        }
                    }
                }
            }).disposed(by: disposeBag)
        view.rx.pinchGesture().when(.recognized)
            .subscribe(onNext: { [unowned self] gesture in
                guard let deviceZoomFactor = self.currentDevice?.videoZoomFactor else { return }
                func minMax(_ factor: CGFloat) -> CGFloat {
                    return min(min(max(factor, self.minimumZoom), self.maximumZoom),
                               self.currentDevice!.activeFormat.videoMaxZoomFactor)
                }
                func update(scale factor: CGFloat) {
                    do {
                        try self.currentDevice?.lockForConfiguration()
                        self.currentDevice?.videoZoomFactor = factor
                        self.currentDevice?.unlockForConfiguration()
                    } catch {
                        Logger.error(error)
                    }
                }
                let newScaleFactor = minMax(gesture.scale * self.lastZoomFactor)
                
                switch gesture.state {
                case .changed:
                    update(scale: newScaleFactor)
                case .ended:
                    self.lastZoomFactor = minMax(newScaleFactor)
                    update(scale: self.lastZoomFactor)
                default : break
                }
            }).disposed(by: disposeBag)
        takePhotoButton.rx.tap.subscribe(onNext: { [unowned self] in
            let settings = AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])
            self.stillImageOutput.capturePhoto(with: settings, delegate: self)
        }).disposed(by: disposeBag)
        cameraRotateButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.captureSession.beginConfiguration()
            self.currentDevice = self.toggledCamera ? self.backCamera : self.frontCamera
            self.toggledCamera = !self.toggledCamera
            self.captureSession.inputs.forEach { self.captureSession.removeInput($0) }
            do {
                let newInput = try AVCaptureDeviceInput(device: self.currentDevice!)
                if self.captureSession.canAddInput(newInput) {
                    self.captureSession.addInput(newInput)
                }
            } catch {
                Logger.error(error)
            }
            self.captureSession.commitConfiguration()
        }).disposed(by: disposeBag)
    }
}

extension CameraSceneViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput,
                     didFinishProcessingPhoto photo: AVCapturePhoto,
                     error: Error?) {
        if let error = error { print(error.localizedDescription) }
        guard let imageData = photo.fileDataRepresentation() else { return }
        if let imageToSave = UIImage(data: imageData) {
            UIImageWriteToSavedPhotosAlbum(imageToSave, nil, nil, nil)
        }
    }
}
