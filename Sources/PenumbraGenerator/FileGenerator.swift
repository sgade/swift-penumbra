//
//  FileGenerator.swift
//  PenumbraGenerator
//
//  Created by Sören Gade on 09.08.22.
//

import Foundation
import Stencil

class FileGenerator {

    let colorTemplate = """
    // This file is generated. Edits will be overwritten.

    import SwiftUI

    extension Color {
        {% for color in colors %}
        static let penumbra{{ color.set | capitalize | swift-identifier }}{{ color.palette | capitalize | swift-identifier }}{{ color.name | capitalize | swift-identifier }} = Color(red: {{ color.r | byte-to-float }}, green: {{ color.g | byte-to-float }}, blue: {{ color.b | byte-to-float }})
        {% endfor %}
    }
    """

    public let file: URL

    private var stencilExtension: Extension {
        let ext = Extension()
        ext.registerFilter("swift-identifier") { value in
            guard let string = value as? String else {
                return value
            }

            return string
                .replacingOccurrences(of: "+", with: "Plus")
                .replacingOccurrences(of: "-", with: "Minus")
        }
        ext.registerFilter("byte-to-float") { value in
            guard let int = value as? Int else {
                return value
            }

            return Double(int) / 255.0
        }

        return ext
    }

    init(file: URL) {
        self.file = file
    }

    public func generateAndWrite(using colors: [ColorDefinition]) throws {
        let contents = try generate(using: colors)
        try contents.write(to: file, atomically: true, encoding: .utf8)
    }

    func generate(using colors: [ColorDefinition]) throws -> String {
        let loader = DictionaryLoader(templates: ["colors": colorTemplate])
        let extensions = [stencilExtension]

        let environment = Environment(loader: loader, extensions: extensions)
        let context = [
            "colors": colors
        ]
        return try environment.renderTemplate(name: "colors", context: context)
    }

}
