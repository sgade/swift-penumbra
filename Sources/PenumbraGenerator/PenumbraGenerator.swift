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

    static func main() {
        guard let inputFileUrl = Bundle.module.url(forResource: "penumbra", withExtension: "tsv") else {
            print("ERROR: Cannot find source file penumbra.tsv")
            return
        }

        var outputDirectoryUrl: URL
        if #available(macOS 13.0, iOS 16.0, *) {
            outputDirectoryUrl = URL(filePath: FileManager.default.currentDirectoryPath)
                .appending(path: "Sources/Penumbra", directoryHint: .isDirectory)
        } else {
            outputDirectoryUrl = URL(fileURLWithPath: FileManager.default.currentDirectoryPath, isDirectory: true)
                .appendingPathComponent("Sources/Penumbra", isDirectory: true)
        }

        do {
            let parser = FileParser(file: inputFileUrl)
            try parser.load()
            print("Loaded \(parser.colors.count) colors.")

            let generator = FileGenerator(directory: outputDirectoryUrl)
            try generator.generateAndWrite(using: parser.colors)

            print("Written output to \(outputDirectoryUrl.path).")
        } catch {
            print("ERROR: \(error)")
        }
    }

}
