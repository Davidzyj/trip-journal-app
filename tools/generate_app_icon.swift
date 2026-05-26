import AppKit
import CoreGraphics
import Foundation

let root = URL(fileURLWithPath: FileManager.default.currentDirectoryPath)
let iconSet = root.appendingPathComponent("TripJournal/Resources/Assets.xcassets/AppIcon.appiconset")
let previewSet = root.appendingPathComponent("TripJournal/Resources/Assets.xcassets/AppIconPreview.imageset")

let sizes: [(String, Int)] = [
    ("Icon-20@2x.png", 40),
    ("Icon-20@3x.png", 60),
    ("Icon-29@2x.png", 58),
    ("Icon-29@3x.png", 87),
    ("Icon-40@2x.png", 80),
    ("Icon-40@3x.png", 120),
    ("Icon-60@2x.png", 120),
    ("Icon-60@3x.png", 180),
    ("Icon-1024.png", 1024)
]

func drawIcon(size: Int, url: URL) throws {
    let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!
    let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
    guard let context = CGContext(
        data: nil,
        width: size,
        height: size,
        bitsPerComponent: 8,
        bytesPerRow: size * 4,
        space: colorSpace,
        bitmapInfo: bitmapInfo
    ) else {
        throw NSError(domain: "Icon", code: 1)
    }

    let scale = CGFloat(size) / 1024.0

    let background = CGGradient(
        colorsSpace: colorSpace,
        colors: [
            NSColor(red: 0.00, green: 0.55, blue: 0.52, alpha: 1).cgColor,
            NSColor(red: 0.17, green: 0.24, blue: 0.68, alpha: 1).cgColor,
            NSColor(red: 1.00, green: 0.54, blue: 0.22, alpha: 1).cgColor
        ] as CFArray,
        locations: [0.0, 0.58, 1.0]
    )!
    context.drawLinearGradient(background, start: CGPoint(x: 0, y: size), end: CGPoint(x: size, y: 0), options: [])

    context.setFillColor(NSColor(red: 1.0, green: 0.88, blue: 0.52, alpha: 1).cgColor)
    let sun = CGRect(x: 690 * scale, y: 690 * scale, width: 170 * scale, height: 170 * scale)
    context.fillEllipse(in: sun)

    func path(_ points: [CGPoint], color: NSColor) {
        context.beginPath()
        context.move(to: CGPoint(x: points[0].x * scale, y: points[0].y * scale))
        for point in points.dropFirst() {
            context.addLine(to: CGPoint(x: point.x * scale, y: point.y * scale))
        }
        context.closePath()
        context.setFillColor(color.cgColor)
        context.fillPath()
    }

    path([
        CGPoint(x: 80, y: 265),
        CGPoint(x: 328, y: 585),
        CGPoint(x: 478, y: 430),
        CGPoint(x: 675, y: 760),
        CGPoint(x: 944, y: 265)
    ], color: NSColor(red: 0.92, green: 0.98, blue: 0.95, alpha: 1))

    path([
        CGPoint(x: 328, y: 585),
        CGPoint(x: 408, y: 502),
        CGPoint(x: 478, y: 430),
        CGPoint(x: 388, y: 615)
    ], color: NSColor(red: 0.68, green: 0.88, blue: 0.86, alpha: 1))

    context.setStrokeColor(NSColor.white.cgColor)
    context.setLineWidth(54 * scale)
    context.setLineCap(.round)
    context.setLineJoin(.round)
    context.beginPath()
    context.move(to: CGPoint(x: 230 * scale, y: 225 * scale))
    context.addCurve(
        to: CGPoint(x: 790 * scale, y: 330 * scale),
        control1: CGPoint(x: 360 * scale, y: 405 * scale),
        control2: CGPoint(x: 610 * scale, y: 85 * scale)
    )
    context.strokePath()

    context.setFillColor(NSColor.white.cgColor)
    let pinCenter = CGPoint(x: 535 * scale, y: 575 * scale)
    let pinRadius = 118 * scale
    context.fillEllipse(in: CGRect(x: pinCenter.x - pinRadius, y: pinCenter.y - pinRadius, width: pinRadius * 2, height: pinRadius * 2))
    path([
        CGPoint(x: 535, y: 312),
        CGPoint(x: 445, y: 505),
        CGPoint(x: 625, y: 505)
    ], color: .white)

    context.setFillColor(NSColor(red: 0.02, green: 0.47, blue: 0.45, alpha: 1).cgColor)
    context.fillEllipse(in: CGRect(x: pinCenter.x - 43 * scale, y: pinCenter.y - 43 * scale, width: 86 * scale, height: 86 * scale))

    guard let cgImage = context.makeImage() else {
        throw NSError(domain: "Icon", code: 2)
    }

    let bitmap = NSBitmapImageRep(cgImage: cgImage)
    bitmap.size = NSSize(width: size, height: size)
    guard let data = bitmap.representation(using: .png, properties: [:]) else {
        throw NSError(domain: "Icon", code: 3)
    }
    try data.write(to: url)
}

try FileManager.default.createDirectory(at: iconSet, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: previewSet, withIntermediateDirectories: true)

for (name, size) in sizes {
    try drawIcon(size: size, url: iconSet.appendingPathComponent(name))
}

try drawIcon(size: 256, url: previewSet.appendingPathComponent("AppIconPreview.png"))
