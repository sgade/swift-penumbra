//
//  FileParser.swift
//  PenumbraGenerator
//
//  Created by Sören Gade on 09.08.22.
//

import Foundation

class FileParser {

    public let file: URL
    public private(set) var colors: [ColorDefinition] = []

    init(file: URL) {
        self.file = file
    }

    public func load() throws {
        let contents = try String(contentsOf: file, encoding: .utf8)
        var lines = contents.split(separator: "\n")
        // remove header
        lines.remove(at: lines.startIndex)

        colors = try lines.map { try parse(line: $0) }
    }

    private func parse(line: Substring) throws -> ColorDefinition {
        let columns = line.split(separator: "\t")

        return ColorDefinition(set: columns[0],
                               palette: columns[1],
                               name: columns[2],
                               rgb_hex: columns[3],
                               r: try columns[4].convert(),
                               g: try columns[5].convert(),
                               b: try columns[6].convert(),
                               h: try columns[7].convert(),
                               s: try columns[8].convert(),
                               l: try columns[9].convert(),
                               oklab_luminance: try columns[10].convert())
    }

}

extension Substring {

    public func convert() throws -> Int {
        try convert { string in
            Int(string)
        }
    }

    public func convert() throws -> Float {
        try convert { string in
            Float(string)
        }
    }

    private func convert<T: Numeric>(using converter: (String) -> T?) throws -> T {
        let string = String(self)
        guard let value = converter(string) else {
            throw PenumbraGeneratorError.impossibleNumberConversion(string: string)
        }
        return value
    }

}
