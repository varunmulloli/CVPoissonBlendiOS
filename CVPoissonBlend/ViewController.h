//
//  ViewController.h
//  CVPoissonBlend
//
//  Created by Varun Mulloli on 17/04/13.
//  Copyright (c) 2013 Varun Mulloli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <opencv2/opencv.hpp>
#import <opencv2/stitching/detail/blenders.hpp>
#include <vector>

using namespace cv;

@interface ViewController : UIViewController
{
    IBOutlet UIImageView *imageView;
}

- (IBAction)poissonBlend:(id)sender;

@end
