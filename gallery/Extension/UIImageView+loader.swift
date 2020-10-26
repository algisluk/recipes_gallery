//
//  UIImageView+loader.swift
//  gallery
//
//  Created by Algis on 18/10/2020.
//

import UIKit

extension UIImageView {
  func loadImage(at url: String) {
    UIImageLoader.loader.load(url, for: self)
  }

  func cancelImageLoad() {
    UIImageLoader.loader.cancel(for: self)
  }
}
