//
//  PhotoCheck.swift
//  ImgDel
//
//  Created by Yi on 2022/9/4.
//

import Foundation
import Photos
import UIKit

func detectQRCode(_ image: UIImage) -> [CIFeature]? {
    if let ciImage = CIImage.init(image: image){
        let detector:CIDetector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        return detector.features(in: ciImage)
    }
    return nil
}

func checkPhoto(_ photo: UIImage) -> Bool {
    if let features = detectQRCode(photo), !features.isEmpty {
        for case _ as CIQRCodeFeature in features {
            return true
        }
    }
    return false
}
