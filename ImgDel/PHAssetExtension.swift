//
//  PHAssetExtension.swift
//  ImgDel
//
//  Created by Yi on 2022/9/4.
//

import UIKit
import Photos

extension PHAsset {

    func getImage(size: CGSize) -> UIImage {
        var r = UIImage()
        let options = PHImageRequestOptions()
        options.isSynchronous = false
        options.isNetworkAccessAllowed = true
        options.resizeMode = .exact
        options.deliveryMode = .opportunistic
        PHImageManager.default().requestImage(for: self, targetSize: size, contentMode: .default, options: options) { img, _ in
            r = img ?? UIImage()
        }
        return r
    }

}

