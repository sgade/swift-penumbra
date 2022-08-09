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

        public enum Penumbra {
    {% for setName, set in color-sets %}
            public enum {{ setName | capitalize | swift-identifier }} {
    {% for paletteName, palette in set %}
                public enum {{ paletteName | capitalize | swift-identifier }} {
    {% for color in palette %}
                    public static let {{ color.name | swift-identifier }} = Color(red: {{ color.r | byte-to-float }}, green: {{ color.g | byte-to-float }}, blue: {{ color.b | byte-to-float }})
    {% endfor %}
                }
    {% endfor %}
            }
    {% endfor %}
        }

    }
    """

    public let directory: URL

    private var stencilExtension: Extension {
        let ext = Extension()
        ext.registerFilter("swift-identifier") { value in
            guard let string = value as? any StringProtocol else {
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

    init(directory: URL) {
        self.directory = directory
    }

    public func generateAndWrite(using colors: [ColorDefinition]) throws {
        let targetName = "Penumbra"
        let templatesForFiles = [
            "Template+SwiftUI.swift.txt": "Penumbra+SwiftUI.swift",
            "Template+AppKit.swift.txt": "Penumbra+AppKit.swift",
            "Template+UIKit.swift.txt": "Penumbra+UIKit.swift"
        ]

        for (templateName, filename) in templatesForFiles {
            let contents = try generate(template: templateName,
                                        using: colors,
                                        targetName: targetName,
                                        filename: filename)

            var file: URL
            if #available(macOS 13.0, iOS 16.0, *) {
                file = directory.appending(path: filename, directoryHint: .notDirectory)
            } else {
                file = directory.appendingPathComponent(filename, isDirectory: false)
            }
            try contents.write(to: file, atomically: true, encoding: .utf8)
        }
    }

    func generate(template templateName: String,
                  using colors: [ColorDefinition],
                  targetName: String,
                  filename: String) throws -> String {
        let loader = FileSystemLoader(bundle: [Bundle.module])
        let extensions = [stencilExtension]

        let environment = Environment(loader: loader, extensions: extensions)
        let context: [String: Any] = [
            "targetName": targetName,
            "filename": filename,
            "color-sets": group(colors: colors)
        ]
        return try environment.renderTemplate(name: templateName, context: context)
    }

    private func group(colors: [ColorDefinition]) -> [Substring: [Substring: [ColorDefinition]]] {
        colors.group { $0.set }
            .mapValues {
                $0.group { $0.palette }
            }
    }

}

extension Sequence {

    public func group<Key>(using grouping: (Element) throws -> Key) rethrows -> [Key: [Element]] where Key: Hashable {
        try Dictionary(grouping: self, by: grouping)
    }

}
