//
//  ColorDefinition.swift
//  PenumbraGenerator
//
//  Created by Sören Gade on 09.08.22.
//

import Foundation
import Stencil

struct ColorDefinition {

    public let set: Substring
    public let palette: Substring
    public let name: Substring
    public let rgb_hex: Substring
    public let r: Int
    public let g: Int
    public let b: Int
    public let h: Int
    public let s: Int
    public let l: Int
    public let oklab_luminance: Float

}
