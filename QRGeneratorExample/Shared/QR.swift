//
//  QR.swift
//  QRGeneratorExample
//
//  Created by Youjin Phea on 17/09/20.
//

import Foundation
import SwiftQRGenerator
import UIKit

public struct QR {
    
    public private (set) var text: String
    public private (set) var moduleSpacingPercent: CGFloat
    public private (set) var color: UIColor
    public private (set) var errorCorrectionLevel: ErrorCorrectionLevel {
        didSet {
            //update QR code
            self.updateQR()
        }
    }

    private var qr: QRCode
    
    public init(withText text: String,
                moduleSpacingPercent: CGFloat = 0.003,
                color: UIColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1),
                errorCorrectionLevel: ErrorCorrectionLevel = .medium) {
        self.text = text
        self.color = color
        self.errorCorrectionLevel = errorCorrectionLevel
        self.qr = QRCode(text: text, andErrorCorrectionLevel: errorCorrectionLevel.objcRepresentation);
        
        //verifiy whether we can use the given module spacing or not (we can use a module spacing that results at least in a module width/height of zero!)
        if (0.0...1.0).contains(moduleSpacingPercent*CGFloat(self.qr.size)) {
            self.moduleSpacingPercent = moduleSpacingPercent
        }
        else {
            self.moduleSpacingPercent = 0.0 //no module spacing otherwise
        }
    }
    
    private mutating func updateQR() {
        self.qr = QRCode(text: text, andErrorCorrectionLevel: self.errorCorrectionLevel.objcRepresentation);
    }
        
}

// MARK: - Private functions
extension QR {
    private func image(fromRenderer renderer: UIGraphicsImageRenderer) -> UIImage {
        ///The bounds of the image where we draw in
        let bounds = renderer.format.bounds
        
        //render the image and return it
        ///NOTE: UIKit configures the cgContext of the renderer in a way that it draws from top left corner, not from bottom left!!!
        return renderer.image { (ctx) in
            
            //draw modules
            for x in 0..<qr.size {
                for y in 0..<qr.size {
                    //only draw if that position should be black
                    guard self.qr.getModuleForPositionX(Int32(x), andY: Int32(y)) else {
                        continue
                    }
                    
                    //draw the actual module
                    let size = bounds.size
                    let moduleSpacing = size.width * moduleSpacingPercent
                    let moduleLength = (size.width-CGFloat(qr.size-1)*moduleSpacing) / CGFloat(qr.size)
                    let unitLength = moduleLength + moduleSpacing
                    let position = CGPoint(x: CGFloat(x) * unitLength, y: CGFloat(y) * unitLength)
                    let rect = CGRect(origin: position, size: CGSize(width: moduleLength, height: moduleLength))
                    
                    ctx.cgContext.setFillColor(UIColor.black.cgColor)
                    ctx.cgContext.fillEllipse(in: rect)
                }
            }
        }
    }
    
    ///Returns an image that has the size in points as specified by the length parameter
    ///The scale factor determines how many pixels per point
    public func image(withLength length: CGFloat, scale: CGFloat = UIScreen.main.scale) -> UIImage {
        
        //define the size of the image (in POINTS)
        let size = CGSize(width: length, height: length)
        
        //create the renderer for the given length and scale
        
        ///The renderer for the image
        let rendererFormat = UIGraphicsImageRendererFormat(for: UIScreen.main.traitCollection)
        rendererFormat.scale = scale
        
        let renderer = UIGraphicsImageRenderer(size: size, format: rendererFormat)

        //return...
        return image(fromRenderer: renderer)
    }
}

//MARK: - error correction level
public extension QR {

    //A one-to-one mapping to QRCodeErrorCorrectionLevel
    enum ErrorCorrectionLevel: CaseIterable {
        case low
        case medium
        case quartile
        case high
        
        var higher: ErrorCorrectionLevel? {
            return ErrorCorrectionLevel.allCases[ErrorCorrectionLevel.allCases.index(after: ErrorCorrectionLevel.allCases.firstIndex(of: self)!)]
        }
        
        fileprivate var objcRepresentation: QRCodeErrorCorrectionLevel {
            switch self {
            case .low: return .low
            case .medium: return .medium
            case .quartile: return .quartile
            case .high: return .high
            }
        }
    }
}
