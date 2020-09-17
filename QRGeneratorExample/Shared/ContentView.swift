//
//  ContentView.swift
//  Shared
//
//  Created by Youjin Phea on 17/09/20.
//

import SwiftUI
import SwiftQRGenerator

struct ContentView: View {

    @State private var qrcode = QR(withText: "Hi").image(withLength: 300)
    
    init() {
    }
    
    var body: some View {
        Text("Hello, world!")
            .padding()
            Image(uiImage: qrcode)
    }
}
