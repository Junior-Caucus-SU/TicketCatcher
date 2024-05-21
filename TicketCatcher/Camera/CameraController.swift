//
//  CameraController.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 10/28/23.
//

import SwiftUI
import AVFoundation

class CameraController: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    @Published var barcodeString: String = "Place Barcode in View to Scan"
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override init() {
        LogManager.shared.log("Initializing camera")
        super.init()
        setupCamera()
    }
    
    ///Set up a capture session
    func setupPreviewLayer(in view: UIView) {
        DispatchQueue.main.async {
            if self.captureSession == nil {
                LogManager.shared.log("No capture session yet, setting up the camera")
                self.setupCamera()
            }
            guard let videoDevice = AVCaptureDevice.default(for: .video),
                  let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                  self.captureSession.canAddInput(videoInput) else {
                LogManager.shared.log("Faulty video input")
                return
            }
            
            if self.captureSession.inputs.isEmpty {
                self.captureSession.addInput(videoInput)
            }
            self.configureMetadataOutput()
            
            self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
            self.previewLayer.frame = view.bounds
            self.previewLayer.videoGravity = .resizeAspectFill
            view.layer.addSublayer(self.previewLayer)
            if !self.captureSession.isRunning {
                DispatchQueue.global(qos: .background).async {
                    self.captureSession.startRunning()
                    LogManager.shared.log("Starting new capture session")
                }
            }
        }
    }
    
    ///Prepare the camera
    private func setupCamera() {
        captureSession = AVCaptureSession()
        captureSession.sessionPreset = .photo
    }
    
    ///Identify the desired metadata to capture
    private func configureMetadataOutput() {
        let metadataOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr, .code128]
        } else {
            LogManager.shared.log("Failed to add metadata")
        }
    }
    
    ///Output the recognized barcode
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let barcodeSessionIDString = metadataObject.stringValue {
            BarcodeValidator.validate(SessionID: barcodeSessionIDString) { isValid in
                DispatchQueue.main.async {
                    self.barcodeString = isValid ? "\(barcodeSessionIDString)" : "Invalid or Used Ticket"
                }
            }
        }
    }
    
    func resetBarcode() {
        DispatchQueue.main.async {
            self.barcodeString = "Place Barcode in View to Scan"
        }
    }
    
    func restartCameraSession() {
        DispatchQueue.global(qos: .userInitiated).async {
            if !self.captureSession.isRunning {
                self.captureSession.startRunning()
                LogManager.shared.log("Capture session restarted")
            }
        }
    }
    
    func stopCamera() {
        DispatchQueue.main.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                LogManager.shared.log("Camera stopped")
            }
        }
    }
}
