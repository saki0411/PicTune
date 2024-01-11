//
//  NewSignInedView.swift
//  sotsugyo
//
//  Created by saki on 2024/01/08.
//

import SwiftUI
import CoreNFC

struct ContentView: View {
    @ObservedObject var viewModel: MainContentModel
    @StateObject  var session = NFCSession()
    @StateObject var cameraManager: CameraManager
    @State private var selectedImage: UIImage?
    @State private var selectedIndex = 0
    @State private var tapDocumentId = ""
    @State private var showAlart = false
    @State private var folderBuf = ""
    @Binding var selectedFolderIndex: Int
    
    @Binding var isPresentingCamera: Bool
    @State var showQRAlart = false
    @State var isPresentingQR = false
    
    @State var isAlertShown = false
    @State var isSetting = false
    @State  var alertMessage = ""
    var textPayload2: NFCNDEFPayload?
    
    
    @Binding var DocumentId: String
    @Environment(\.dismiss) private var dismiss
    @State var first = true
    
    
    
    var body: some View {
        NavigationView {
            ZStack {
                self.backGroundColor().edgesIgnoringSafeArea(.all)
                VStack(alignment: .center, spacing: 12) {
                    
                    
                    ButtonView(viewModel: viewModel, cameraManager: cameraManager, selectedImage: $selectedImage, selectedIndex: $selectedIndex, tapDocumentId: $tapDocumentId, showAlart: $showAlart, folderBuf: $folderBuf, selectedFolderIndex: $selectedFolderIndex, isPresentingCamera: $isPresentingCamera, showQRAlart: $showQRAlart, isPresentingQR: $isPresentingQR)
                        .padding(.top, 10)
                    
                    VStack(alignment: .center, spacing: 8) {
                        HStack(alignment: .top, spacing: 8) {
                            VStack(alignment: .center, spacing: 0) {
                                
                                FolderContentView(viewModel: viewModel, selectedFolderIndex: $selectedIndex)
                                FolderTextView(viewModel: viewModel, selectedFolderIndex: $selectedIndex, userDataList: viewModel, folderDocument: $viewModel.folderDocument)
                                
                                
                                MainImageView(
                                    tapImage: $selectedImage,
                                    tapIndex: $selectedIndex,
                                    tapdocumentId: $tapDocumentId, selectedFolderIndex: $viewModel.folderDocument,
                                    viewModel: viewModel
                                )
                            }
                            .frame(maxWidth: .infinity, alignment: .top)
                            .cornerRadius(6)
                            
                            
                        }
                        .frame(maxWidth: .infinity, alignment: .topLeading)
                    }
                    .padding(.horizontal, 12)
                    
                    .frame(maxWidth: .infinity)
                    
                    
                    
                }
                .padding(.bottom, 12)
                .frame(width: 400, alignment: .top)
            }
            .navigationTitle("PicTune")
                       .navigationBarTitleDisplayMode(.inline)
                       .toolbar {
                           ToolbarItem(placement: .navigationBarTrailing) {
                               Button {
                                   isSetting.toggle()
                               } label: {
                                  Image(systemName: "gearshape.fill")
                               }
                           }
                       }
        }
       
        //      .background(Color(red: 1, green: 1, blue: 1))
        
        .fullScreenCover(isPresented: $isPresentingCamera) {
            Camera2View(isPresentingCamera: $isPresentingCamera, cameraManager: cameraManager, isPresentingSearch: .constant(true), friendUid: .constant(""))
        }
        .sheet(isPresented: $isPresentingQR){
            FriendQRView(isPresentingCamera: $isPresentingCamera, cameraManager: cameraManager, isPresentingQR: $isPresentingQR, friendUid:"")
            
        }
        .fullScreenCover(isPresented: $isSetting) {
         SettingView()
        }
        
        .onAppear {
            Task {
                if first == true{
                    try await viewModel.firstgetUrl()
                    try await viewModel.getFolder()
                    
                    try await viewModel.getDate()
                    
                    first = false
                } else {
                    try await viewModel.firstgetUrl()
                    try await viewModel.getFolder()
                }
            }
        }
    }
       private func backGroundColor() -> LinearGradient {
           let start = UnitPoint.init(x: 0, y: 0)
           let end = UnitPoint.init(x: 1, y: 1)

           let colors = Gradient(colors: [Color(red: 0.78, green: 0.83, blue: 0.98),
                                          Color(red: 0.89, green: 0.75, blue: 0.99)])

           let gradientColor = LinearGradient(gradient: colors, startPoint: start, endPoint: end)

           return gradientColor
       }
   
}