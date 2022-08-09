//
//  PenumbraGenerator.swift
//  PenumbraGenerator
//
//  Created by Sören Gade on 09.08.22.
//

import Foundation

@main
class PenumbraGenerator {

    static let inputFilename = "penumbra.tsv"
    static let outputFilename = "Penumbra.swift"

    static func main() {
        guard let inputFileUrl = Bundle.module.url(forResource: "penumbra", withExtension: "tsv") else {
            print("ERROR: Cannot find source file penumbra.tsv")
            return
        }

        var outputFileUrl: URL
        if #available(macOS 13.0, *) {
            outputFileUrl = URL(filePath: FileManager.default.currentDirectoryPath)
                .appending(path: "Sources/Penumbra", directoryHint: .isDirectory)
                .appending(path: outputFilename, directoryHint: .notDirectory)
        } else {
            outputFileUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
                .appendingPathComponent("Sources/Penumbra", isDirectory: true)
                .appendingPathComponent(outputFilename, isDirectory: false)
        }

        do {
            let parser = FileParser(file: inputFileUrl)
            try parser.load()
            print("Loaded \(parser.colors.count) colors.")

            let generator = FileGenerator(file: outputFileUrl)
            try generator.generateAndWrite(using: parser.colors)
            
            print("Written to \(outputFileUrl.path).")
        } catch {
            print("ERROR: \(error)")
        }
    }

}
