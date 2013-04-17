//
//  ViewController.m
//  CVPoissonBlend
//
//  Created by Varun Mulloli on 17/04/13.
//  Copyright (c) 2013 Varun Mulloli. All rights reserved.
//

#import "ViewController.h"
#import "poisson.h"

@implementation ViewController

- (IBAction)poissonBlend:(id)sender
{
    NSInteger tag = ((UIBarButtonItem *)sender).tag;
    
    NSString *image1 = [NSString stringWithFormat:@"image%d_1.jpg",tag];
    NSString *image2 = [NSString stringWithFormat:@"image%d_2.jpg",tag];
    Mat src = [self cvMatFromUIImage:[UIImage imageNamed:image1]];
    Mat dst = [self cvMatFromUIImage:[UIImage imageNamed:image2]];
    
    cvtColor(dst, dst, CV_RGBA2RGB);
    cvtColor(src, src, CV_RGBA2RGB);
    
    IplImage dest = dst;
    IplImage source = src;
    
    IplImage *image = poisson_blend(&dest, &source, 0,0);
    
    [imageView setImage:[self UIImageFromCVMat:Mat(image)]];
}

- (Mat)cvMatFromUIImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;
    
    Mat cvMat(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data, cols, rows, 8, cvMat.step[0], colorSpace,kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);
    CGColorSpaceRelease(colorSpace);
    
    return cvMat;
}

-(UIImage *)UIImageFromCVMat:(Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    // Creating CGImage from cv::Mat
    CGImageRef imageRef = CGImageCreate(cvMat.cols, cvMat.rows, 8,  8 * cvMat.elemSize(), cvMat.step[0], colorSpace, kCGImageAlphaNone|kCGBitmapByteOrderDefault, provider, NULL, false,kCGRenderingIntentDefault);
    
    // Getting UIImage from CGImage
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}

@end
