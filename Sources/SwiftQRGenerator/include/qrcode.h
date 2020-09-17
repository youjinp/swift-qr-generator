//
//  Header.h
//  
//
//  Created by Youjin Phea on 17/09/20.
//

#import <Foundation/Foundation.h>
#import <qrcodegen.h>

NS_ASSUME_NONNULL_BEGIN

///Error correction level of the QR code
typedef NS_ENUM(NSInteger, QRCodeErrorCorrectionLevel) {
    low = 0,
    medium,
    quartile,
    high
};

@interface QRCode : NSObject
@property NSString *text;
@property int size;
-(id)initWithText:(NSString *)text andErrorCorrectionLevel:(QRCodeErrorCorrectionLevel)errorCorrectionLevel;
-(BOOL)getModuleForPositionX:(int)x andY:(int)y;
@end

NS_ASSUME_NONNULL_END
