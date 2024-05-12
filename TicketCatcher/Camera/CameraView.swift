//
//  CameraView.swift
//  TicketCatcher
//
//  Created by Yinwei Z on 12/28/23.
//

import SwiftUI

struct CameraView: UIViewRepresentable {
    let cameraController: CameraController
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        cameraController.setupPreviewLayer(in: view)
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        //do nothing
    }
}
