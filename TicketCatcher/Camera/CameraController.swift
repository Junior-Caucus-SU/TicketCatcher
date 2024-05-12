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
        print("initializing cam")
        super.init()
        setupCamera()
    }

    func setupPreviewLayer(in view: UIView) {
            DispatchQueue.main.async {
                if self.captureSession == nil {
                    print("no capture sesh. setting up camera.")
                    self.setupCamera()
                }
                guard let videoDevice = AVCaptureDevice.default(for: .video),
                      let videoInput = try? AVCaptureDeviceInput(device: videoDevice),
                      self.captureSession.canAddInput(videoInput) else {
                    print("faulty video input")
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
                    self.captureSession.startRunning()//NEED TO FIX TO CALL ON BACKGROUND THREAD!!!
                    print("capture session started on main")
                }
            }
        }

        private func setupCamera() {
            captureSession = AVCaptureSession()
            captureSession.sessionPreset = .photo
        }

        private func configureMetadataOutput() {
            let metadataOutput = AVCaptureMetadataOutput()
            if captureSession.canAddOutput(metadataOutput) {
                captureSession.addOutput(metadataOutput)
                metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
                metadataOutput.metadataObjectTypes = [.qr, .code128]
            } else {
                print("failed to add metadata")
            }
        }

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        if let metadataObject = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
           let stringValue = metadataObject.stringValue,
           let barcodeValue = Int(stringValue) {
            BarcodeValidator.validate(barcode: barcodeValue) { isValid in
                DispatchQueue.main.async {
                    self.barcodeString = isValid ? "\(barcodeValue)" : "Invalid Ticket"
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
                print("capture sesh restarted")
            }
        }
    }
    
    func stopCamera() {
        DispatchQueue.main.async {
            if self.captureSession.isRunning {
                self.captureSession.stopRunning()
                print("camera stopped")
            }
        }
    }
}
