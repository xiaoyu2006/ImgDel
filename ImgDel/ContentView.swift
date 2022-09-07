//
//  ContentView.swift
//  ImgDel
//
//  Created by Yi on 2022/6/21.
//

import SwiftUI
import PhotosUI

struct Photo: Identifiable {
    var id: String {
        self.name
    }
    var name: String
    var asset: PHAsset
    var selected: Bool = true
    
    static func from(_ photo: PHAsset) -> Photo {
        return Photo(name: photo.localIdentifier, asset: photo)
    }
}

struct ProgressBar: View {
    @Binding var value: Float
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle().frame(width: geometry.size.width , height: geometry.size.height)
                    .opacity(0.3)
                    .foregroundColor(Color(UIColor.systemTeal))
                
                Rectangle().frame(width: min(CGFloat(self.value)*geometry.size.width, geometry.size.width), height: geometry.size.height)
                    .foregroundColor(Color(UIColor.systemBlue))
                    .animation(.linear)
            }.cornerRadius(45.0)
        }
    }
}

struct ContentView: View {
    @State var photos: [Photo]
    @State var scanning: Bool = false
    @State var scanningProcess: Float = 0

    fileprivate func scan() {
        if scanning { return }
        scanning = true

        photos = []
        Task {
            await PHPhotoLibrary.requestAuthorization(for: .readWrite)
            let fetched = PHAsset.fetchAssets(with: .image, options: nil)
            let s = fetched.count
            for i in 0 ..< s {
                scanningProcess = Float(i) / Float(s)
                let p = fetched.object(at: i)
                let img = p.getImage(size: CGSize(width: p.pixelWidth, height: p.pixelHeight))
                if (checkPhoto(img)) { photos.append(Photo.from(p)) }
            }
            scanning = false
            scanningProcess = 0
        }
    }
    
    fileprivate func del() {
        if scanning { return }
        var l: [PHAsset] = []
        for p in photos {
            if p.selected {
                l.append(p.asset)
            }
        }
        PHPhotoLibrary.shared().performChanges() {
            PHAssetChangeRequest.deleteAssets(l as NSFastEnumeration)
        }
        photos = []
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                ProgressBar(value: $scanningProcess).frame(height: 15)
                ForEach($photos) { p in
                    PhotoDisplay(displayed: p)
                }
            }
            .navigationTitle("ImgDel")
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Button("Scan") {
                    scan()
                }.foregroundColor(scanBtnColor)
                Button("Delete") {
                    del()
                }.foregroundColor(scanBtnColor)
                }
            }
        }
    }
    
    var scanBtnColor: Color {
        return scanning ? .gray : .accentColor
    }
}


struct PhotoDisplay: View {
    @Binding var displayed: Photo
    
    var body: some View {
        HStack {
            Image(uiImage: displayed.asset.getImage(size: CGSize(width: 60, height: 60)))
            Toggle(isOn: $displayed.selected) {}
        }
    }
}
